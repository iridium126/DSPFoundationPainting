#include "DataGenerator.h"

DataGenerator::DataGenerator(DataContainer& container) :container(container)
{
	index_map.reserve(100000);
	points.reserve(10000000);
	raw_data.reserve(10000000);
	GenerateData();
	ProcessData();
}

DataGenerator::~DataGenerator()
{
}

void DataGenerator::GenerateData()
{
	bool p_0_in_painting, p_90_a_0_in_painting, p_90_a_90_in_painting, p_90_a_180_in_painting, p_90_a_270_in_painting, p_180_in_painting;
	bool low_p_1_a_zone = true, low_p_2_a_zone = true, low_p_3_a_zone = true, low_p_4_a_zone = true, high_p_1_a_zone = true, high_p_2_a_zone = true, high_p_3_a_zone = true, high_p_4_a_zone = true;
	p_0_in_painting = point_is_in_painting(0, 0);
	p_90_a_0_in_painting = point_is_in_painting(M_PI_2, 0);
	p_90_a_90_in_painting = point_is_in_painting(M_PI_2, M_PI_2);
	p_90_a_180_in_painting = point_is_in_painting(M_PI_2, M_PI);
	p_90_a_270_in_painting = point_is_in_painting(M_PI_2, M_PI_2 * 3);
	p_180_in_painting = point_is_in_painting(M_PI, 0);
	if (!p_0_in_painting || !p_90_a_0_in_painting || !p_90_a_90_in_painting)
	{
		if (p_0_in_painting || p_90_a_0_in_painting || p_90_a_90_in_painting)
			GenerateData(0, M_PI_2, 0, M_PI_2, p_0_in_painting, p_0_in_painting, p_90_a_0_in_painting, p_90_a_90_in_painting);
		low_p_1_a_zone = false;
	}
	if (!p_0_in_painting || !p_90_a_90_in_painting || !p_90_a_180_in_painting)
	{
		if (p_0_in_painting || p_90_a_90_in_painting || p_90_a_180_in_painting)
			GenerateData(0, M_PI_2, M_PI_2, M_PI, p_0_in_painting, p_0_in_painting, p_90_a_90_in_painting, p_90_a_180_in_painting);
		low_p_2_a_zone = false;
	}
	if (!p_0_in_painting || !p_90_a_180_in_painting || !p_90_a_270_in_painting)
	{
		if (p_0_in_painting || p_90_a_180_in_painting || p_90_a_270_in_painting)
			GenerateData(0, M_PI_2, M_PI, M_PI_2 * 3, p_0_in_painting, p_0_in_painting, p_90_a_180_in_painting, p_90_a_270_in_painting);
		low_p_3_a_zone = false;
	}
	if (!p_0_in_painting || !p_90_a_270_in_painting || !p_90_a_0_in_painting)
	{
		if (p_0_in_painting || p_90_a_270_in_painting || p_90_a_0_in_painting)
			GenerateData(0, M_PI_2, M_PI_2 * 3, M_PI * 2, p_0_in_painting, p_0_in_painting, p_90_a_270_in_painting, p_90_a_0_in_painting);
		low_p_4_a_zone = false;
	}
	if (!p_180_in_painting || !p_90_a_0_in_painting || !p_90_a_90_in_painting)
	{
		if (p_180_in_painting || p_90_a_0_in_painting || p_90_a_90_in_painting)
			GenerateData(M_PI_2, M_PI, 0, M_PI_2, p_90_a_0_in_painting, p_90_a_90_in_painting, p_180_in_painting, p_180_in_painting);
		high_p_1_a_zone = false;
	}
	if (!p_180_in_painting || !p_90_a_90_in_painting || !p_90_a_180_in_painting)
	{
		if (p_180_in_painting || p_90_a_90_in_painting || p_90_a_180_in_painting)
			GenerateData(M_PI_2, M_PI, M_PI_2, M_PI, p_90_a_90_in_painting, p_90_a_180_in_painting, p_180_in_painting, p_180_in_painting);
		high_p_2_a_zone = false;
	}
	if (!p_180_in_painting || !p_90_a_180_in_painting || !p_90_a_270_in_painting)
	{
		if (p_180_in_painting || p_90_a_180_in_painting || p_90_a_270_in_painting)
			GenerateData(M_PI_2, M_PI, M_PI, M_PI_2 * 3, p_90_a_180_in_painting, p_90_a_270_in_painting, p_180_in_painting, p_180_in_painting);
		high_p_3_a_zone = false;
	}
	if (!p_180_in_painting || !p_90_a_270_in_painting || !p_90_a_0_in_painting)
	{
		if (p_180_in_painting || p_90_a_270_in_painting || p_90_a_0_in_painting)
			GenerateData(M_PI_2, M_PI, M_PI_2 * 3, M_PI * 2, p_90_a_270_in_painting, p_90_a_0_in_painting, p_180_in_painting, p_180_in_painting);
		high_p_4_a_zone = false;
	}
	int min_y, max_y, min_n, max_n;
	if (low_p_1_a_zone || low_p_2_a_zone || low_p_3_a_zone || low_p_4_a_zone)
	{
		get_y_range(0, M_PI_2, min_y, max_y, min_n, max_n);
		if (low_p_1_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, 0, M_PI_2);
		if (low_p_2_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, M_PI_2, M_PI);
		if (low_p_3_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, M_PI, M_PI_2 * 3);
		if (low_p_4_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, M_PI_2 * 3, M_PI * 2);
	}
	if (high_p_1_a_zone || high_p_2_a_zone || high_p_3_a_zone || high_p_4_a_zone)
	{
		get_y_range(M_PI_2, M_PI, min_y, max_y, min_n, max_n);
		if (high_p_1_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, 0, M_PI_2);
		if (high_p_2_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, M_PI_2, M_PI);
		if (high_p_3_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, M_PI, M_PI_2 * 3);
		if (high_p_4_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, M_PI_2 * 3, M_PI * 2);
	}
}

