#pragma once

#include <QtWidgets/QMainWindow>
#include "ui_Calculator.h"
#include "DataAccessor.h"
#include <QBoxLayout>
#include <QLabel>
#include <QLineEdit>
#include <QSlider>
#include <QRegularExpression>
#include <QRegularExpressionValidator>
#include <QPushButton>
#include <QFileDialog>
#include <QCheckBox>

class Calculator : public QMainWindow
{
	Q_OBJECT

public:
	Calculator(QWidget* parent = nullptr);
	~Calculator();
	static int thread_count;
	static QThreadPool* computePool;
	static bool useGPU;
	static bool saveIntermediate;

private:
	Ui::CalculatorClass ui;
	std::unique_ptr<DataContainer> container;
	std::unique_ptr<DataAccessor> accessor;

	void addDmsSlider(QVBoxLayout* mainLayout, QSlider*& slider,
		int minValue, int maxValue, int defaultValue,
		const QString& regExpStr,
		std::function<QString(int)> minuteToStr,
		std::function<int(const QString&)> strToMinute);
};

