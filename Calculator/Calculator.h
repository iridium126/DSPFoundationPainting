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

class Calculator : public QMainWindow
{
	Q_OBJECT

public:
	Calculator(QWidget* parent = nullptr);
	~Calculator();

private:
	Ui::CalculatorClass ui;

	void addDmsSlider(QVBoxLayout* mainLayout,
		int minValue, int maxValue, int defaultValue,
		const QString& regExpStr,
		std::function<QString(int)> minuteToStr,
		std::function<int(const QString&)> strToMinute);
};

