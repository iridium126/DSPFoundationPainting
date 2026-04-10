#include "GPUAccelerator.h"

GPUAccelerator::~GPUAccelerator()
{
	destroy();
}

bool GPUAccelerator::initialize()
{
	QRhiD3D12InitParams params;
	rhi = QRhi::create(QRhi::D3D12, &params);

	// 创建缓冲区对象
	pointBuf = rhi->newBuffer(QRhiBuffer::Static, QRhiBuffer::StorageBuffer, 10000000 * sizeof(QPointF));
	tileBuf = rhi->newBuffer(QRhiBuffer::Static, QRhiBuffer::StorageBuffer, 10000000 * sizeof(TileRawData));
	outputBuf = rhi->newBuffer(QRhiBuffer::Static, QRhiBuffer::StorageBuffer, 10000000 * sizeof(uint64_t));
	uniformBuf = rhi->newBuffer(QRhiBuffer::Dynamic, QRhiBuffer::UniformBuffer, 20);
	pointBuf->create();
	tileBuf->create();
	outputBuf->create();
	uniformBuf->create();

	// 创建资源绑定布局
	srb = rhi->newShaderResourceBindings();
	srb->setBindings({
		QRhiShaderResourceBinding::bufferStore(0, QRhiShaderResourceBinding::ComputeStage, pointBuf),
		QRhiShaderResourceBinding::bufferStore(1, QRhiShaderResourceBinding::ComputeStage, tileBuf),
		QRhiShaderResourceBinding::bufferLoad(2, QRhiShaderResourceBinding::ComputeStage, outputBuf),
		QRhiShaderResourceBinding::uniformBuffer(3, QRhiShaderResourceBinding::ComputeStage, uniformBuf)
		});
	srb->create();

	// 加载离线编译的着色器（.qsb）
	auto loadShader = [this](const QString& path) -> QShader {
		QResource resource(path);
		if (!resource.isValid() || !resource.data())
			return {};
		return QShader::fromSerialized(QByteArray(reinterpret_cast<const char*>(resource.data()), resource.size()));
		};
	QShader pointShader = loadShader(":/shaders/shaders/point_transform.qsb");
	QShader tileShader = loadShader(":/shaders/shaders/tile_pack.qsb");

	if (!pointShader.isValid() || !tileShader.isValid()) {
		qCritical() << "着色器加载失败！";
		return false;
	}

	// 创建计算管线
	// 管线1：点坐标变换
	pointPipeline = rhi->newComputePipeline();
	pointPipeline->setShaderResourceBindings(srb);
	pointPipeline->setShaderStage({ QRhiShaderStage::Compute, pointShader });
	pointPipeline->create();

	// 管线2：瓦片打包
	tilePipeline = rhi->newComputePipeline();
	tilePipeline->setShaderResourceBindings(srb);
	tilePipeline->setShaderStage({ QRhiShaderStage::Compute, tileShader });
	tilePipeline->create();

	return true;
}

bool GPUAccelerator::compute(const std::vector<QPointF, no_init_allocator<QPointF>>& points,
	const std::vector<TileRawData, no_init_allocator<TileRawData>>& raw_data,
	const uint points_size,
	const uint raw_data_size,
	DataContainer& container)
{
	const qint64 pointBytes = points_size * sizeof(QPointF);
	const qint64 tileBytes = raw_data_size * sizeof(TileRawData);
	const qint64 outBytes = raw_data_size * sizeof(uint64_t);

	struct UniformData {
		uint points_size;
		uint raw_data_size;
		float polar_angle;
		float azimuth_angle;
		float painting_central_angle;
	} uniformData{ points_size, raw_data_size,
		static_cast<float>(container.polar_angle),
		static_cast<float>(container.azimuth_angle),
		static_cast<float>(container.painting_central_angle) };

	// 创建资源更新批处理
	QRhiResourceUpdateBatch* batch = rhi->nextResourceUpdateBatch();

	// 上传数据
	batch->updateDynamicBuffer(pointBuf, 0, pointBytes, points.data());
	batch->updateDynamicBuffer(tileBuf, 0, tileBytes, raw_data.data());
	batch->updateDynamicBuffer(uniformBuf, 0, sizeof(UniformData), &uniformData);

	QRhiCommandBuffer* cb = nullptr;
	rhi->beginOffscreenFrame(&cb);
	// 提交上传
	cb->beginComputePass(batch);

	// 阶段1：点坐标变换
	cb->setComputePipeline(pointPipeline);
	cb->setShaderResources(srb);

	cb->dispatch((points_size + 255) / 256, 1, 1);
	// 内存屏障：保证点数据写入完成
	cb->endComputePass();
	cb->beginComputePass();

	// 阶段2：瓦片打包
	cb->setComputePipeline(tilePipeline);
	cb->dispatch((raw_data_size + 255) / 256, 1, 1);

	QRhiReadbackResult readbackResult;
	batch = rhi->nextResourceUpdateBatch();
	batch->readBackBuffer(outputBuf, 0, outBytes, &readbackResult);
	cb->endComputePass(batch); // 传入读回批次，确保计算完成后读回

	// 结束离屏帧，同步等待计算完成
	rhi->endOffscreenFrame();

	// 读回结果

	const QByteArray& readbackData = readbackResult.data;

	// 直接构造（最高效，无多余拷贝）
	container.data.assign(reinterpret_cast<const uint64_t*>(readbackData.constData()),
		reinterpret_cast<const uint64_t*>(readbackData.constData() + readbackData.size()));


	return true;
}

void GPUAccelerator::destroy()
{
	if (!rhi) return;

	delete pointPipeline;
	delete tilePipeline;
	delete srb;
	delete pointBuf;
	delete tileBuf;
	delete outputBuf;
	delete uniformBuf;
	delete rhi;
}