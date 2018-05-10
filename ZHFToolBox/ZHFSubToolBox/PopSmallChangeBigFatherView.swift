//
//  FatherView.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2018/5/9.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit

class PopSmallChangeBigFatherView: UIView ,UIGestureRecognizerDelegate{
    //白色view用来装一些控件
    var WhiteView: UIView =  UIView()
    var whiteViewStartFrame: CGRect = CGRect.init(x: ScreenWidth/2 - 10, y: ScreenHeight/2 - 10, width: 20, height: 20)
    var whiteViewEndFrame: CGRect = CGRect.init(x: 40, y: 100, width: ScreenWidth - 80, height: ScreenHeight - 230)
    //取消按钮
    var cancelBtn: UIButton = UIButton()
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    var defaultTime:CGFloat = 0.5
    
    //初始化视图
    func initPopBackGroundView() -> UIView {
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = backgroundColor1
        self.isHidden = true
        //设置添加地址的View
        self.WhiteView.frame = whiteViewStartFrame
        WhiteView.backgroundColor = UIColor.white
        WhiteView.layer.masksToBounds = true
        WhiteView.layer.cornerRadius = 10
        self.addSubview(WhiteView)
        cancelBtn = UIButton.init(type: UIButtonType.custom)
        cancelBtn.frame = CGRect.init(x:ScreenWidth/2 - 20, y: WhiteView.frame.maxY + 20, width: 40, height: 40)
        cancelBtn.tag = 1
        cancelBtn.setImage(UIImage.init(named: "cancel_white"), for: UIControlState.normal)
        cancelBtn.isHidden = true
        cancelBtn.addTarget(self, action: #selector(tapBtnAndcancelBtnClick), for: UIControlEvents.touchUpInside)
        self.addSubview(cancelBtn)
        return self
    }
    //弹出的动画效果
    func addAnimate() {
        
    }
    //收回的动画效果
    @objc func tapBtnAndcancelBtnClick() {
        for view in WhiteView.subviews {
            view.removeFromSuperview()
        }
        UIView.animate(withDuration: TimeInterval(defaultTime), animations: {
            self.cancelBtn.isHidden = true
            self.WhiteView.frame = self.whiteViewStartFrame
            self.cancelBtn.frame.origin.y = self.WhiteView.frame.maxY + 20
        }) { (_) in
            self.isHidden = true
        }
        
    }
}
