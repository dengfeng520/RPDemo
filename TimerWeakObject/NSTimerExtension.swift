//
//  NSTimerExtension.swift
//  NSTimerDemo
//
//  Created by rp.wang on 2021/4/9.
//

import UIKit

extension Timer {
    class func rp_scheduledTimer(timeInterval ti: TimeInterval, repeats yesOrNo: Bool, closure: @escaping (Timer) -> Void) -> Timer {
        return self.scheduledTimer(timeInterval: ti, target: self, selector: #selector(RP_TimerHandle(timer:)), userInfo: closure, repeats: yesOrNo)
    }
    
    @objc class func RP_TimerHandle(timer: Timer) {
        var handleClosure = { }
        handleClosure = timer.userInfo as! () -> ()
        handleClosure()
    }
}
