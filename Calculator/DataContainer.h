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
	TileData(const QPointF& uv, const QPoint& pos);
private:
	static constexpr uint32_t FIXED_SCALE = (1 << 19) - 1;
	uint64_t packed_data; // 将uv坐标和纹理坐标打包成一个64位整数，节省空间
	const qreal u() const;
	const qreal v() const;
	const int x() const;
	const int y() const;
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
	qreal polar_angle, azimuth_angle; // 极角、方位角
	qreal painting_central_angle;     // 图片在球面上的边界的直径所对的圆心角
private:
	std::vector<TileData> data;
	QByteArray get_file_name() const;
};