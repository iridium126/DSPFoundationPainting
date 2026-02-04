#pragma once
#include "DataContainer.h"
#include <QImage>

class DataAccessor
{
public:
	DataAccessor(DataContainer& container);
	~DataAccessor();
	bool ProcessPicture(const QString& fileName);

private:
	DataContainer& container;
};
