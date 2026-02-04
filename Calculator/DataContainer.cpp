#include "DataContainer.h"
#include "DataGenerator.h"

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
