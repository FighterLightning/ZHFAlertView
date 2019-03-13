//
//  PopProgressBar.swift
//  test
//
//  Created by 张海峰 on 2019/3/4.
//  Copyright © 2019年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
 相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
 https://github.com/FighterLightning/ZHFToolBox.git
 渐变进度条：单独简书连接https://www.jianshu.com/p/d985207dac6b
 */
import UIKit

class PopProgressBar: UIView ,UIGestureRecognizerDelegate {
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    //进度条view
    var progressView: UIView =  UIView()
    //提示按钮
    var hintBtn: UIButton!
    var beforeValue :CGFloat = 0 //前一个值
    var displayLink: CADisplayLink! //定时器 承接控制器里的定时器，删除view时保证定时器关闭
    var path: UIBezierPath!
    var progressLayer :CAShapeLayer!
    //初始化视图
    func initPopBackGroundView() -> PopProgressBar {
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = backgroundColor1
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapBtnAndcancelBtnClick))
        tap.delegate = self
        self.addGestureRecognizer(tap)
        return self
    }
    //弹出View
    func addAnimate(view:PopProgressBar) {
        self.addProgressView()
        UIApplication.shared.keyWindow?.addSubview(view)
    }
    //添加进度条
    func addProgressView() {
        progressView = UIView.init(frame: CGRect.init(x: 25, y: 290, width: ScreenWidth - 50, height: 15))
        progressView.layer.masksToBounds = true
        progressView.layer.cornerRadius = 7.5
        progressView.backgroundColor = UIColor.white
        self.addSubview(progressView)
        hintBtn = UIButton.init(type: UIButton.ButtonType.custom)
        hintBtn.frame = CGRect.init(x: 8, y: progressView.frame.minY - 30, width: 34, height: 20)
        hintBtn.setBackgroundImage(UIImage.init(named: "progressHint"), for: UIControl.State.normal)
        hintBtn.setTitle("0.0%", for: UIControl.State.normal)
        hintBtn.titleLabel?.font = UIFont.systemFont(ofSize: 8)
        hintBtn.setTitleColor(UIColor.white, for: UIControl.State.normal)
        self.addSubview(hintBtn)
        self.gradentWith(frame: progressView.frame)
    }
    //为进度条添加遮罩，及layer
    @objc func gradentWith(frame:CGRect) {
        path = UIBezierPath.init()
        path.stroke()//添加遮罩
        progressLayer = CAShapeLayer.init()
        progressLayer.frame = progressView.bounds
        progressLayer.strokeColor = ZHFColor.initString(hex: "0x23D7DE").cgColor
        progressLayer.lineCap = CAShapeLayerLineCap.init(string: "kCALineCapRound") as String
        progressLayer.lineWidth = progressView.frame.size.height //渐变图层
        let grain:CALayer = CALayer.init()
        let gradientLayer: CAGradientLayer = CAGradientLayer.init()
        let fixColor: UIColor = ZHFColor.initString(hex: "0x71FFB7")
        let preColor: UIColor = ZHFColor.initString(hex: "0x23D7DE")
        gradientLayer.frame = CGRect.init(x: 0, y: 0, width: progressView.frame.size.width, height: progressView.frame.size.height)
        gradientLayer.colors = [preColor.cgColor,fixColor.cgColor]
        // 开始点
        gradientLayer.startPoint = CGPoint.init(x: 0, y: 0)
        // 结束点
        gradientLayer.endPoint = CGPoint.init(x: 1, y: 1)
        grain.addSublayer(gradientLayer)
        grain.mask = progressLayer
        progressView.layer.addSublayer(grain)//增加动画
        let pathAnimation : CABasicAnimation = CABasicAnimation.init(keyPath: "strokeEnd")
        pathAnimation.duration = 0;
        pathAnimation.timingFunction = CAMediaTimingFunction.init(name: "linear")
        pathAnimation.fromValue = NSNumber.init(value: 0.0)
        pathAnimation.toValue = NSNumber.init(value: 1.0)
        pathAnimation.autoreverses = false
        pathAnimation.repeatCount = 1
        progressLayer.add(pathAnimation, forKey: "strokeEndAnimation")
    }
    //当前进度
    func passValue(currentValue: CGFloat,allValue: CGFloat) {
        if currentValue < allValue {
            //当前比例
            let currentProportion : CGFloat = currentValue/allValue
            hintBtn.frame = CGRect.init(x: 8 + currentProportion * progressView.frame.size.width, y: progressView.frame.minY - 30, width: 34, height: 20)
            hintBtn.setTitle("\(NSInteger(currentProportion*100))%", for: UIControl.State.normal)
            path.move(to: CGPoint.init(x: progressView.frame.size.width * (beforeValue/allValue), y: progressView.frame.size.height/2))
            path.addLine(to: CGPoint.init(x: progressView.frame.size.width * currentProportion, y: progressView.frame.size.height/2))
            progressLayer.path = path.cgPath
        }
        else{
            //上传/下载成功 隐藏当前状态
            self.tapBtnAndcancelBtnClick()
        }
        beforeValue = currentValue
    }
    //移除或者中断进度
    @objc func tapBtnAndcancelBtnClick() {
        self.removeFromSuperview()
        displayLink.invalidate()
        displayLink = nil
    }
   
}
