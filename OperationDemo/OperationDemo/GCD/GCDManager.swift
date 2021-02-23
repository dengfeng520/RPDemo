//
//  GCDManager.swift
//  OperationDemo
//
//  Created by rp.wang on 2021/2/20.
//

import UIKit

class GCDManager: NSObject {
    func configQueue() {
        let queue = DispatchQueue.init(label: "com.tsn.queue", qos: .default, attributes: .concurrent, autoreleaseFrequency: .inherit, target: nil)
        
        // 异步
        queue.async {
            print("---------------00")
        }
        // 同步
        queue.sync {
            print("---------------11")
        }
        queue.asyncAfter(deadline: .now() + 1) {
            print("---------------22")
        }
        print("---------------33")
    }
}
