#pragma once
#include <vector>
#include <fstream>
#include <QPointF>
#include <QDir>
#include <QCryptographicHash>

class DataGenerator;
class DataAccessor;

class TileData
{
	friend DataGenerator;
	friend DataAccessor;
public:
	TileData() = default;
	TileData(const QPointF& uv, const QPoint& pos) :uv(uv), texture_pos(pos) {}
private:
	QPointF uv;
	QPoint texture_pos; // 瓦片在纹理中的像素坐标
};

class DataContainer
{
	friend DataGenerator;
	friend DataAccessor;
public:
	DataContainer(qreal polar_angle, qreal azimuth_angle, qreal painting_central_angle);
	~DataContainer();
	bool Load();
	void Save();

private:
	qreal polar_angle, azimuth_angle; // 极角、方位角
	qreal painting_central_angle;     // 图片在球面上的边界的直径所对的圆心角
	std::vector<TileData> data;

	QByteArray get_file_name() const;
};