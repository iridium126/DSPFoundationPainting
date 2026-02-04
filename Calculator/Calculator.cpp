#include "Calculator.h"

Calculator::Calculator(QWidget* parent)
	: QMainWindow(parent)
{
	ui.setupUi(this);
	QWidget* centralWgt = new QWidget(this);
	QVBoxLayout* vMainLayout = new QVBoxLayout(centralWgt);
	setCentralWidget(centralWgt);
	vMainLayout->setContentsMargins(20, 20, 20, 20);
	vMainLayout->setSpacing(20);

	// 纬度滑动条
	const int MIN_LAT_MIN = -5400;
	const int MAX_LAT_MIN = 5400;
	const int DEFAULT_LAT_MIN = 0;
	const QString LAT_REG = R"(^(90°00[′']?[NSns]|([0-8]?\d)°([0-5]?\d)[′']?[NSns])$)";
	addDmsSlider(vMainLayout, MIN_LAT_MIN, MAX_LAT_MIN, DEFAULT_LAT_MIN, LAT_REG,
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
				return 0;
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
	const int MIN_LON_MIN = -10800;
	const int MAX_LON_MIN = 10800;
	const int DEFAULT_LON_MIN = 0;
	const QString LON_REG = R"(^(180°00[′']?[EWew]|(1[0-7]\d|0?\d{1,2})°([0-5]?\d)[′']?[EWew])$)";
	addDmsSlider(vMainLayout, MIN_LON_MIN, MAX_LON_MIN, DEFAULT_LON_MIN, LON_REG,
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
				return 0;
			int deg = match.captured(1).toInt();
			int min = match.captured(2).toInt();
			QChar dir = match.captured(3).at(0).toUpper();
			int total_min = deg * 60 + min;
			if (dir == 'W')
				total_min = -total_min;
			return total_min;
		}
	);
}

Calculator::~Calculator()
{
}

void Calculator::addDmsSlider(QVBoxLayout* mainLayout,
	int minValue, int maxValue, int defaultValue,
	const QString& regExpStr,
	std::function<QString(int)> minuteToStr,
	std::function<int(const QString&)> strToMinute)
{
	QLineEdit* edit = new QLineEdit(this);
	QSlider* slider = new QSlider(Qt::Horizontal, this);
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