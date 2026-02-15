#pragma once
#include "DataContainer.h"
#include <QImage>
#include <png.h>

class DataAccessor
{
public:
	DataAccessor(DataContainer& container);
	~DataAccessor();
	bool ProcessPicture(const QString& fileName);
private:
	DataContainer& container;
	static QImage output;
	static bool foundation_mask[325632]; // 使用静态存储区，提高性能
	void generate_foundation_mask(const uchar* bits, int startFNDRow, int endFNDRow);
	std::vector<uint8_t> pack_bools_to_bytes();
	bool write_texture(const QString& filePath, const QImage& image);
};
