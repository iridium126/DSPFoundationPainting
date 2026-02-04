#include "DataAccessor.h"

DataAccessor::DataAccessor(DataContainer& container) :container(container)
{
}

DataAccessor::~DataAccessor()
{
}

bool DataAccessor::ProcessPicture(const QString& fileName)
{
	QImage input(fileName);
	if (input.isNull())
		return false;
	int width = input.width();
	int height = input.height();
	int min_side = std::min(width, height);
	int offset_i = (height - min_side) / 2;
	int offset_j = (width - min_side) / 2;
	input = input.convertToFormat(QImage::Format_ARGB32);
	QImage output(4096, 5088, QImage::Format_ARGB32);
	output.fill(Qt::transparent);
	for (auto& tile : container.data)
	{
		const QRgb* line_in = reinterpret_cast<const QRgb*>(input.constScanLine(offset_i + tile.uv.x() * min_side));
		QRgb* line_out = reinterpret_cast<QRgb*>(output.scanLine(tile.texture_pos.x()));
		line_out[tile.texture_pos.y()] = line_in[static_cast<int>(offset_j + tile.uv.y() * min_side)];
	}
	output.save(fileName.left(fileName.lastIndexOf('.')) + "_texture.png");
	return true;
}