void DataGenerator::GenerateData(qreal min_polar_angle, qreal max_polar_angle, qreal min_azimuth_angle, qreal max_azimuth_angle, bool min_p_min_a_in_painting, bool min_p_max_a_in_painting, bool max_p_min_a_in_painting, bool max_p_max_a_in_painting)
{
	qreal mid_polar_angle, mid_azimuth_angle;
	mid_polar_angle = get_nearest_multiple((min_polar_angle + max_polar_angle) / 2, M_PI / 500 / edge_segments);
	mid_azimuth_angle = get_nearest_multiple((min_azimuth_angle + max_azimuth_angle) / 2, get_minimal_azimuth_angle(min_polar_angle, max_polar_angle));
	bool min_p_mid_a_in_painting, mid_p_min_a_in_painting, mid_p_mid_a_in_painting, max_p_mid_a_in_painting, mid_p_max_a_in_painting;
	bool low_p_low_a_zone = true, low_p_high_a_zone = true, high_p_low_a_zone = true, high_p_high_a_zone = true;
	if (float_equal(mid_azimuth_angle, min_azimuth_angle))
	{
		min_p_mid_a_in_painting = min_p_min_a_in_painting;
		max_p_mid_a_in_painting = max_p_min_a_in_painting;
		low_p_low_a_zone = false;
		high_p_low_a_zone = false;
		if (float_equal(mid_polar_angle, min_polar_angle))
		{
			mid_p_min_a_in_painting = min_p_min_a_in_painting;
			mid_p_max_a_in_painting = min_p_max_a_in_painting;
			low_p_high_a_zone = false;
		}
		else if (float_equal(mid_polar_angle, max_polar_angle))
		{
			mid_p_min_a_in_painting = max_p_min_a_in_painting;
			mid_p_max_a_in_painting = max_p_max_a_in_painting;
			high_p_high_a_zone = false;
		}
		else
		{
			mid_p_min_a_in_painting = point_is_in_painting(mid_polar_angle, min_azimuth_angle);
			mid_p_max_a_in_painting = point_is_in_painting(mid_polar_angle, max_azimuth_angle);
		}
		mid_p_mid_a_in_painting = mid_p_min_a_in_painting;
	}
	else if (float_equal(mid_azimuth_angle, max_azimuth_angle))
	{
		min_p_mid_a_in_painting = min_p_max_a_in_painting;
		max_p_mid_a_in_painting = max_p_max_a_in_painting;
		low_p_high_a_zone = false;
		high_p_high_a_zone = false;
		if (float_equal(mid_polar_angle, min_polar_angle))
		{
			mid_p_min_a_in_painting = min_p_min_a_in_painting;
			mid_p_max_a_in_painting = min_p_max_a_in_painting;
			low_p_low_a_zone = false;
		}
		else if (float_equal(mid_polar_angle, max_polar_angle))
		{
			mid_p_min_a_in_painting = max_p_min_a_in_painting;
			mid_p_max_a_in_painting = max_p_max_a_in_painting;
			high_p_low_a_zone = false;
		}
		else
		{
			mid_p_min_a_in_painting = point_is_in_painting(mid_polar_angle, min_azimuth_angle);
			mid_p_max_a_in_painting = point_is_in_painting(mid_polar_angle, max_azimuth_angle);
		}
		mid_p_mid_a_in_painting = mid_p_max_a_in_painting;
	}
	else
	{
		min_p_mid_a_in_painting = point_is_in_painting(min_polar_angle, mid_azimuth_angle);
		max_p_mid_a_in_painting = point_is_in_painting(max_polar_angle, mid_azimuth_angle);
		if (float_equal(mid_polar_angle, min_polar_angle))
		{
			mid_p_min_a_in_painting = min_p_min_a_in_painting;
			mid_p_max_a_in_painting = min_p_max_a_in_painting;
			mid_p_mid_a_in_painting = min_p_mid_a_in_painting;
			low_p_low_a_zone = false;
			low_p_high_a_zone = false;
		}
		else if (float_equal(mid_polar_angle, max_polar_angle))
		{
			mid_p_min_a_in_painting = max_p_min_a_in_painting;
			mid_p_max_a_in_painting = max_p_max_a_in_painting;
			mid_p_mid_a_in_painting = max_p_mid_a_in_painting;
			high_p_low_a_zone = false;
			high_p_high_a_zone = false;
		}
		else
		{
			mid_p_min_a_in_painting = point_is_in_painting(mid_polar_angle, min_azimuth_angle);
			mid_p_max_a_in_painting = point_is_in_painting(mid_polar_angle, max_azimuth_angle);
			mid_p_mid_a_in_painting = point_is_in_painting(mid_polar_angle, mid_azimuth_angle);
		}
	}
	if (low_p_low_a_zone && (!min_p_min_a_in_painting || !min_p_mid_a_in_painting || !mid_p_min_a_in_painting || !mid_p_mid_a_in_painting))
	{
		if ((min_p_min_a_in_painting || min_p_mid_a_in_painting || mid_p_min_a_in_painting || mid_p_mid_a_in_painting)
			&& (!float_equal(mid_polar_angle - min_polar_angle, M_PI / 500 / edge_segments) || !float_equal(mid_azimuth_angle - min_azimuth_angle, get_minimal_azimuth_angle((mid_polar_angle + min_polar_angle) / 2))))
			GenerateData(min_polar_angle, mid_polar_angle, min_azimuth_angle, mid_azimuth_angle, min_p_min_a_in_painting, min_p_mid_a_in_painting, mid_p_min_a_in_painting, mid_p_mid_a_in_painting);
		low_p_low_a_zone = false;
	}
	if (low_p_high_a_zone && (!min_p_mid_a_in_painting || !min_p_max_a_in_painting || !mid_p_mid_a_in_painting || !mid_p_max_a_in_painting))
	{
		if ((min_p_mid_a_in_painting || min_p_max_a_in_painting || mid_p_mid_a_in_painting || mid_p_max_a_in_painting)
			&& (!float_equal(mid_polar_angle - min_polar_angle, M_PI / 500 / edge_segments) || !float_equal(max_azimuth_angle - mid_azimuth_angle, get_minimal_azimuth_angle((mid_polar_angle + min_polar_angle) / 2))))
			GenerateData(min_polar_angle, mid_polar_angle, mid_azimuth_angle, max_azimuth_angle, min_p_mid_a_in_painting, min_p_max_a_in_painting, mid_p_mid_a_in_painting, mid_p_max_a_in_painting);
		low_p_high_a_zone = false;
	}
	if (high_p_low_a_zone && (!mid_p_min_a_in_painting || !mid_p_mid_a_in_painting || !max_p_min_a_in_painting || !max_p_mid_a_in_painting))
	{
		if ((mid_p_min_a_in_painting || mid_p_mid_a_in_painting || max_p_min_a_in_painting || max_p_mid_a_in_painting)
			&& (!float_equal(max_polar_angle - mid_polar_angle, M_PI / 500 / edge_segments) || !float_equal(mid_azimuth_angle - min_azimuth_angle, get_minimal_azimuth_angle((mid_polar_angle + max_polar_angle) / 2))))
			GenerateData(mid_polar_angle, max_polar_angle, min_azimuth_angle, mid_azimuth_angle, mid_p_min_a_in_painting, mid_p_mid_a_in_painting, max_p_min_a_in_painting, max_p_mid_a_in_painting);
		high_p_low_a_zone = false;
	}
	if (high_p_high_a_zone && (!mid_p_mid_a_in_painting || !mid_p_max_a_in_painting || !max_p_mid_a_in_painting || !max_p_max_a_in_painting))
	{
		if ((mid_p_mid_a_in_painting || mid_p_max_a_in_painting || max_p_mid_a_in_painting || max_p_max_a_in_painting)
			&& (!float_equal(max_polar_angle - mid_polar_angle, M_PI / 500 / edge_segments) || !float_equal(max_azimuth_angle - mid_azimuth_angle, get_minimal_azimuth_angle((mid_polar_angle + max_polar_angle) / 2))))
			GenerateData(mid_polar_angle, max_polar_angle, mid_azimuth_angle, max_azimuth_angle, mid_p_mid_a_in_painting, mid_p_max_a_in_painting, max_p_mid_a_in_painting, max_p_max_a_in_painting);
		high_p_high_a_zone = false;
	}
	int min_y, max_y, min_n, max_n;
	if (low_p_low_a_zone || low_p_high_a_zone)
	{
		get_y_range(min_polar_angle, mid_polar_angle, min_y, max_y, min_n, max_n);
		if (low_p_low_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, min_azimuth_angle, mid_azimuth_angle);
		if (low_p_high_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, mid_azimuth_angle, max_azimuth_angle);
	}
	if (high_p_low_a_zone || high_p_high_a_zone)
	{
		get_y_range(mid_polar_angle, max_polar_angle, min_y, max_y, min_n, max_n);
		if (high_p_low_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, min_azimuth_angle, mid_azimuth_angle);
		if (high_p_high_a_zone)
			init_tile_zone(min_y, max_y, min_n, max_n, mid_azimuth_angle, max_azimuth_angle);
	}
}

