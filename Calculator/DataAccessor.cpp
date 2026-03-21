#include "DataAccessor.h"

QImage DataAccessor::output(4096, 5088, QImage::Format_RGBA8888);
bool DataAccessor::foundation_mask[325632] = { false };

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
	if (input.format() != QImage::Format_ARGB32)
		input = input.convertToFormat(QImage::Format_ARGB32);
	output.fill(Qt::transparent);
	for (auto& tile : container.data)
	{
		const QRgb* line_in = reinterpret_cast<const QRgb*>(input.constScanLine(offset_i + tile.v() * min_side));
		QRgb* line_out = reinterpret_cast<QRgb*>(output.scanLine(tile.x()));
		QRgb pixel = line_in[static_cast<int>(offset_j + (1 - tile.u()) * min_side)];
		// 将ARGB32格式转换为RGBA8888格式（交换R和B通道）
		line_out[tile.y()] = pixel & 0xFF00FF00 | ((pixel & 0x00FF0000) >> 16) | ((pixel & 0x000000FF) << 16);
	}
	generate_foundation_mask(output.bits(), 0, 5088 / 8);
	return write_texture(fileName.left(fileName.lastIndexOf('.')) + "_texture.png", output);
}

void DataAccessor::generate_foundation_mask(const uchar* bits, int startFNDRow, int endFNDRow)
{
	// RGBA8888格式：每个像素4字节，字节顺序（小端）：R(0), G(1), B(2), A(3)
	const int pixel_bytes = 4;
	const int alpha_offset = 3; // alpha通道在像素字节的第4位（索引3）
	const int foundation_size = 8;
	for (int foundation_row = startFNDRow; foundation_row < endFNDRow; ++foundation_row) {
		const int y_start = foundation_row * foundation_size;
		for (int foundation_col = 0; foundation_col < 512; ++foundation_col) {
			const int x_start = foundation_col * foundation_size;
			bool has_tile = false;

			// 遍历块内8x8像素
			for (int dy = 0; dy < foundation_size && !has_tile; ++dy) {
				// 计算当前行的像素数据起始地址
				const int y = y_start + dy;
				const uchar* row_start = bits + (y * 4096 + x_start) * pixel_bytes;

				for (int dx = 0; dx < foundation_size && !has_tile; ++dx) {
					// 提取alpha值
					const uchar alpha = row_start[dx * pixel_bytes + alpha_offset];
					if (alpha > 0)
						has_tile = true;
				}
			}
			foundation_mask[foundation_row * 512 + foundation_col] = has_tile;
		}
	}
}

std::vector<uint8_t> DataAccessor::pack_bools_to_bytes()
{
	std::vector<uint8_t> byte_data(40700);
	for (int byte_idx = 0; byte_idx < 40700; ++byte_idx) {
		uint8_t byte = 0;
		const int start_bit = byte_idx * 8;
		const int end_bit = start_bit + 8;
		for (int bit_idx = start_bit; bit_idx < end_bit; ++bit_idx)
			if (foundation_mask[bit_idx])
				byte |= (1 << (bit_idx - start_bit));
		byte_data[byte_idx] = byte;
	}
	return byte_data;
}

bool DataAccessor::write_texture(const QString& filePath, const QImage& image)
{
	auto byte_data = pack_bools_to_bytes();
	FILE* fp = nullptr;
	if (_wfopen_s(&fp, filePath.toStdWString().c_str(), L"wb") != 0)
		return false;
	// 初始化libpng结构
	png_structp png_ptr = png_create_write_struct(PNG_LIBPNG_VER_STRING, nullptr, nullptr, nullptr);
	png_infop info_ptr = png_create_info_struct(png_ptr);
	if (!png_ptr || !info_ptr || setjmp(png_jmpbuf(png_ptr))) {
		png_destroy_write_struct(&png_ptr, &info_ptr);
		fclose(fp);
		return false;
	}
	// 绑定文件指针到libpng
	png_init_io(png_ptr, fp);
	// 设置PNG图片参数（基于QImage）
	int height = image.height();
	png_set_IHDR(png_ptr, info_ptr,
		image.width(), height,  // 宽高
		8,                          // 位深度（8位/通道）
		PNG_COLOR_TYPE_RGBA,        // 颜色类型（RGBA）
		PNG_INTERLACE_NONE,
		PNG_COMPRESSION_TYPE_DEFAULT,
		PNG_FILTER_TYPE_DEFAULT);
	// 写入图片信息头
	png_write_info(png_ptr, info_ptr);
	// 写入像素数据（逐行写入）
	std::vector<png_bytep> row_pointers(height);
	for (int y = 0; y < height; ++y)
		row_pointers[y] = reinterpret_cast<png_bytep>(const_cast<uchar*>(image.constScanLine(y)));
	png_write_image(png_ptr, row_pointers.data());
	// 添加PNG私有块
	png_byte chunk_name[] = { 'f', 'm', 's', 'k' };
	png_write_chunk(png_ptr, chunk_name,
		reinterpret_cast<png_const_bytep>(byte_data.data()),
		byte_data.size());
	// 完成写入并清理资源
	png_write_end(png_ptr, info_ptr);
	png_destroy_write_struct(&png_ptr, &info_ptr);
	fclose(fp);
	return true;
}
