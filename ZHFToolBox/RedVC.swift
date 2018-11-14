//
//  RedVC.swift
//  SlideViewTest
//
//  Created by 张海峰 on 2018/11/14.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit

class RedVC: UIViewController {
    var message:String = ""
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.red
        self.title = message
    }
}
