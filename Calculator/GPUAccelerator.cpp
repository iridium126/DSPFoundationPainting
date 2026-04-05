#include "GPUAccelerator.h"

static const char* computeShaderSource = R"(
#version 430 core
#extension GL_ARB_gpu_shader_int64 : enable

layout(local_size_x = 256, local_size_y = 1, local_size_z = 1) in;

struct TileRaw {
    uint index[4];
    ivec2 texPos;
};

// 输入：原始点数据
layout(std430, binding = 0) buffer PointBuffer {
    vec2 points[];
};

// 输入：瓦片数据
layout(std430, binding = 1) buffer TileBuffer {
    TileRaw tiles[];
};

// 输出：打包后的数据
layout(std430, binding = 2) buffer OutputBuffer {
    uint64_t outputData[];
};

uniform float polar_angle;
uniform float azimuth_angle;
uniform float painting_central_angle;

const uint FIXED_SCALE = 0x7FFFFu; // (1 << 19) - 1

void main() {
    // 全局线程ID（同时作为点索引/瓦片索引）
    uint globalId = gl_GlobalInvocationID.x;

    if (globalId < points.length()) {
        vec2 point = points[globalId];
        float i = sin(point.x) * sin(point.y - azimuth_angle);
        float j = -sin(point.x) * cos(polar_angle) * cos(point.y - azimuth_angle) + cos(point.x) * sin(polar_angle);
        float k = sin(point.x) * sin(polar_angle) * cos(point.y - azimuth_angle) + cos(point.x) * cos(polar_angle);
        float temp = (1.0 - k * cos(painting_central_angle / 2.0)) * 2.0 / sin(painting_central_angle / 2.0);
        points[globalId] = vec2(0.5 + i / temp, 0.5 + j / temp);
    }

    memoryBarrierBuffer();
    barrier();

    if (globalId >= tiles.length()) return;
    
    TileRaw tile = tiles[globalId];
    float u_min = 1.0, u_max = 0.0;
    float v_min = 1.0, v_max = 0.0;

    for (int i = 0; i < 4; ++i) {
        uint idx = tile.index[i];
        vec2 uv = points[idx];
        u_min = min(u_min, uv.x);
        u_max = max(u_max, uv.x);
        v_min = min(v_min, uv.y);
        v_max = max(v_max, uv.y);
    }

    float u_center = (u_min + u_max) * 0.5;
    float v_center = (v_min + v_max) * 0.5;
    
    uint u_fixed = uint(u_center * float(FIXED_SCALE));
    uint v_fixed = uint(v_center * float(FIXED_SCALE));
    uint64_t packed = (uint64_t(u_fixed) << 45u) |
                      (uint64_t(tile.texPos.x) << 32u) |
                      (uint64_t(v_fixed) << 13u) |
                      uint64_t(tile.texPos.y);
    outputData[globalId] = packed;
}
)";

GPUAccelerator::GPUAccelerator()
{
	f = new QOpenGLFunctions_4_3_Core;
	// 绑定当前OpenGL上下文（必须有有效上下文才能调用）
	if (!f->initializeOpenGLFunctions()) {
		qCritical() << "OpenGL 4.3 初始化失败！请检查显卡支持";
	}
}

GPUAccelerator::~GPUAccelerator()
{
	// 注意：销毁时需保证 OpenGL 上下文仍然有效
	pointBuffer.destroy();
	tileBuffer.destroy();
	outputBuffer.destroy();
	// QOpenGLShaderProgram 的析构会自动释放着色器资源
	delete f;
}

bool GPUAccelerator::initShaders()
{
	if (!program.addShaderFromSourceCode(QOpenGLShader::Compute, computeShaderSource)) {
		qWarning() << "Compute shader compilation failed:" << program.log();
		return false;
	}
	if (!program.link()) {
		qWarning() << "Shader linking failed:" << program.log();
		return false;
	}
	return true;
}

bool GPUAccelerator::compute(const std::vector<QPointF>& points, const std::vector<TileRawData>& raw_data,
	const uint points_size, const uint raw_data_size, DataContainer& container)
{
	// 创建 SSBO
	pointBuffer.create();
	pointBuffer.bind();
	pointBuffer.allocate(points.data(), points_size * sizeof(QPointF));
	pointBuffer.release();

	tileBuffer.create();
	tileBuffer.bind();
	tileBuffer.allocate(raw_data.data(), raw_data_size * sizeof(TileRawData));
	tileBuffer.release();

	outputBuffer.create();
	outputBuffer.bind();
	outputBuffer.allocate(raw_data_size * sizeof(uint64_t));
	outputBuffer.release();

	if (!initShaders()) {
		qFatal("GPUAccelerator: Shader initialization failed");
	}

	program.bind();

	// 绑定 SSBO
	pointBuffer.bind();
	f->glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 0, pointBuffer.bufferId());
	tileBuffer.bind();
	f->glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 1, tileBuffer.bufferId());
	outputBuffer.bind();
	f->glBindBufferBase(GL_SHADER_STORAGE_BUFFER, 2, outputBuffer.bufferId());

	// 设置角度参数
	program.setUniformValue("polar_angle", static_cast<GLfloat>(container.polar_angle));
	program.setUniformValue("azimuth_angle", static_cast<GLfloat>(container.azimuth_angle));
	program.setUniformValue("painting_central_angle", static_cast<GLfloat>(container.painting_central_angle));

	// 调度计算
	uint workGroups = (raw_data_size + 255) / 256;
	f->glDispatchCompute(workGroups, 1, 1);
	f->glMemoryBarrier(GL_SHADER_STORAGE_BARRIER_BIT);

	// 读回结果
	outputBuffer.bind();
	void* ptr = f->glMapBufferRange(GL_SHADER_STORAGE_BUFFER, 0,
		raw_data_size * sizeof(uint64_t),
		GL_MAP_READ_BIT);
	if (!ptr) {
		qWarning() << "GPUAccelerator::compute: Failed to map output buffer";
		program.release();
		return false;
	}
	container.data.resize(raw_data_size);
	memcpy(container.data.data(), ptr, raw_data_size * sizeof(uint64_t));
	f->glUnmapBuffer(GL_SHADER_STORAGE_BUFFER);
	outputBuffer.release();

	program.release();
	return true;
}