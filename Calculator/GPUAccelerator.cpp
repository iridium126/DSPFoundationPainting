#include "GPUAccelerator.h"

GPUAccelerator::~GPUAccelerator()
{
	destroy();
}

bool GPUAccelerator::initialize()
{
	QRhiD3D12InitParams params;
	params.enableDebugLayer = true;
	rhi = QRhi::create(QRhi::D3D12, &params);

	// 创建缓冲区对象
	pointBuf = rhi->newBuffer(QRhiBuffer::Static, QRhiBuffer::StorageBuffer, 10000000 * sizeof(QPointFloat));
	tileBuf = rhi->newBuffer(QRhiBuffer::Static, QRhiBuffer::StorageBuffer, 10000000 * sizeof(TileRawData));
	outputBuf = rhi->newBuffer(QRhiBuffer::Static, QRhiBuffer::StorageBuffer, 10000000 * sizeof(uint64_t));
	uniformBuf = rhi->newBuffer(QRhiBuffer::Dynamic, QRhiBuffer::UniformBuffer, rhi->ubufAligned(28));
	if (!pointBuf->create()) return false;
	if (!tileBuf->create()) return false;
	if (!outputBuf->create()) return false;
	if (!uniformBuf->create()) return false;

	// 创建资源绑定布局
	srb = rhi->newShaderResourceBindings();
	srb->setBindings({
		QRhiShaderResourceBinding::bufferLoadStore(0, QRhiShaderResourceBinding::ComputeStage, pointBuf, 0, pointBuf->size()),
		QRhiShaderResourceBinding::bufferLoadStore(1, QRhiShaderResourceBinding::ComputeStage, tileBuf, 0, tileBuf->size()),
		QRhiShaderResourceBinding::bufferLoadStore(2, QRhiShaderResourceBinding::ComputeStage, outputBuf, 0, outputBuf->size()),
		QRhiShaderResourceBinding::uniformBuffer(3, QRhiShaderResourceBinding::ComputeStage, uniformBuf, 0, rhi->ubufAligned(28))
		});
	if (!srb->create()) return false;

	// 加载离线编译的着色器（.qsb）
	auto loadShader = [this](const QString& path) -> QShader {
		QResource resource(path);
		if (!resource.isValid() || !resource.data())
			return {};
		return QShader::fromSerialized(QByteArray(reinterpret_cast<const char*>(resource.data()), resource.size()));
		};
	QShader pointShader = loadShader(":/shaders/shaders/point_transform.qsb");
	QShader tileShader = loadShader(":/shaders/shaders/tile_pack.qsb");

	if (!pointShader.isValid() || !tileShader.isValid())
		return false;

	// 创建计算管线
	// 管线1：点坐标变换
	pointPipeline = rhi->newComputePipeline();
	pointPipeline->setShaderResourceBindings(srb);
	pointPipeline->setShaderStage({ QRhiShaderStage::Compute, pointShader });
	if (!pointPipeline->create()) return false;

	// 管线2：瓦片打包
	tilePipeline = rhi->newComputePipeline();
	tilePipeline->setShaderResourceBindings(srb);
	tilePipeline->setShaderStage({ QRhiShaderStage::Compute, tileShader });
	if (!tilePipeline->create()) return false;

	return true;
}

bool GPUAccelerator::compute(const std::vector<QPointFloat, no_init_allocator<QPointFloat>>& points,
	const std::vector<TileRawData, no_init_allocator<TileRawData>>& raw_data,
	const uint points_size,
	const uint raw_data_size,
	DataContainer& container)
{
	struct UniformData {
		uint points_size;
		uint raw_data_size;
		float azimuth_angle;
		float polar_sin;      // sin(polar_angle)
		float polar_cos;      // cos(polar_angle)
		float half_paint_sin; // sin(painting_central_angle * 0.5)
		float half_paint_cos; // cos(painting_central_angle * 0.5)
	} uniformData{ points_size, raw_data_size,
		static_cast<float>(container.azimuth_angle),
		static_cast<float>(sin(container.polar_angle)),
		static_cast<float>(cos(container.polar_angle)),
		static_cast<float>(sin(container.painting_central_angle * 0.5)),
		static_cast<float>(cos(container.painting_central_angle * 0.5))
	};

	// 创建资源更新批处理
	QRhiResourceUpdateBatch* batch = rhi->nextResourceUpdateBatch();
	batch->uploadStaticBuffer(pointBuf, 0, points_size * sizeof(QPointFloat), points.data());
	batch->uploadStaticBuffer(tileBuf, 0, raw_data_size * sizeof(TileRawData), raw_data.data());
	batch->updateDynamicBuffer(uniformBuf, 0, sizeof(UniformData), &uniformData);

	QRhiCommandBuffer* cb = nullptr;
	rhi->beginOffscreenFrame(&cb);
	cb->beginComputePass(batch);

	// 阶段1：点坐标变换
	cb->setComputePipeline(pointPipeline);
	cb->setShaderResources(srb);
	cb->dispatch((points_size + 255) / 256, 1, 1);

	cb->endComputePass();
	cb->beginComputePass();

	// 阶段2：瓦片打包
	cb->setComputePipeline(tilePipeline);
	cb->setShaderResources(srb);
	cb->dispatch((raw_data_size + 255) / 256, 1, 1);

	auto* result = new QRhiReadbackResult;
	result->completed = [&container, result, raw_data_size]() {
		// 读回结果
		container.rhi_result_resource = std::make_unique<RhiResultMemoryResource>(result); // 交由DataContainer管理生命周期
		container.data = std::make_unique<std::vector<TileData, no_init_allocator<TileData, std::pmr::polymorphic_allocator<TileData>>>>(container.rhi_result_resource.get());
		container.data->resize(raw_data_size);
		};
	batch = rhi->nextResourceUpdateBatch();
	batch->readBackBuffer(outputBuf, 0, raw_data_size * sizeof(uint64_t), result);
	cb->endComputePass(batch);

	// 结束离屏帧，同步等待计算完成
	rhi->endOffscreenFrame();

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

	rhi = nullptr;
}