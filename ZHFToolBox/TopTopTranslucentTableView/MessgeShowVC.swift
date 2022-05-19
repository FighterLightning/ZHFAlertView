//
//  MessgeAlapaTableView.swift
//  Swift Test
//
//  Created by IOSZHF on 2022/5/17.
//

import UIKit

class MessgeShowVC: UIViewController {
    var number: NSInteger = 0
    var time: Timer = Timer()
    var topTranslucentTableView: TopTranslucentTableView =  TopTranslucentTableView()
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.time.invalidate()
    }
    deinit {
        print("销毁MessgeAlapaTableView")
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white
        //背景图
        let imageView: UIView = UIImageView.init(image: UIImage.init(named: "back_ground"))
        imageView.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height)
        imageView.contentMode = .scaleAspectFill
        self.view.addSubview(imageView)
        topTranslucentTableView.frame = CGRect.init(x: 0, y: UIScreen.main.bounds.size.height - 300, width: UIScreen.main.bounds.size.width, height: 300)
        self.view.addSubview(topTranslucentTableView.initTopTranslucentTableView())
        
        self.time = Timer.init(timeInterval: 1, target: self, selector: #selector(addMessage), userInfo: nil, repeats: true)
        RunLoop.current.add(self.time, forMode: .common)//,common 保证滚动时定时器也走
    }
    @objc func addMessage() {
        number = number + 1
        topTranslucentTableView.addMessageData(number: number)
        if number==20{//20秒关闭定时器退到上一页
            self.time.invalidate()
            self.navigationController?.popViewController(animated: true)
        }
    }
   
}
