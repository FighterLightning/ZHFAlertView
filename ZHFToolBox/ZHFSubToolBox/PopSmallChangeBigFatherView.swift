//
//  FatherView.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2018/5/9.
//  Copyright © 2018年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
    https://github.com/FighterLightning/ZHFToolBox.git
https://www.jianshu.com/p/88420bc4d32d
 */
/*弹框的基础图*/
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
