#include "Calculator.h"

int Calculator::thread_count = QThread::idealThreadCount() - 1;
QThreadPool* Calculator::computePool = nullptr;
bool Calculator::useGPU = true;
bool Calculator::saveIntermediate = false;

Calculator::Calculator(QWidget* parent)
	: QMainWindow(parent)
{
	ui.setupUi(this);
	// 创建计算线程池，默认线程数为CPU核心数-1，保留一个核心给UI线程
	if (!computePool)
	{
		computePool = new QThreadPool(this);
		computePool->setMaxThreadCount(thread_count);
	}
	QWidget* centralWgt = new QWidget(this);
	QVBoxLayout* vMainLayout = new QVBoxLayout(centralWgt);
	setCentralWidget(centralWgt);
	vMainLayout->setContentsMargins(20, 20, 20, 20);
	vMainLayout->setSpacing(20);

	// 文件选择框
	QHBoxLayout* fileLayout = new QHBoxLayout();
	QLineEdit* fileEdit = new QLineEdit(tr("未选择图片"), this);
	QPushButton* fileBtn = new QPushButton(tr("选择图片"), this);

	fileLayout->addWidget(fileEdit, 3);
	fileLayout->addWidget(fileBtn, 1);
	fileLayout->setSpacing(15);

	connect(fileBtn, &QPushButton::clicked, this, [=]() {
		QString fileName = QFileDialog::getOpenFileName(this, tr("选择图片"));
		if (!fileName.isEmpty()) {
			fileEdit->setText(fileName);
		}
		});
	vMainLayout->addLayout(fileLayout);

	// 纬度滑动条
	QSlider* latSlider;
	const int MIN_LAT_MIN = -5400;
	const int MAX_LAT_MIN = 5400;
	const int DEFAULT_LAT_MIN = 0;
	const QString LAT_REG = R"(^(90°00[′']?[NSns]|([0-8]?\d)°([0-5]?\d)[′']?[NSns])$)";
	addDmsSlider(vMainLayout, latSlider, MIN_LAT_MIN, MAX_LAT_MIN, DEFAULT_LAT_MIN, LAT_REG,
		// 纬度字符串格式化
		[](int total_minute) {
			QChar dir = (total_minute >= 0) ? 'N' : 'S';
			int abs_min = abs(total_minute);
			int deg = abs_min / 60;
			int min = abs_min % 60;
			return QString("%1°%2'%3").arg(deg).arg(min, 2, 10, QChar('0')).arg(dir);
		},
		// 纬度字符串解析
		[](const QString& dms_str) {
			QRegularExpression reg(R"((\d+)[°|′'](\d+)[′']?([NSns]))");
			QRegularExpressionMatch match = reg.match(dms_str.trimmed());
			if (!match.hasMatch())
				return INT_MAX;
			int deg = match.captured(1).toInt();
			int min = match.captured(2).toInt();
			QChar dir = match.captured(3).at(0).toUpper();
			int total_min = deg * 60 + min;
			if (dir == 'S')
				total_min = -total_min;
			return total_min;
		}
	);

	// 经度滑动条
	QSlider* lonSlider;
	const int MIN_LON_MIN = -10800;
	const int MAX_LON_MIN = 10800;
	const int DEFAULT_LON_MIN = 0;
	const QString LON_REG = R"(^(180°00[′']?[EWew]|(1[0-7]\d|0?\d{1,2})°([0-5]?\d)[′']?[EWew])$)";
	addDmsSlider(vMainLayout, lonSlider, MIN_LON_MIN, MAX_LON_MIN, DEFAULT_LON_MIN, LON_REG,
		// 经度字符串格式化
		[](int total_minute) {
			QChar dir = (total_minute >= 0) ? 'E' : 'W';
			int abs_min = abs(total_minute);
			int deg = abs_min / 60;
			int min = abs_min % 60;
			return QString("%1°%2'%3").arg(deg).arg(min, 2, 10, QChar('0')).arg(dir);
		},
		// 经度字符串解析
		[](const QString& dms_str) {
			QRegularExpression reg(R"((\d+)[°|′'](\d+)[′']?([EWew]))");
			QRegularExpressionMatch match = reg.match(dms_str.trimmed());
			if (!match.hasMatch())
				return INT_MAX;
			int deg = match.captured(1).toInt();
			int min = match.captured(2).toInt();
			QChar dir = match.captured(3).at(0).toUpper();
			int total_min = deg * 60 + min;
			if (dir == 'W')
				total_min = -total_min;
			return total_min;
		}
	);

	// 角度滑动条
	QSlider* degSlider;
	const int MIN_DEG = 0;
	const int MAX_DEG = 18000;
	const int DEFAULT_DEG = 12000;
	const QString DEG_REG = R"(^([0-9]{1,3}(?:\.[0-9]{1,2})?)°$)";
	addDmsSlider(vMainLayout, degSlider, MIN_DEG, MAX_DEG, DEFAULT_DEG, DEG_REG,
		[](int value) {
			qreal deg = value / 100.0;
			return QString::number(deg, 'f', 2) + QChar(0x00B0);
		},
		[](const QString& text) {
			QRegularExpression reg(R"(^([0-9]{1,3}(?:\.[0-9]{1,2})?)°$)");
			QRegularExpressionMatch match = reg.match(text.trimmed());
			if (!match.hasMatch())
				return INT_MAX;
			qreal deg = match.captured(1).toDouble();
			return static_cast<int>(deg * 100 + 0.5);
		}
	);

	// 开始计算按钮
	QPushButton* generateTexBtn = new QPushButton(tr("生成纹理"), this);
	vMainLayout->addWidget(generateTexBtn);
	connect(generateTexBtn, &QPushButton::clicked, this, [=]() {
		qreal theta = M_PI_2 - latSlider->value() * M_PI / MAX_LAT_MIN / 2;
		qreal phi = lonSlider->value() * M_PI / MAX_LON_MIN;
		if (phi < 0)
			phi += 2 * M_PI;
		qreal central_angle = degSlider->value() * M_PI / MAX_DEG;
		if (thread_count > 1)
			computePool->setMaxThreadCount(thread_count);
		if (container == nullptr || container->polar_angle != theta || container->azimuth_angle != phi ||
			container->painting_central_angle != central_angle)
		{
			container = std::make_unique<DataContainer>(theta, phi, central_angle);
			accessor = std::make_unique<DataAccessor>(*container);
		}
		accessor->ProcessPicture(fileEdit->text());
		});

	// 线程数滑动条
	QHBoxLayout* threadLayout = new QHBoxLayout();
	QLabel* threadLabel = new QLabel(tr("线程数:"), this);
	QSlider* threadSlider = new QSlider(Qt::Horizontal, this);
	QLineEdit* threadEdit = new QLineEdit(QString::number(thread_count), this);

	const int MIN_THREAD = 1;
	const int MAX_THREAD = QThread::idealThreadCount();
	threadSlider->setRange(MIN_THREAD, MAX_THREAD);
	threadSlider->setValue(thread_count);
	threadSlider->setSingleStep(1);
	threadEdit->setValidator(new QIntValidator(MIN_THREAD, MAX_THREAD, this));

	threadLayout->addWidget(threadLabel);
	threadLayout->addWidget(threadSlider, 3);
	threadLayout->addWidget(threadEdit, 1);
	threadLayout->setSpacing(15);

	connect(threadSlider, &QSlider::valueChanged, this, [=](int value) {
		threadEdit->setText(QString::number(value));
		Calculator::thread_count = value;
		});
	connect(threadEdit, &QLineEdit::textChanged, this, [=](const QString& text) {
		bool ok = false;
		int value = text.toInt(&ok);
		if (ok && value >= MIN_THREAD && value <= MAX_THREAD) {
			threadSlider->setValue(value);
			Calculator::thread_count = value;
		}
		});

	vMainLayout->addLayout(threadLayout);

	// 复选框布局
	QHBoxLayout* checkBoxLayout = new QHBoxLayout();
	QCheckBox* gpuCheckBox = new QCheckBox(tr("使用GPU加速"), this);
	QCheckBox* saveCheckBox = new QCheckBox(tr("保存中间数据"), this);

	gpuCheckBox->setChecked(Calculator::useGPU);
	saveCheckBox->setChecked(Calculator::saveIntermediate);

	checkBoxLayout->addWidget(gpuCheckBox);
	checkBoxLayout->addWidget(saveCheckBox);
	checkBoxLayout->setSpacing(30);

	connect(gpuCheckBox, &QCheckBox::toggled, this, [](bool checked) {
		Calculator::useGPU = checked;
		});
	connect(saveCheckBox, &QCheckBox::toggled, this, [](bool checked) {
		Calculator::saveIntermediate = checked;
		});

	vMainLayout->addLayout(checkBoxLayout);
}

