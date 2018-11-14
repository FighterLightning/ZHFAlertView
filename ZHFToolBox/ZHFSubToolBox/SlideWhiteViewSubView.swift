//
//  SlideWhiteViewSubView.swift
//  SlideViewTest
//
//  Created by 张海峰 on 2018/11/14.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit
//添加一个列表点击代理
protocol SlideWhiteViewSubViewDelegate {
    func selectMessage(message: String)
}
class SlideWhiteViewSubView: SlideView {
    var delegate:SlideWhiteViewSubViewDelegate?
    lazy var dataMarr:NSMutableArray = NSMutableArray()
    override func addAnimate() {
        UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        UIView.animate(withDuration:TimeInterval(defaultTime), animations: {
            self.WhiteView.frame = self.whiteViewEndFrame
        }) { (_) in
            //添加白色视图内容
            self.addWhiteViewSubViews()
        }
    }
    func addWhiteViewSubViews(){
        //添加头部内容
        let imageView: UIImageView = UIImageView.init(frame: CGRect.init(x: (WhiteView.frame.width - 100)/2, y: 50, width: 100, height: 100))
        imageView.image = UIImage.init(named: "test1")
        imageView.layer.masksToBounds = true
        imageView.layer.cornerRadius = 50
        WhiteView.addSubview(imageView)
        //添加一个列表
        self.dataMarr = ["视图标题一","视图标题二","视图标题三","视图标题四","视图标题五"]
        addTableView()
        //添加底部按钮（底部按钮点击响应可以1.通过代理方法(类似列表的代理实现)2.也可以把按钮定义成全局的，在VC中直接 WhiteView.setBtn1.addTarget(self, action: #selector(setBtn1Click), for: UIControlEvents.touchUpInside)）
        let setBtn1: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        setBtn1.frame = CGRect.init(x: 40, y: WhiteView.frame.height - 100, width: 50, height: 30)
        setBtn1.setTitle("设置1", for: UIControl.State.normal)
        setBtn1.backgroundColor = UIColor.orange
       
        WhiteView.addSubview(setBtn1)
        let setBtn2: UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        setBtn2.frame = CGRect.init(x: setBtn1.frame.maxX + 30, y: WhiteView.frame.height - 100, width: 50, height: 30)
        setBtn2.setTitle("设置2", for: UIControl.State.normal)
        setBtn2.backgroundColor = UIColor.red
        WhiteView.addSubview(setBtn2)
    }
    func addTableView(){
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 200, width: WhiteView.frame.width, height: WhiteView.frame.height - 300), style: UITableView.Style.plain)
        WhiteView.addSubview(tableView)
        tableView.backgroundColor = UIColor.white
        tableView.separatorColor = UIColor.black
        tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
    
}
extension SlideWhiteViewSubView :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataMarr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alertCellIdentifier  = "alertCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: alertCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: alertCellIdentifier)
        }
        cell?.textLabel?.text = self.dataMarr[indexPath.row] as? String
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.textColor = UIColor.lightGray
        cell?.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.dataMarr[indexPath.row] as! String
        //先回收再传值
        UIView.animate(withDuration: 0.5, animations: {
            self.tapBtnAndbackBtnClick()
        }) { (_) in
            self.delegate?.selectMessage(message:message)
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