inline bool DataGenerator::point_is_in_painting(qreal theta, qreal phi)
{
	return sin(container.polar_angle) * sin(theta) * cos(container.azimuth_angle - phi) + cos(container.polar_angle) * cos(theta) >= cos(container.painting_central_angle / 2);
}

inline bool DataGenerator::float_equal(qreal lhs, qreal rhs)
{
	return abs(lhs - rhs) < 0.000000001;
}

inline int DataGenerator::float_floor(qreal value)
{
	return floor(value + 0.000000001);
}

inline qreal DataGenerator::get_nearest_multiple(qreal value, qreal multiple_base)
{
	return multiple_base * round(value / multiple_base);
}

void DataGenerator::get_latitudinal_zone_range(int min_y, int max_y, int& min_l, int& max_l)
{
	if (min_y >= 250)
	{
		min_y -= 250;
		max_y -= 250;
	}
	int i = 1;
	min_l = 11;
	max_l = 11;
	for (; i < 12; i++)
		if (min_y < latitudinal_zone_y[i])
		{
			min_l = i - 1;
			break;
		}
	for (; i < 12; i++)
		if (max_y < latitudinal_zone_y[i])
		{
			max_l = i - 1;
			break;
		}
}

qreal DataGenerator::get_minimal_azimuth_angle(qreal min_polar_angle, qreal max_polar_angle)
{
	int min_y = float_floor(min_polar_angle / M_PI * 500);
	qreal temp_max_y = max_polar_angle / M_PI * 500;
	int max_y = float_floor(temp_max_y);
	if (float_equal(temp_max_y, max_y))
		max_y--;
	if (max_y < 250)
	{
		int temp = max_y;
		max_y = 249 - min_y;
		min_y = 249 - temp;
	}
	int min_l, max_l;
	get_latitudinal_zone_range(min_y, max_y, min_l, max_l);
	return 2 * M_PI / edge_segments / gcd_of_latitudinal_zone[min_l][max_l];
}

