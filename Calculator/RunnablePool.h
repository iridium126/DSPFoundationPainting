#pragma once
#include <QRunnable>
#include <QThreadPool>
#include <QMutex>
#include <functional>
#include <utility>
#include <vector>
#include <memory>

// 前向声明
template <typename Func>
class PooledRunnable;

// 对象池，用于管理可复用的 Runnable
template <typename Func>
class RunnablePool
{
public:
	using RunnableType = PooledRunnable<Func>;

	~RunnablePool()
	{
		QMutexLocker locker(&mutex);
		for (auto* ptr : pool) delete ptr;
	}
	// 获取一个可用的 Runnable
	RunnableType* acquire(Func&& func)
	{
		QMutexLocker locker(&mutex);
		if (!pool.empty()) {
			auto* ptr = pool.back();
			pool.pop_back();
			// 重置内部函数对象
			ptr->resetFunc(std::forward<Func>(func));
			return ptr;
		}
		// 池为空，创建新对象
		return new RunnableType(std::forward<Func>(func), this);
	}
	// 回收 Runnable
	void release(RunnableType* ptr)
	{
		QMutexLocker locker(&mutex);
		pool.push_back(ptr);
	}

private:
	QMutex mutex;
	std::vector<RunnableType*> pool;
};

// 支持池化的 Runnable 类
template <typename Func>
class PooledRunnable : public QRunnable
{
public:
	using Pool = RunnablePool<Func>;

	explicit PooledRunnable(Func&& func, Pool* pool)
		: func(std::forward<Func>(func)), pool(pool)
	{
		setAutoDelete(false); // 禁止自动删除，由池管理
	}
	void resetFunc(Func&& func)
	{
		func = std::forward<Func>(func); // 重新赋值，利用移动语义
	}
	void run() override
	{
		func();
		pool->release(this); // 执行完毕，回收到池
	}

private:
	std::decay_t<Func> func;
	Pool* pool;
};

// 辅助工厂函数，用于自动推导模板类型
template <typename Func>
inline void CreateAndStartRunnable(QThreadPool* threadPool, RunnablePool<Func>* runnablePool, Func&& func)
{
	//auto* runnable = runnablePool->acquire(std::forward<Func>(func));
	//threadPool->start(runnable);
	threadPool->start(func);
}