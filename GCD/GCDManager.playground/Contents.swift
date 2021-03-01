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
// 设置最大并发数为5
let semap = DispatchSemaphore.init(value: 5)
// 信号量减1
semap.wait()
// 同步执行
queue.sync {
    // 播放视频一
    // 信号量加1
    semap.signal()
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
//栅栏任务
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
// 迭代任务
let musicArray = Array<AnyObject?>(repeating: nil, count: 10)
DispatchQueue.concurrentPerform(iterations: musicArray.count) { (index) in
    print("-----------执行查找操作-----------")
}
// 创建任务组
let group = DispatchGroup()
// 下载视频
let videoQueue = DispatchQueue(label: "com.tsn.demo.video", attributes: .concurrent)
group.enter()
videoQueue.async(group: group) {
    print("-----------开始下载视频-----------")
    group.leave()
}
// 下载音频
let audioQueue = DispatchQueue.init(label: "com.tsn.demo.audio", attributes: .concurrent)
group.enter()
audioQueue.async(group: group) {
    print("-----------开始下载音频-----------")
    group.leave()
}
// 下载弹幕
let bulletScreenQueue = DispatchQueue.init(label: "com.tsn.demo.audio", attributes: .concurrent)
group.enter()
audioQueue.async(group: group) {
    print("-----------开始下载弹幕-----------")
    group.leave()
}
// 任务组通知
group.notify(queue: .main) {
    print("-----------全部下载完成,任务组通知-----------")
}
// 阻塞当前线程
group.wait()
group.wait(timeout: .now() + 1)
group.wait(wallTimeout: .now() + 1)
print("-----------阻塞完后，继续执行-----------")

class Combination: NSObject {
    
    func configCombination() {
        // 串行队列
        let serialQueue = DispatchQueue(label: "com.tsn.students.serqueue")
        // 并行队列
        let concurrentQueue = DispatchQueue(label: "com.tsn.students.concurrentqueue", attributes: .concurrent)
        // 3.1
        print("3.1-----------\(Thread.current)-----------start")
        serialQueue.sync {
            sleep(1)
            print("3.1.1-----------\(Thread.current)-----------")
        }
        serialQueue.sync {
            sleep(1)
            print("3.1.2-----------\(Thread.current)-----------")
        }
        serialQueue.sync {
            sleep(1)
            print("3.1.3-----------\(Thread.current)-----------")
        }
        serialQueue.sync {
            sleep(1)
            print("3.1.4-----------\(Thread.current)-----------")
        }
        print("3.1-----------\(Thread.current)-----------end")


        // 3.2
//        print("3.2-----------\(Thread.current)-----------start")
//        serialQueue.async {
//            sleep(1)
//            print("3.2.1-----------\(Thread.current)-----------")
//        }
//        serialQueue.async {
//            sleep(1)
//            print("3.2.2-----------\(Thread.current)-----------")
//        }
//        serialQueue.async {
//            sleep(1)
//            print("3.2.3-----------\(Thread.current)-----------")
//        }
//        serialQueue.async {
//            sleep(1)
//            print("3.2.4-----------\(Thread.current)-----------")
//        }
//        print("3.2-----------\(Thread.current)-----------end")
        
        // 3.3 同步 + 并行
//        print("3.3-----------\(Thread.current)-----------start")
//        concurrentQueue.sync {
//            sleep(1)
//            print("3.3.1-----------\(Thread.current)-----------")
//        }
//        concurrentQueue.sync {
//            sleep(1)
//            print("3.3.2-----------\(Thread.current)-----------")
//        }
//        concurrentQueue.sync {
//            sleep(1)
//            print("3.3.3-----------\(Thread.current)-----------")
//        }
//        concurrentQueue.sync {
//            sleep(1)
//            print("3.3.4-----------\(Thread.current)-----------")
//        }
//        print("3.3-----------\(Thread.current)-----------end")
        
        
        // 3.4 异步 + 并行
//        print("3.4-----------\(Thread.current)-----------start")
//        concurrentQueue.async {
//            sleep(1)
//            print("3.4.1-----------\(Thread.current)-----------")
//        }
//        concurrentQueue.async {
//            sleep(1)
//            print("3.4.2-----------\(Thread.current)-----------")
//        }
//        concurrentQueue.async {
//            sleep(1)
//            print("3.4.3-----------\(Thread.current)-----------")
//        }
//        concurrentQueue.async {
//            sleep(1)
//            print("3.4.4-----------\(Thread.current)-----------")
//        }
//        print("3.4-----------\(Thread.current)-----------end")
        
        
        // 3.5.1 在主线程中调用 同步 + 主队列
//        let mainQueue = DispatchQueue.main
//        mainQueue.sync {
//            sleep(1)
//            print("1-----------\(Thread.current)-----------")
//        }
//        mainQueue.sync {
//            sleep(1)
//            print("2-----------\(Thread.current)-----------")
//        }
//        mainQueue.sync {
//            sleep(1)
//            print("3-----------\(Thread.current)-----------")
//        }
        
        // 3.5.2 在其他线程中调用 同步 + 主队列
//        let queue = DispatchQueue(label: "com.tsn.test.queue", attributes: .concurrent)
//        queue.async {
//            print("0-----------\(Thread.current)-----------start")
//            let mainQueue = DispatchQueue.main
//            mainQueue.sync {
//                sleep(1)
//                print("1-----------\(Thread.current)-----------")
//            }
//            mainQueue.sync {
//                sleep(1)
//                print("2-----------\(Thread.current)-----------")
//            }
//            mainQueue.sync {
//                sleep(1)
//                print("3-----------\(Thread.current)-----------")
//            }
//            print("4-----------\(Thread.current)-----------end")
//        }
        
        
        // 3.6 异步+主队列
//        print("3.6-----------\(Thread.current)-----------start")
//        let mainQueue = DispatchQueue.main
//        mainQueue.async {
//            sleep(1)
//            print("3.6.1-----------\(Thread.current)-----------")
//        }
//        mainQueue.async {
//            sleep(1)
//            print("3.6.2-----------\(Thread.current)-----------")
//        }
//        mainQueue.async {
//            sleep(1)
//            print("3.6.3-----------\(Thread.current)-----------")
//        }
//        print("3.6-----------\(Thread.current)-----------end")
    }
    
}

let com = Combination()
com.configCombination()

// DispatchSource
var num = 5
let source: DispatchSourceTimer = DispatchSource.makeTimerSource(flags: [], queue: .global())
source.schedule(deadline: .now(), repeating: 1)
// 设置监听
source.setEventHandler {
    num = num - 1
    if num < 0 {
        source.cancel()
    } else {
        print("num-----------\(num)-----------")
    }
}
// 取消监听
source.setCancelHandler {
    print("-----------取消监听-----------")
}
source.resume()
// 线程安全
for index in 0..<123 {
    queue.async {
        print("-----------\(index)-----------")
    }
}

for index in 0..<123 {
    queue.async {
        lock.lock()
        print("-----------\(index)-----------")
        lock.unlock()
    }
}
// 线程死锁
class LockTestClass {
    init() {
    
        
        // 主队列 + 同步
//        DispatchQueue.main.sync {
//            print("-----------死锁-----------")
//        }
        // 串行队列 + (同步或异步) 嵌套自身同步
//        let serialQueue = DispatchQueue.init(label: "com.tsn.LockTestClass")
//        serialQueue.async {
//            serialQueue.sync {
//                print("-----------死锁-----------")
//            }
//        }
        // 互斥锁
        func synchronized(lockData: AnyObject) {
            objc_sync_enter(lockData)
            objc_sync_exit(lockData)
        }
        
    }
}
LockTestClass()

