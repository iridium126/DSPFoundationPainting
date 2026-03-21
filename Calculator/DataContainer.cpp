#include "DataContainer.h"
#include "DataGenerator.h"

TileData::TileData(const QPointF& uv, const QPoint& pos)
{
	// 0~1浮点数转19位无符号定点数
	uint32_t u_fixed = static_cast<uint32_t>(uv.x() * FIXED_SCALE);
	uint32_t v_fixed = static_cast<uint32_t>(uv.y() * FIXED_SCALE);
	packed_data = (static_cast<uint64_t>(u_fixed) << 45) | (static_cast<uint64_t>(pos.x()) << 32) | (static_cast<uint64_t>(v_fixed) << 13) | static_cast<uint64_t>(pos.y());
}

const qreal TileData::u() const
{
	uint32_t u_fixed = (packed_data >> 45) & 0x7FFFF;
	return static_cast<qreal>(u_fixed) / FIXED_SCALE;
}

const qreal TileData::v() const
{
	uint32_t v_fixed = (packed_data >> 13) & 0x7FFFF;
	return static_cast<qreal>(v_fixed) / FIXED_SCALE;
}

const int TileData::x() const
{
	return (packed_data >> 32) & 0x1FFF;
}

const int TileData::y() const
{
	return packed_data & 0x1FFF;
}

DataContainer::DataContainer(qreal polar_angle, qreal azimuth_angle, qreal painting_central_angle) :
	polar_angle(polar_angle), azimuth_angle(azimuth_angle), painting_central_angle(painting_central_angle)
{
	if (!Load())
	{
		DataGenerator generator(*this);
		Save();
	}
}

DataContainer::~DataContainer()
{
}

bool DataContainer::Load()
{
	std::ifstream fin(get_file_name(), std::ios::binary);
	if (!fin.is_open())
		return false;
	qreal loaded_polar_angle, loaded_azimuth_angle, loaded_painting_central_angle;
	fin.read(reinterpret_cast<char*>(&loaded_polar_angle), sizeof(qreal));
	fin.read(reinterpret_cast<char*>(&loaded_azimuth_angle), sizeof(qreal));
	fin.read(reinterpret_cast<char*>(&loaded_painting_central_angle), sizeof(qreal));
	if (loaded_polar_angle != polar_angle || loaded_azimuth_angle != azimuth_angle || loaded_painting_central_angle != painting_central_angle)
		return false;
	size_t data_size = 0;
	fin.read(reinterpret_cast<char*>(&data_size), sizeof(size_t));
	if (data_size > 0)
	{
		data.resize(data_size);
		fin.read(reinterpret_cast<char*>(data.data()), sizeof(TileData) * data_size);
	}
	fin.close();
	return true;
}

void DataContainer::Save()
{
	QDir dir("data");
	if (!dir.exists())
		dir.mkdir(".");
	std::ofstream fout(get_file_name(), std::ios::binary);
	fout.write(reinterpret_cast<const char*>(&polar_angle), sizeof(qreal));
	fout.write(reinterpret_cast<const char*>(&azimuth_angle), sizeof(qreal));
	fout.write(reinterpret_cast<const char*>(&painting_central_angle), sizeof(qreal));
	size_t data_size = data.size();
	fout.write(reinterpret_cast<const char*>(&data_size), sizeof(size_t));
	if (data_size > 0)
		fout.write(reinterpret_cast<const char*>(data.data()), sizeof(TileData) * data_size);
	fout.close();
}

QByteArray DataContainer::get_file_name() const
{
	QByteArray byte;
	byte.resize(sizeof(qreal) * 3);
	std::memcpy(byte.data(), &polar_angle, sizeof(qreal));
	std::memcpy(byte.data() + sizeof(qreal), &azimuth_angle, sizeof(qreal));
	std::memcpy(byte.data() + sizeof(qreal) * 2, &painting_central_angle, sizeof(qreal));
	return "data/" + QCryptographicHash::hash(byte, QCryptographicHash::Md5).toHex() + ".dat";
}
