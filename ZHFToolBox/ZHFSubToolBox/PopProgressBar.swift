//
//  PopProgressBar.swift
//  test
//
//  Created by 张海峰 on 2019/3/4.
//  Copyright © 2019年 张海峰. All rights reserved.
//

import UIKit

class PopProgressBar: UIView ,UIGestureRecognizerDelegate {
    //白色view用来装一些控件
    var progressView: UIView =  UIView()
    var startValue: CGFloat = 0
    var endValue: CGFloat = 0
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    var defaultTime:CGFloat = 0.5
    var hintBtn: UIButton!//提示按钮
    var displayLink: CADisplayLink!
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
    //弹出的动画效果
    func addAnimate(view:PopProgressBar) {
        self.addProgressView()
    UIApplication.shared.keyWindow?.addSubview(view)
    }
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
        displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkRun))
        displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.defaultRunLoopMode)
    }
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
    @objc func displayLinkRun(displayLink:CADisplayLink) {
        startValue = endValue + 0.001
        if endValue < 1 {
            hintBtn.frame = CGRect.init(x: 8 + endValue * progressView.frame.size.width, y: progressView.frame.minY - 30, width: 34, height: 20)
            hintBtn.setTitle("\(NSInteger(endValue*100))%", for: UIControl.State.normal)
            self.prossValue(startValue: startValue, endValue: endValue)
        }
        else{
            //上传/下载成功
            self.stopDisplayLink()
            self.tapBtnAndcancelBtnClick()
        }
         endValue  = startValue;
    }
    func prossValue(startValue: CGFloat,endValue: CGFloat){
        path.move(to: CGPoint.init(x: progressView.frame.size.width * startValue, y: progressView.frame.size.height/2))
        path.addLine(to: CGPoint.init(x: progressView.frame.size.width * endValue, y: progressView.frame.size.height/2))
        progressLayer.path = path.cgPath
    }
    func stopDisplayLink(){
        displayLink.invalidate()
        displayLink = nil
    }
    //收回的动画效果
    @objc func tapBtnAndcancelBtnClick() {
        self.removeFromSuperview()
        stopDisplayLink()
    }
}