qreal DataGenerator::get_minimal_azimuth_angle(qreal the_polar_angle)
{
	int y = float_floor(the_polar_angle / M_PI * 500);
	if (y < 250)
		y = 249 - y;
	else if (y == 500)
		y--;
	return 2 * M_PI / edge_segments / (reformOffsets[y + 1] - reformOffsets[y]);
}

void DataGenerator::get_y_range(qreal min_polar_angle, qreal max_polar_angle, int& min_y, int& max_y, int& min_n, int& max_n)
{
	min_y = float_floor(min_polar_angle / M_PI * 500);
	qreal temp_max_y = max_polar_angle / M_PI * 500;
	max_y = float_floor(temp_max_y);
	if (float_equal(temp_max_y, max_y))
		max_y--;
	min_n = round((min_polar_angle / M_PI * 500 - min_y) * edge_segments);
	max_n = round((temp_max_y - max_y) * edge_segments) - 1;
	if (max_y < 250)
	{
		int temp = max_y;
		max_y = 249 - min_y;
		min_y = 249 - temp;
		temp = max_n;
		max_n = min_n;
		min_n = temp;
	}
	else if (min_y < 250)
		min_y = 249 - min_y;
}

void DataGenerator::get_x_range(qreal min_azimuth_angle, qreal max_azimuth_angle, int y, int& min_x, int& max_x, int& min_m, int& max_m, qreal& minimal_azimuth_angle, int& latitude_length)
{
	latitude_length = reformOffsets[y + 1] - reformOffsets[y];
	minimal_azimuth_angle = 2 * M_PI / (latitude_length);
	min_x = float_floor(min_azimuth_angle / minimal_azimuth_angle);
	qreal temp_max_x = max_azimuth_angle / minimal_azimuth_angle;
	max_x = float_floor(temp_max_x);
	if (float_equal(temp_max_x, max_x))
		max_x--;
	min_m = round((min_azimuth_angle / minimal_azimuth_angle - min_x) * edge_segments);
	max_m = round((temp_max_x - max_x) * edge_segments) - 1;
	if (min_x >= latitude_length / 2)
	{
		int temp = max_x;
		max_x = latitude_length * 1.5 - 1 - min_x;
		min_x = latitude_length * 1.5 - 1 - temp;
		temp = max_m;
		max_m = min_m;
		min_m = temp;
	}
	else if (max_x >= latitude_length / 2)
		max_x = latitude_length * 1.5 - 1 - max_x;
}

