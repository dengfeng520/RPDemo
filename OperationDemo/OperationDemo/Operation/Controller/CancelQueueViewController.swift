//
//  CancelQueueViewController.swift
//  RPChat_iOS
//
//  Created by rp.wang on 2021/2/18.
//  Copyright © 2021 Beijing Physical Fitness Sport Science and Technology Co.,Ltd. All rights reserved.
//

import UIKit

class CancelQueueViewController: UIViewController {
    
    var girlsImg1: UIImageView = UIImageView()
    var girlsImg2: UIImageView = UIImageView()
    var girlsImg3: UIImageView = UIImageView()
    var girlsImg4: UIImageView = UIImageView()
    let queue = OperationQueue()
        
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "cancel"
        configUI()
        // Do any additional setup after loading the view.
    }
    
    private func configUI() {
        view.addSubview(girlsImg1)
        girlsImg1.translatesAutoresizingMaskIntoConstraints = false
        girlsImg1.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 8).isActive = true
        configGirlsImg(girlsImg1)
        
        view.addSubview(girlsImg2)
        girlsImg2.translatesAutoresizingMaskIntoConstraints = false
        girlsImg2.topAnchor.constraint(equalTo: girlsImg1.bottomAnchor, constant: 8).isActive = true
        configGirlsImg(girlsImg2)
        
        view.addSubview(girlsImg3)
        girlsImg3.translatesAutoresizingMaskIntoConstraints = false
        girlsImg3.topAnchor.constraint(equalTo: girlsImg2.bottomAnchor, constant: 8).isActive = true
        configGirlsImg(girlsImg3)
        
        view.addSubview(girlsImg4)
        girlsImg4.translatesAutoresizingMaskIntoConstraints = false
        girlsImg4.topAnchor.constraint(equalTo: girlsImg3.bottomAnchor, constant: 8).isActive = true
        configGirlsImg(girlsImg4)
        
        let cancelItem = UIBarButtonItem.init(title: "cancel", style: .done, target: self, action: #selector(clickCancel))
        
        let downloadItem = UIBarButtonItem.init(title: "download", style: .done, target: self, action: #selector(clickDownload))
        
        navigationItem.rightBarButtonItems = [cancelItem,downloadItem]
    }
    
    @objc func clickDownload() {
        self.configQueue()
    }
    
    @objc func clickCancel() {
        self.queue.cancelAllOperations()
    }
    
    private func configGirlsImg(_ girlsImg: UIImageView) {
        girlsImg.layer.cornerRadius = 8
        girlsImg.clipsToBounds = true
        girlsImg.contentMode = .scaleAspectFill
        girlsImg.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 8).isActive = true
        girlsImg.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -8).isActive = true
        girlsImg.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    private func configQueue() {
        let imgArray: [String] = DownloaderManager.imageArray
        
        let operation1 = BlockOperation(block: {
            let image = DownloaderManager.downloadImageWithURL(imgArray[0])
            OperationQueue.main.addOperation {
                self.girlsImg1.image = image
            }
        })
        operation1.completionBlock = {
            print("-------operation1,\(operation1.isCancelled)")
        }
        queue.addOperation(operation1)

        
        let operation2 = BlockOperation(block: {
            let image = DownloaderManager.downloadImageWithURL(imgArray[1])
            OperationQueue.main.addOperation {
                self.girlsImg2.image = image
            }
        })
        operation2.completionBlock = {
            print("-------operation2,\(operation2.isCancelled)")
        }

        
        let operation3 = BlockOperation(block: {
            let image = DownloaderManager.downloadImageWithURL(imgArray[2])
            OperationQueue.main.addOperation {
                self.girlsImg3.image = image
                self.queue.cancelAllOperations()
            }
        })
        operation3.completionBlock = {
            print("-------operation3,\(operation3.isCancelled)")
            
        }
        
        let operation4 = BlockOperation(block: {
            let image = DownloaderManager.downloadImageWithURL(imgArray[6])
            OperationQueue.main.addOperation {
                self.girlsImg4.image = image
            }
        })
        operation4.completionBlock = {
            print("-------operation4,\(operation4.isCancelled)")
        }

        operation3.addDependency(operation4)
        operation2.addDependency(operation3)
     
        queue.addOperation(operation4)
        queue.addOperation(operation3)
        queue.addOperation(operation2)
    }
}
