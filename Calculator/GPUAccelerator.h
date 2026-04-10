#pragma once
#include <rhi/qrhi.h>
#include <QResource>
#include "DataGenerator.h"

// Qt6 Rhi 计算着色器加速类
class GPUAccelerator
{
public:
	GPUAccelerator() = default;
	~GPUAccelerator();

	// 禁止拷贝
	GPUAccelerator(const GPUAccelerator&) = delete;
	GPUAccelerator& operator=(const GPUAccelerator&) = delete;

	// 初始化
	bool initialize();

	// 核心计算接口
	bool compute(const std::vector<QPointFloat, no_init_allocator<QPointFloat>>& points,
		const std::vector<TileRawData, no_init_allocator<TileRawData>>& raw_data,
		const uint points_size,
		const uint raw_data_size,
		DataContainer& container);

	// 释放资源
	void destroy();

private:
	QRhi* rhi = nullptr;

	// 缓冲区
	QRhiBuffer* pointBuf = nullptr;
	QRhiBuffer* tileBuf = nullptr;
	QRhiBuffer* outputBuf = nullptr;
	QRhiBuffer* uniformBuf = nullptr;

	// 资源绑定
	QRhiShaderResourceBindings* srb = nullptr;

	// 计算管线
	QRhiComputePipeline* pointPipeline = nullptr;  // 点变换
	QRhiComputePipeline* tilePipeline = nullptr;   // 瓦片打包
};