void DataGenerator::init_tile_zone(int min_y, int max_y, int min_n, int max_n, qreal min_azimuth_angle, qreal max_azimuth_angle)
{
	int min_l, max_l;
	get_latitudinal_zone_range(min_y, max_y, min_l, max_l);
	if (min_l != max_l)
	{
		if (min_y >= 250)
		{
			init_latitudinal_zone(min_y, latitudinal_zone_y[min_l + 1] + 249, min_n, edge_segments - 1, min_azimuth_angle, max_azimuth_angle);
			for (int l = min_l + 1; l < max_l; l++)
				init_latitudinal_zone(latitudinal_zone_y[l] + 250, latitudinal_zone_y[l + 1] + 249, 0, edge_segments - 1, min_azimuth_angle, max_azimuth_angle);
			init_latitudinal_zone(latitudinal_zone_y[max_l] + 250, max_y, 0, max_n, min_azimuth_angle, max_azimuth_angle);
		}
		else if (max_y < 250)
		{
			init_latitudinal_zone(min_y, latitudinal_zone_y[min_l + 1] - 1, min_n, 0, min_azimuth_angle, max_azimuth_angle);
			for (int l = min_l + 1; l < max_l; l++)
				init_latitudinal_zone(latitudinal_zone_y[l], latitudinal_zone_y[l + 1] - 1, edge_segments - 1, 0, min_azimuth_angle, max_azimuth_angle);
			init_latitudinal_zone(latitudinal_zone_y[max_l], max_y, edge_segments - 1, max_n, min_azimuth_angle, max_azimuth_angle);
		}
	}
	else
		init_latitudinal_zone(min_y, max_y, min_n, max_n, min_azimuth_angle, max_azimuth_angle);
}

