#include "Calculator.h"
#include <QtWidgets/QApplication>
#include "DataGenerator.h"
#include "DataAccessor.h"

int main(int argc, char* argv[])
{
	DataContainer container(0, 0, M_PI_2);
	DataGenerator generator(container);
	DataAccessor accessor(container);
	accessor.ProcessPicture("D:/test.jpg");
	QApplication app(argc, argv);
	Calculator window;
	window.show();
	return app.exec();
}
