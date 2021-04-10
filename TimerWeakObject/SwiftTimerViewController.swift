//
//  SwiftTimerViewController.swift
//  NSTimerDemo
//
//  Created by rp.wang on 2021/4/9.
//

import UIKit

@objcMembers class SwiftTimerViewController: UIViewController {
    
    weak var time: Timer?
    var source: DispatchSourceTimer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if #available(iOS 10.0, *) {
            /// iOS 10之后采用Block方式解决NSTimer 循环引用问题
            time = Timer.scheduledTimer(withTimeInterval: 2, repeats: true, block: { [weak self] (timer) in
                guard let `self` = self else { return }
                self.timePrint()
            })
        } else {
            /// iOS 10之前的解决方案： 模仿系统的Block 解决Timer循环引用问题
            time = Timer.rp_scheduledTimer(timeInterval: 2, repeats: true, closure: { [weak self] (timer) in
                guard let `self` = self else { return }
                self.timePrint()
            })
        }
        
        
        
//        source = DispatchSource.makeTimerSource(flags: [], queue: .global())
//        source?.schedule(deadline: .now(), repeating: 2)
//        // 设置监听
//        source?.setEventHandler {
//            print("---------------------")
//        }
//        source?.resume()
         
    }
    
    func timePrint() {
        print("---------------------")
    }
    
    deinit {
        print("deinit---------------------11111")
//        source?.cancel()
//        source = nil
        time?.invalidate()
        time = nil
    }
}

