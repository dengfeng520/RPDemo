//
//  ViewController.swift
//  OperationDemo
//
//  Created by rp.wang on 2021/2/19.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.title = "test"
    }
    
    @IBAction func clickDownVC(_ sender: Any) {
        let downVC = DownloadImageViewController()
        navigationController?.pushViewController(downVC, animated: true)
    }
    
    @IBAction func clickSerialVC(_ sender: Any) {
        let serialVC = SerialQueueViewController()
        navigationController?.pushViewController(serialVC, animated: true)
    }
    @IBAction func clickCancelVC(_ sender: Any) {
        let cancelVC = CancelQueueViewController()
        navigationController?.pushViewController(cancelVC, animated: true)
    }
    @IBAction func clickInheritVC(_ sender: Any) {
        let inheritVC = InheritViewController()
        navigationController?.pushViewController(inheritVC, animated: true)
    }
}

