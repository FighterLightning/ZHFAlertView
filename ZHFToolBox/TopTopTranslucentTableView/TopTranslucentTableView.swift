//
//  TopTranslucentTableView.swift
//  ZHFToolBox
//
//  Created by IOSZHF on 2022/5/19.
//  Copyright © 2022 张海峰. All rights reserved.
//

import UIKit

class TopTranslucentTableView: UIView {
    lazy var messageData :[String] = [String]()
    lazy var tableView : UITableView = {
        let tableView = UITableView.init(frame: CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300), style: .plain)
       // tableView.register(NormalCell.self, forCellReuseIdentifier: "normalcell")
        tableView.register(UINib.init(nibName: "NormalCell", bundle: Bundle.main), forCellReuseIdentifier: "NormalCellID")
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        tableView.separatorStyle = .none
        return tableView
    }()
    //初始化视图
    func initTopTranslucentTableView() -> UIView {
        self.backgroundColor = .clear
        // 渐变蒙层
        let layer :CAGradientLayer = CAGradientLayer.init()
        layer.colors = [
            UIColor.init(white: 0, alpha: 0.05).cgColor,
            UIColor.init(white: 0, alpha: 1.0).cgColor
        ];
        layer.locations = [0, 0.15]; // 设置颜色的范围
        layer.startPoint = CGPoint.init(x: 0, y: 0) // 设置颜色渐变的起点
        layer.endPoint = CGPoint.init(x: 0, y: 1) // 设置颜色渐变的终点，与 startPoint 形成一个颜色渐变方向
        layer.frame = CGRect.init(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: 300); // 设置 Frame
        self.layer.mask = layer; // 设置 mask 属性
        self.addSubview(self.tableView)
        return self
    }
    func addMessageData(number:NSInteger) {
        self.messageData.append("添加第\(number)条消息")
        self.tableView.insertRows(at: [IndexPath(row: self.messageData.count-1, section: 0)], with: .none)
        self.tableView.scrollToRow(at: IndexPath(row: self.messageData.count-1, section: 0), at: .bottom, animated: true)//滚到底部
    }
}
extension TopTranslucentTableView: UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.messageData.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NormalCellID", for: indexPath) as! NormalCell
        cell.backgroundColor = .clear
        cell.messageLabel.text = self.messageData[indexPath.row]
        cell.selectionStyle = UITableViewCell.SelectionStyle.none
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}
