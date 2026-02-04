#include "Calculator.h"
#include <QtWidgets/QApplication>

int main(int argc, char* argv[])
{
	//DataContainer container(0, 0, M_PI_2);
	//DataAccessor accessor(container);
	//accessor.ProcessPicture("D:/test.jpg");
	QApplication app(argc, argv);
	Calculator window;
	window.show();
	return app.exec();
}
