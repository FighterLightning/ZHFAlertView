//
//  SlideView.swift
//  SlideViewTest
//
//  Created by 张海峰 on 2018/11/8.
//  Copyright © 2018年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
 相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
 https://github.com/FighterLightning/ZHFToolBox.git
 https://www.jianshu.com/p/88420bc4d32d
 */
/*侧滑视图主框架*/
import UIKit
enum SlideDirection: NSInteger {
    case left
    case right
}
class SlideView: UIView,UIGestureRecognizerDelegate {
    var isfromLeft: Bool = true
    var currentPanDirection: SlideDirection?
    //白色view用来装一些控件
    var WhiteView: UIView =  UIView()
    var whiteViewStartFrame: CGRect = CGRect.init(x: -ScreenWidth*4/5, y: 0, width: ScreenWidth*4/5, height: ScreenHeight)
    var whiteViewEndFrame: CGRect = CGRect.init(x: 0, y: 0, width: ScreenWidth*4/5, height: ScreenHeight)
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
        self.addSubview(WhiteView)
        //添加点击手势
        let tap: UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBtnAndbackBtnClick))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        //添加侧滑手势
        let pan: UIPanGestureRecognizer = UIPanGestureRecognizer.init(target: self, action: #selector(self.didPanEvent))
        pan.delegate = self
        self.addGestureRecognizer(pan)
        return self
    }
    //弹出的动画效果
    func addAnimate() {
        
    }
    //收回的动画效果
    @objc func tapBtnAndbackBtnClick() {
        UIView.animate(withDuration: TimeInterval(defaultTime), animations: {
            self.WhiteView.frame = self.whiteViewStartFrame
        }) { (_) in
            for view in self.WhiteView.subviews {
                view.removeFromSuperview()
            }
           self.isHidden = true
        }  
    }
    //通过手势收回的动画效果
    @objc func didPanEvent(recognizer: UIPanGestureRecognizer){
        //拿到手势在移动过程中当前位置（相对于其实位置为（0，0））
        let translation: CGPoint = recognizer.translation(in: self)
        if (translation.x != 0){
            //确定移动（并判断手势方向）
            currentPanDirection = translation.x > 0 ? SlideDirection.right : SlideDirection.left
        }
        //位置归0
        recognizer.setTranslation(CGPoint.zero, in: self)
        //根据手势操作
        switch recognizer.state {
        case .began: break
        case .changed:
            let tempX :CGFloat = self.WhiteView.frame.minX + translation.x
            //从左边出来
            if isfromLeft == true{
                //可移动的条件 左滑||右滑 小于打开时的minX
                if translation.x < 0 || (translation.x > 0 && tempX < 0){
                    self.WhiteView.frame = CGRect.init(x: tempX, y: (ScreenHeight - WhiteView.frame.height)/2, width: WhiteView.frame.width, height: WhiteView.frame.height)
                }
            }
            //从右边出来
            if isfromLeft == false{
                  //可移动的条件 右滑||左滑 大于打开时的minX
                if translation.x > 0 || (translation.x < 0 &&  tempX > (ScreenWidth - WhiteView.frame.width)){
                    self.WhiteView.frame = CGRect.init(x: tempX, y: (ScreenHeight - WhiteView.frame.height)/2, width: WhiteView.frame.width, height: WhiteView.frame.height)
                }
            }
        case .cancelled: break
        case .ended:
            if isfromLeft == true{
                if self.currentPanDirection == SlideDirection.left{
                    self.tapBtnAndbackBtnClick()
                }
                if self.currentPanDirection == SlideDirection.right{
                    self.WhiteView.frame = CGRect.init(x: 0, y: (ScreenHeight - WhiteView.frame.height)/2, width: WhiteView.frame.width, height: WhiteView.frame.height)
                }
            }
            if isfromLeft == false{
                if self.currentPanDirection == SlideDirection.right{
                    self.tapBtnAndbackBtnClick()
                }
                if self.currentPanDirection == SlideDirection.left{
                    self.WhiteView.frame = CGRect.init(x: ScreenWidth - WhiteView.frame.width, y: (ScreenHeight - WhiteView.frame.height)/2, width: WhiteView.frame.width, height:  WhiteView.frame.height)
                }
            }
        default:
            break
        }
    }
    //防止侧滑视图手势与列表点击起冲突
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldReceive touch: UITouch) -> Bool {
        /**
         *判断如果点击的是tableView的cell，就把手势给关闭了 不是点击cell手势开启
         **/
        if NSStringFromClass((touch.view?.classForCoder)!) == "UITableViewCellContentView"  {
            return false
        }
        return true
    }
}
