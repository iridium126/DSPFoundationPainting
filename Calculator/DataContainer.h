#pragma once
#include <vector>
#include <fstream>
#include <QPointF>
#include <QDir>
#include <QCryptographicHash>

// 不初始化分配器：在resize(n)等需要分配但不需要初始化的场景下使用，避免不必要的构造函数调用。
template <typename T, typename Alloc = std::allocator<T>>
class no_init_allocator : public Alloc {
	// 使用 allocator_traits 简化类型萃取
	using traits = std::allocator_traits<Alloc>;

public:
	// 必须定义 rebind 模板，用于容器内部分配其他类型（如链表节点）
	template <typename U>
	struct rebind {
		using other = no_init_allocator<U, typename traits::template rebind_alloc<U>>;
	};

	// 继承基类的构造函数
	using Alloc::Alloc;

	// 当仅传入指针时（即 resize(n) 扩容时的调用），不初始化
	template <typename U>
	void construct(U*) noexcept {
		// 内存保持分配后的原始状态
	}

	// 当传入初始化参数时（如 resize(n, val)、emplace_back 等），正常转发给基类
	template <typename U, typename... Args>
	void construct(U* ptr, Args&&... args) {
		traits::construct(static_cast<Alloc&>(*this), ptr, std::forward<Args>(args)...);
	}
};

class DataGenerator;
class DataAccessor;

class TileData
{
	friend DataGenerator;
	friend DataAccessor;
public:
	TileData(const QPointF& uv, const QPoint& pos)
	{
		setData(uv, pos);
	}
private:
	uint64_t packed_data; // 将uv坐标和纹理坐标打包成一个64位整数，节省空间
	static constexpr uint32_t FIXED_SCALE = (1 << 19) - 1;
	void setData(const QPointF& uv, const QPoint& pos)
	{
		// 0~1浮点数转19位无符号定点数
		uint32_t u_fixed = static_cast<uint32_t>(uv.x() * FIXED_SCALE);
		uint32_t v_fixed = static_cast<uint32_t>(uv.y() * FIXED_SCALE);
		packed_data = (static_cast<uint64_t>(u_fixed) << 45) | (static_cast<uint64_t>(pos.x()) << 32) | (static_cast<uint64_t>(v_fixed) << 13) | static_cast<uint64_t>(pos.y());
	}
	const qreal u() const
	{
		uint32_t u_fixed = (packed_data >> 45) & 0x7FFFF;
		return static_cast<qreal>(u_fixed) / FIXED_SCALE;
	}
	const qreal v() const
	{
		uint32_t v_fixed = (packed_data >> 13) & 0x7FFFF;
		return static_cast<qreal>(v_fixed) / FIXED_SCALE;
	}
	const int x() const
	{
		return (packed_data >> 32) & 0x1FFF;
	}
	const int y() const
	{
		return packed_data & 0x1FFF;
	}
};

class DataContainer
{
	friend DataGenerator;
	friend DataAccessor;
public:
	DataContainer(qreal polar_angle, qreal azimuth_angle, qreal painting_central_angle);
	~DataContainer() = default;
	bool Load();
	void Save();
	qreal polar_angle, azimuth_angle; // 极角、方位角
	qreal painting_central_angle;     // 图片在球面上的边界的直径所对的圆心角
private:
	std::vector<TileData, no_init_allocator<TileData>> data;
	QByteArray get_file_name() const;
};