void DataGenerator::init_latitudinal_zone(int min_y, int max_y, int min_n, int max_n, qreal min_azimuth_angle, qreal max_azimuth_angle)
{
	int min_x, max_x, min_m, max_m, latitude_length;
	qreal minimal_azimuth_angle, minimal_polar_angle, min_polar_angle;
	get_x_range(min_azimuth_angle, max_azimuth_angle, min_y, min_x, max_x, min_m, max_m, minimal_azimuth_angle, latitude_length);
	minimal_polar_angle = M_PI / 500 / edge_segments;
	minimal_azimuth_angle /= edge_segments;
	int dir_x, dir_y, x, y, m, n;
	if (max_x < latitude_length / 2)
	{
		dir_x = 1;
		x = min_x;
		m = min_m;
	}
	else
	{
		dir_x = -1;
		x = max_x;
		m = max_m;
	}
	if (max_y < 250)
	{
		dir_y = -1;
		y = max_y;
		n = max_n;
		min_polar_angle = (249 - max_y) * M_PI / 500;
	}
	else
	{
		dir_y = 1;
		y = min_y;
		n = min_n;
		min_polar_angle = min_y * M_PI / 500;
	}
	int length_i = (max_y - min_y) * edge_segments + (max_n - min_n) * dir_y + 1;
	int length_j = (max_x - min_x) * edge_segments + (max_m - min_m) * dir_x + 1;
	int index[4], foundation_index;
	for (int i = 1; i <= length_i; i++)
	{
		for (int j = 1; j <= length_j; j++)
		{
			if (i == 1)
			{
				if (j == 1)
				{
					QPointF point0(min_polar_angle, min_azimuth_angle);
					index[0] = get_point_index(point0);
					QPointF point1(min_polar_angle, min_azimuth_angle + minimal_azimuth_angle);
					index[1] = get_point_index(point1);
					QPointF point2(min_polar_angle + minimal_polar_angle, min_azimuth_angle);
					index[2] = get_point_index(point2);
				}
				else
				{
					index[0] = (*(raw_data.end() - 1)).point_index[1];
					QPointF point1(min_polar_angle, min_azimuth_angle + minimal_azimuth_angle * j);
					index[1] = get_point_index(point1);
					index[2] = (*(raw_data.end() - 1)).point_index[3];
				}
			}
			else
			{
				if (j == 1)
				{
					index[0] = (*(raw_data.end() - length_j)).point_index[2];
					index[1] = (*(raw_data.end() - length_j)).point_index[3];
					QPointF point2(min_polar_angle + minimal_polar_angle * i, min_azimuth_angle);
					index[2] = get_point_index(point2);
				}
				else
				{
					index[0] = (*(raw_data.end() - 1)).point_index[1];
					index[1] = (*(raw_data.end() - length_j)).point_index[3];
					index[2] = (*(raw_data.end() - 1)).point_index[3];
				}
			}
			QPointF point3(min_polar_angle + minimal_polar_angle * i, min_azimuth_angle + minimal_azimuth_angle * j);
			if (i < length_i && j < length_j)
			{
				points.push_back(point3);
				index[3] = point_count++;
			}
			else
				index[3] = get_point_index(point3);
			foundation_index = reformOffsets[y + (i - 1 + n) / edge_segments * dir_y] + x + (j - 1 + m) / edge_segments * dir_x;
			raw_data.emplace_back(index, foundation_index / 512 * edge_segments + (i - 1 + n) % edge_segments, foundation_index % 512 * edge_segments + (j - 1 + m) % edge_segments);
		}
	}
}

int DataGenerator::get_point_index(const QPointF& point)
{
	int index;
	if (index_map.contains(point))
		index = index_map.value(point);
	else
	{
		index_map.insert(point, point_count);
		points.push_back(point);
		index = point_count++;
	}
	return index;
}

void DataGenerator::ProcessData()
{
	container.data.reserve(raw_data.size());
	for (auto& point : points)
		point = spherical_to_screen_uv(point);
	for (auto& tile : raw_data)
	{
		auto [u_min, u_max] = std::minmax({ points[tile.point_index[0]].x(), points[tile.point_index[1]].x(), points[tile.point_index[2]].x(), points[tile.point_index[3]].x() });
		auto [v_min, v_max] = std::minmax({ points[tile.point_index[0]].y(), points[tile.point_index[1]].y(), points[tile.point_index[2]].y(), points[tile.point_index[3]].y() });
		container.data.emplace_back(QPointF((u_min + u_max) / 2, (v_min + v_max) / 2), tile.texture_pos);
	}
}

QPointF DataGenerator::spherical_to_screen_uv(const QPointF& point)
{
	qreal i = sin(point.x()) * sin(point.y() - container.azimuth_angle);
	qreal j = -sin(point.x()) * cos(container.polar_angle) * cos(point.y() - container.azimuth_angle) + cos(point.x()) * sin(container.polar_angle);
	qreal k = sin(point.x()) * sin(container.polar_angle) * cos(point.y() - container.azimuth_angle) + cos(point.x()) * cos(container.polar_angle);
	qreal temp = (1 - k * cos(container.painting_central_angle / 2)) * 2 / sin(container.painting_central_angle / 2);
	return QPointF(0.5 + i / temp, 0.5 + j / temp);
}
