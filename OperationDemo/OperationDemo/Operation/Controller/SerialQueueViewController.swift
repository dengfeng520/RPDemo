//
//  SerialQueueViewController.swift
//  RPChat_iOS
//
//  Created by rp.wang on 2021/2/4.
//  Copyright © 2021 Beijing Physical Fitness Sport Science and Technology Co.,Ltd. All rights reserved.
//

import UIKit

class SerialQueueViewController: QueueBaseViewController {
    let queue = OperationQueue()

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Serial Queue"
        configItemUI()
        // Do any additional setup after loading the view.
        slider.thumbTintColor = .hexStringToColor("#1aaba8")
    }
   
    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        configOperationQueue()
    }
    
    private func configItemUI() {
       
        let cancelItem = UIBarButtonItem.init(title: "cancel", style: .done, target: self, action: #selector(clickCancel))
        
        let downloadItem = UIBarButtonItem.init(title: "download", style: .done, target: self, action: #selector(clickDownload))
        
        
        
        navigationItem.rightBarButtonItems = [cancelItem,downloadItem]
    }
    
    @objc func clickDownload() {
        self.configImage()
        if self.fpsLab.isHidden == true {
            self.fpsLab.isHidden = false
        }
    }
    
    @objc func clickCancel() {
        self.queue.cancelAllOperations()
    }
    
    private func configOperationQueue() {
        // 创建一个Operation
        let operation = BlockOperation(block: {
            // 要执行的任务，如下载图片等
        })
        operation.qualityOfService = .default
        operation.completionBlock = {
            // 执行完成后
        }
        // 创建一个队列
        let queue = OperationQueue()
        // 设置最大并发数 不设置时系统回根据当前情况动态设置最大并发数
        queue.maxConcurrentOperationCount = 5
        // 将Operation添加到queue队列中
        queue.addOperation {
            
        }
        operation.queuePriority = .high
        operation.cancel()
        queue.cancelAllOperations()
    }
    
    func configImage() {
        // 创建串行队列 serialQueue
//        let serialQueue = DispatchQueue(label: "TSN.RPChat.io")
//        let concurrentQueue = DispatchQueue(label: "TSN.RPChat.io", attributes: .concurrent)

        var upImg: UIImageView? = nil
        
        for (index, imgurl) in DownloaderManager.imageArray.enumerated() {
            let girlsImg = UIImageView()
            containerView.addSubview(girlsImg)
            girlsImg.translatesAutoresizingMaskIntoConstraints = false
            girlsImg.leftAnchor.constraint(equalTo: containerView.leftAnchor, constant: 8).isActive = true
            girlsImg.rightAnchor.constraint(equalTo: containerView.rightAnchor, constant: -8).isActive = true
            girlsImg.heightAnchor.constraint(equalToConstant: 180).isActive = true
            
            if index == 0 {
                girlsImg.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 8).isActive = true
            } else {
                girlsImg.topAnchor.constraint(equalTo: upImg!.bottomAnchor, constant: 8).isActive = true
            }
            
            // 最后一张图片
            if index == DownloaderManager.imageArray.count - 1 {
                girlsImg.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
            }
            // 不使用多线程
//            let image = DownloaderManager.downloadImageWithURL(imgurl)
            
            // GCD
//            concurrentQueue.async {
//                let image = DownloaderManager.downloadImageWithURL(imgurl)
//                DispatchQueue.main.async {
//                    girlsImg.image = image
//                }
//            }
            
//            queue.addOperation {
//                // 要执行的任务，如下载图片等
//               let image = DownloaderManager.downloadImageWithURL(imgurl)
//               OperationQueue.main.addOperation {
//                   girlsImg.image = image
//               }
//            }
            
            // OperationQueue 队列
            let operation = BlockOperation(block: {
                // 要执行的任务，如下载图片等
               let image = DownloaderManager.downloadImageWithURL(imgurl)
               OperationQueue.main.addOperation {
                   girlsImg.image = image
               }
            })
            operation.completionBlock = {
                // 执行完成后
                print("-----------------operation\(index),\(operation.isCancelled)")
            }
            // 将Operation添加到queue队列中
            queue.addOperation(operation)
            
            girlsImg.layer.cornerRadius = 8
            girlsImg.clipsToBounds = true
            girlsImg.contentMode = .scaleAspectFill
            
            
            upImg = girlsImg
        }
        
        view.layoutIfNeeded()
        scrollView.contentSize = CGSize(width: __screenWidth, height: containerView.frame.size.height)
    }
    
    lazy var containerView: UIView = {
        scrollView.addSubview($0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.topAnchor.constraint(equalTo: scrollView.topAnchor, constant: 0).isActive = true
        $0.leftAnchor.constraint(equalTo: scrollView.leftAnchor, constant: 0).isActive = true
        $0.widthAnchor.constraint(equalToConstant: __screenWidth).isActive = true
        $0.heightAnchor.constraint(greaterThanOrEqualToConstant: __screenHeight).isActive = true
        return $0
    }(UIView())
    
    lazy var scrollView: UIScrollView = {
        view.addSubview($0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        $0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 0).isActive = true
        $0.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1).isActive = true
        $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -40).isActive = true
        return $0
    }(UIScrollView())
    
    lazy var slider: UISlider = {
        view.addSubview($0)
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 20).isActive = true
        $0.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -20).isActive = true
        $0.heightAnchor.constraint(equalToConstant: 30).isActive = true
        $0.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0).isActive = true
        return $0
    }(UISlider())
}
