#pragma once
#include <QOpenGLBuffer>
#include <QOpenGLShaderProgram>
#include <QOpenGLFunctions_4_3_Core>
#include <vector>
#include "DataGenerator.h"

class GPUAccelerator {
public:
	GPUAccelerator();
	~GPUAccelerator();

	// 禁止拷贝
	GPUAccelerator(const GPUAccelerator&) = delete;
	GPUAccelerator& operator=(const GPUAccelerator&) = delete;

	// 执行计算，将结果填充至 container.data 中
	// 返回值：是否成功
	bool compute(const std::vector<QPointF>& points, const std::vector<TileRawData>& raw_data,
		const uint points_size, const uint raw_data_size, DataContainer& container);

private:
	QOpenGLFunctions_4_3_Core* f = nullptr;
	QOpenGLShaderProgram program;
	QOpenGLBuffer pointBuffer;   // SSBO 0
	QOpenGLBuffer tileBuffer;    // SSBO 1
	QOpenGLBuffer outputBuffer;  // SSBO 2

	bool initShaders();
};