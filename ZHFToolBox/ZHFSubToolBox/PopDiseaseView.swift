//
//  PopDiseaseView.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2019/3/13.
//  Copyright © 2019年 张海峰. All rights reserved.
//

import UIKit

class PopDiseaseView: UIView {
    //声明闭包
    typealias clickBtnClosure = (String?) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //为闭包设置调用函数
    func clickValueClosure(closure:clickBtnClosure?){
        clickClosure = closure
    }
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    var radioBtn: UIButton!
    var okBtn: UIButton!
    //初始化视图
    func initPopDiseaseView() -> PopDiseaseView {
    self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
    self.backgroundColor = backgroundColor1
    return self
    }
    //弹出View
    func addAnimate(view:PopDiseaseView) {
       UIApplication.shared.keyWindow?.addSubview(view)
    }
    func addWhiteViewContent(arr: NSArray) {
        let  whiteView:UIView = UIView()
        whiteView.backgroundColor = UIColor.white
        
        whiteView.frame = CGRect.init(x: 0, y: ScreenHeight - ScreenHeight*2/3, width: ScreenWidth, height: ScreenHeight*2/3)
        self.addSubview(whiteView)
        let scrollView: UIScrollView = UIScrollView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight*2/3 - 100))
        scrollView.contentSize = CGSize.init(width: 0, height: CGFloat(arr.count+2)/3 * 50)
        scrollView.showsVerticalScrollIndicator = false
        whiteView.addSubview(scrollView)
        for i in 0 ..< arr.count {
            let name: String = arr[i] as! String
            let btn: UIButton = UIButton.init(type: UIButtonType.custom)
            let btnW: CGFloat = (ScreenWidth - 40)/3
            btn.frame = CGRect.init(x: 10 + CGFloat(i%3) * (btnW + 10), y: 15 + CGFloat(i/3 * 50), width: btnW, height: 44)
            btn.setTitle(name, for: UIControlState.normal)
            btn.setTitleColor(ZHFColor.zhf33_titleTextColor, for: UIControlState.normal)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 10
            btn.layer.borderWidth = 1
            btn.layer.borderColor = ZHFColor.zhf_lineColor.cgColor
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 12)
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            scrollView.addSubview(btn)
        }
        
        let lineView: UIView = UIView()
        lineView.frame = CGRect.init(x: 0, y: scrollView.frame.maxY + 20, width: ScreenWidth, height: 1)
        lineView.backgroundColor = ZHFColor.zhfcc_lineColor
        whiteView.addSubview(lineView)
        let cancelBtn: UIButton = UIButton.init(type: UIButtonType.custom)
        cancelBtn.frame = CGRect.init(x: 25, y: lineView.frame.maxY + 10, width: ScreenWidth/2 - 37.5, height: 40)
        cancelBtn.setTitle("取消", for: UIControlState.normal)
        cancelBtn.backgroundColor = UIColor.red
        cancelBtn.setTitleColor(ZHFColor.white, for: UIControlState.normal)
        cancelBtn.layer.masksToBounds = true
        cancelBtn.layer.cornerRadius = 20
        cancelBtn.addTarget(self, action: #selector(tapBtnAndcancelBtnClick), for: UIControlEvents.touchUpInside)
        whiteView.addSubview(cancelBtn)
        okBtn = UIButton.init(type: UIButtonType.custom)
        okBtn.frame = CGRect.init(x:ScreenWidth/2 + 12.5, y: lineView.frame.maxY + 10, width: ScreenWidth/2 - 37.5, height: 40)
        okBtn.setTitle("确认修改", for: UIControlState.normal)
        okBtn.backgroundColor = UIColor.red
        okBtn.setTitleColor(ZHFColor.white, for: UIControlState.normal)
        okBtn.layer.masksToBounds = true
        okBtn.isUserInteractionEnabled = false
        okBtn.alpha = 0.5
        okBtn.layer.cornerRadius = 20
        okBtn.addTarget(self, action: #selector(okBtnClick), for: UIControlEvents.touchUpInside)
        whiteView.addSubview(okBtn)
    }
    @objc func btnClick(btn:UIButton){
        if radioBtn != nil {
            radioBtn.backgroundColor = UIColor.white
            radioBtn.setTitleColor(ZHFColor.zhf33_titleTextColor, for: UIControlState.normal)
        }
        okBtn.isUserInteractionEnabled = true
        okBtn.alpha = 1
        btn.backgroundColor = UIColor.red
        btn.setTitleColor(UIColor.white, for: UIControlState.normal)
        radioBtn = btn
    }
    @objc func okBtnClick(btn:UIButton){
        if radioBtn != nil {
            if clickClosure != nil{
                clickClosure!(radioBtn.titleLabel!.text)
            }
             self.removeFromSuperview()
        }
    }
    //移除
    @objc func tapBtnAndcancelBtnClick() {
        self.removeFromSuperview()
    }
}