Calculator::~Calculator()
{
	if (computePool)
		computePool->waitForDone();
}

void Calculator::addDmsSlider(QVBoxLayout* mainLayout, QSlider*& slider,
	int minValue, int maxValue, int defaultValue,
	const QString& regExpStr,
	std::function<QString(int)> minuteToStr,
	std::function<int(const QString&)> strToMinute)
{
	QLineEdit* edit = new QLineEdit(this);
	slider = new QSlider(Qt::Horizontal, this);
	QRegularExpression regExp(regExpStr);
	edit->setValidator(new QRegularExpressionValidator(regExp, this));
	edit->setText(minuteToStr(defaultValue));

	slider->setRange(minValue, maxValue);
	slider->setValue(defaultValue);
	slider->setSingleStep(1);

	QHBoxLayout* hLayout = new QHBoxLayout();
	hLayout->addWidget(slider, 3);
	hLayout->addWidget(edit, 1);
	hLayout->setSpacing(15);

	// 滑动条 -> 输入框
	connect(slider, &QSlider::valueChanged, this, [=](int totalMin) {
		QString dmsStr = minuteToStr(totalMin);
		edit->setText(dmsStr);
		});

	// 输入框 -> 滑动条
	connect(edit, &QLineEdit::textChanged, this, [=](const QString& text) {
		if (!text.isEmpty())
		{
			int totalMin = strToMinute(text);
			if (totalMin >= minValue && totalMin <= maxValue) {
				slider->setValue(totalMin);
			}
		}
		});

	mainLayout->addLayout(hLayout);
}