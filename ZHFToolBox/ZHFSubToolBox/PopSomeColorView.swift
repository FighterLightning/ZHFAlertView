//
//  PopSelectColorView.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2018/5/30.
//  Copyright © 2018年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
 相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
 https://github.com/FighterLightning/ZHFToolBox.git
 https://www.jianshu.com/p/88420bc4d32d
 */
/*弹出一堆小视图，带回弹*/
import UIKit
protocol PopSomeColorViewDelegate {
    func selectBtnTag(btnTag: NSInteger)
}
//定义闭包类型（特定的函数类型函数类型）
typealias InputClosureType = (String) -> Void
class PopSomeColorView: UIView {
    
    var delegate:PopSomeColorViewDelegate?
    //接收上个页面传过来的闭包块
    var backClosure: InputClosureType?
    var animateTime:TimeInterval = 0.9 //动画总时长
    var delyTime:CGFloat = 0.1 //每两个动画间隔时长
    var cancelBtn :UIButton = UIButton()
    var Y :CGFloat = ScreenHeight/2 + 100 //每个按钮上移的距离
    let colors: NSArray = [UIColor.green,UIColor.yellow,UIColor.blue,UIColor.red,UIColor.purple,UIColor.orange];
    let btnWH: CGFloat = (ScreenWidth - 120)/3
    lazy var btnMarr: NSMutableArray = NSMutableArray()
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0 , green: 0, blue: 0, alpha: 0.5) //初始化视图
    func initPopSelectColorView() -> UIView {
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = backgroundColor1
        self.isHidden = true
        for j in 0 ..< colors.count {
            let btn :UIButton = UIButton.init(type: UIButtonType.custom)
            btn.frame = CGRect.init(x: 50 + (10 + btnWH) * CGFloat(j%3), y: ScreenHeight + CGFloat(j/3) * (btnWH + 40), width: btnWH, height:btnWH)
            btn.layer.borderColor = ZHFColor.zhff9_backGroundColor.cgColor
            btn.layer.borderWidth = 4
            btn.backgroundColor = colors[j] as? UIColor;
            btn.tag = j
            btn.addTarget(self, action: #selector(cancelBtnClick), for: UIControlEvents.touchUpInside)
            self.btnMarr.add(btn)
            self.addSubview(btn)
            if j == colors.count - 1{
                self.cancelBtn = UIButton.init(type: UIButtonType.custom)
                self.cancelBtn.frame = CGRect.init(x:ScreenWidth/2 - 20, y: btn.frame.maxY + 40, width: 40, height: 40)
                self.cancelBtn.setImage(UIImage.init(named: "cancel_white"), for: UIControlState.normal)
                self.cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: UIControlEvents.touchUpInside)
                self.addSubview(cancelBtn)
            }
        }
        return self
    }
    func addAnimate(){
    UIApplication.shared.keyWindow?.addSubview(self.initPopSelectColorView())
        self.isHidden = false
        for i in 0 ..< self.btnMarr.count {
            let btn: UIButton = self.btnMarr[i] as! UIButton
            let btnY : CGFloat = btn.frame.origin.y
            let cancelBtnY :CGFloat =  self.cancelBtn.frame.origin.y
            UIView.animate(withDuration: self.animateTime, delay: TimeInterval(self.delyTime * CGFloat(i)) , usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                btn.frame.origin.y = btnY - self.Y
            }, completion: { (_) in
                self.cancelBtn.transform = CGAffineTransform.init(rotationAngle:0)
                UIView.animate(withDuration: self.animateTime, animations: {
                    self.cancelBtn.frame.origin.y = cancelBtnY - self.Y
                  self.cancelBtn.transform = CGAffineTransform.init(rotationAngle:.pi/2)
                })
            })
        }
    }
    @objc func cancelBtnClick(btn: UIButton){
        if btn != cancelBtn {
            self.delegate?.selectBtnTag(btnTag: btn.tag)
        }
        self.isHidden = false
        UIView.animate(withDuration: self.animateTime, animations: {
            self.cancelBtn.frame.origin.y += self.Y
            self.cancelBtn.transform = CGAffineTransform.init(rotationAngle:0)
        }) { (_) in
            for i in 0 ..< self.btnMarr.count {
                let btn: UIButton = self.btnMarr[self.btnMarr.count - i - 1] as! UIButton;
                let btnY : CGFloat = btn.frame.origin.y;
                UIView.animate(withDuration: self.animateTime, delay: TimeInterval(self.delyTime * CGFloat(i)) , usingSpringWithDamping: 0.7, initialSpringVelocity: 0.2, options: UIViewAnimationOptions.curveEaseInOut, animations: {
                    btn.frame.origin.y = btnY + self.Y
                }, completion: { (_) in
                    self.btnMarr = NSMutableArray.init()
                    self.removeFromSuperview()
                })
        }
    }
 }
}
