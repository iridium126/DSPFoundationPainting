#include "Calculator.h"
#include <QtWidgets/QApplication>
#include "DataGenerator.h"

int main(int argc, char* argv[])
{
	DataContainer container(M_PI/3, 0, M_PI/9*8);
	DataGenerator generator(container);
	QApplication app(argc, argv);
	Calculator window;
	window.show();
	return app.exec();
}
