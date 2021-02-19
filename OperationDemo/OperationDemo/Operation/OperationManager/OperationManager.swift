//
//  OperationManager.swift
//  OperationDemo
//
//  Created by rp.wang on 2021/2/19.
//

import UIKit

class OperationManager: Operation {
    var imgURL: String = String()
    
    init(with imgURL: String?) {
        super.init()
        self.imgURL = imgURL ?? String()
    }
    
    // 添加了main方法就是串行的，不添加就是并行的
    override func main() {
        guard self.isCancelled == true else { return }
    }

    override func start() {

    }
    
    func downImg(closures: @escaping (_ image: UIImage?) -> Void) {
        guard let img = DownloaderManager.downloadImageWithURL(self.imgURL) else {
            return
        }
        closures(img)
    }
}
