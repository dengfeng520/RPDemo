import UIKit

var str = "Hello, World"
print("-----------------")

var array: [Int] = Array.init(0...999)
let lock = NSLock()

// 加锁的方式
func getLastItem() -> Int? {
    lock.lock()
    var temp: Int? = nil
    if array.count > 0 {
        temp = array[array.count - 1]
    }
    lock.unlock()
    return temp
}

func removeLastItem() {
    lock.lock()
    array.removeLast()
    lock.unlock()
}

// 队列的方式
func configLastItem() -> Int? {
    var temp: Int? = nil
    return temp
}
// 主线程队列
let main = DispatchQueue.main
// 串行队列
let serialQueue = DispatchQueue(label: "com.tsn.demo.serialQueue")
// 并行队列
let concurrentQueue = DispatchQueue.init(label: "com.tsn.demo.concurrentQueue", attributes: .concurrent)
let queue = DispatchQueue(label: "com.tsn.demo.Queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
// 同步执行
queue.sync {
    // 播放视频一
}
queue.sync {
    // 播放视频二
}
queue.sync {
    // 播放视频三
}
// 异步执行
queue.async {
    // 下载视频一
}
queue.async {
    // 下载视频二
}
queue.async {
    // 下载视频三
}

let initiallyInactiveQueue = DispatchQueue(label: "com.tsn.demo.initiallyInactiveQueue", qos: .default, attributes: .initiallyInactive, autoreleaseFrequency: .inherit, target: .global())
initiallyInactiveQueue.async {
    // do something
}
initiallyInactiveQueue.async {
    // do something
}
initiallyInactiveQueue.async {
    // do something
}
initiallyInactiveQueue.activate()


// 全局并发队列
//let globalQueue = DispatchQueue.global()
let globalQueue = DispatchQueue.global(qos: .unspecified)
// 栅栏队列
let barrierQueue = DispatchQueue(label: "com.tsn.demo.barrierQueue", attributes: .concurrent)
let barrierTask = DispatchWorkItem(qos: .default, flags: .barrier) {
    // 点击开始播放视频
    print("-----------开始播放------------")
}
barrierQueue.async {
    // 下载视频
    print("-----------下载视频------------")
}
barrierQueue.async {
    // 下载音频
    print("-----------下载音频------------")
}
barrierQueue.async {
    // 下载弹幕
    print("-----------下载弹幕------------")
}
//// 栅栏任务
barrierQueue.async(execute: barrierTask)
// 延迟加入队列
DispatchQueue.main.asyncAfter(deadline: .now() + 20 * 60) {
    print("-----------20分钟后关闭视频------------")
}
// 唤醒和挂起
class SuspendAndResum {
    let queue = DispatchQueue(label: "com.tsn.demo.concurrentQueue", attributes: .concurrent)
    // 记录队列挂起的次数
    var index = 0
    
    init() {
        // 模拟任务挂起
        configQueue()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            // 模拟任务唤醒
            self.testResume()
            // 唤醒任务后继续下载 下载完成后播放视频
            self.goOnQueue()
        }
    }

    func configQueue() {
        queue.async {
            print("-----------模拟下载视频-----------")
        }
        queue.async {
            print("-----------模拟下载音频-----------")
        }
        queue.async {
            print("-----------模拟下载弹幕-----------")
        }
        // 通过栅栏挂起任务
        queue.async(execute: DispatchWorkItem(flags: .barrier) {
            self.testSuspend()
        })
    }
    
    func goOnQueue() {
        queue.async {
            print("-----------继续下载视频-----------")
        }
        queue.async {
            print("-----------继续下载音频-----------")
        }
        queue.async {
            print("-----------继续下载弹幕-----------")
        }
        let barrierTask = DispatchWorkItem(qos: .default, flags: .barrier) {
            print("-----------下载完成，开始播放------------")
        }
        queue.async(execute: barrierTask)
    }
    
    // 挂起
    func testSuspend() {
        index = index + 1
        queue.suspend()
        print("-----------任务挂起-----------")
    }
    // 唤醒
    func testResume() {
        if index == 1 {
            queue.resume()
            index == 0
            print("-----------任务唤醒-----------")
        } else if index < 1 {
            print("-----------唤醒次数超过挂起次数-----------")
        } else {
            queue.resume()
            index = index - 1
            print("-----------还需要\(index)才可以唤醒-----------")
        }
    }
}

let test = SuspendAndResum()
