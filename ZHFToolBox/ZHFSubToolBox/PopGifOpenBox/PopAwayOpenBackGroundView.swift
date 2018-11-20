//
//  PopAwayOpenBackGroundView.swift
//  AmazedBox
//
//  Created by 张海峰 on 2018/4/10.
//  Copyright © 2018年 张海峰. All rights reserved.
// 2.Gif播放一半，弹出自定义动画，循环播放Gif任意区间帧动画。
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
 相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
 https://github.com/FighterLightning/ZHFToolBox.git
 https://www.jianshu.com/p/88420bc4d32d
 */
import UIKit
import ImageIO
class PopAwayOpenBackGroundView: UIView {
   
    var topView1 :UIImageView =  UIImageView()
    lazy var frames: NSMutableArray = NSMutableArray()
    lazy var framesLast: NSMutableArray = NSMutableArray()
    //初始化视图
    func initPopAwayOpenBackGroundView() -> UIView {
        self.backgroundColor = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        let fileUrl :NSURL = Bundle.main.url(forResource:  "open_boxA", withExtension: "gif")! as NSURL //加载GIF图片
        let gifSource : CGImageSource =  CGImageSourceCreateWithURL(fileUrl, nil)!  //将GIF图片转换成对应的图片源
        let frameCout : NSInteger = CGImageSourceGetCount(gifSource)//获取其中图片源个数，即由多少帧图片组成
        self.frames = NSMutableArray.init()//定义数组存储拆分出来的图片
        self.framesLast = NSMutableArray.init()//定义数组存储拆分出来的图片
        for i in 0 ..< frameCout{
            let imageRef :CGImage = CGImageSourceCreateImageAtIndex(gifSource, i, nil)!//从GIF图片中取出源图片
            let image : UIImage = UIImage.init(cgImage: imageRef)
            self.frames.add(image)
            if i > frameCout*2/3{
                //截取整个gif图的后面1/3 寸进数组以达到循环播放后半部分
              self.framesLast.add(image)
            }
        }
        topView1 = UIImageView.init(frame: CGRect.init(x: ScreenWidth/2 - 10, y: ScreenHeight/2 - 10, width: 20, height: 20))
        topView1.image = self.frames.firstObject as? UIImage
        topView1.isUserInteractionEnabled = true
        topView1.contentMode = UIViewContentMode.scaleAspectFill
        self.addSubview(topView1)
        return self
    }
    func addAnimate() {
    UIApplication.shared.keyWindow?.addSubview(self.initPopAwayOpenBackGroundView())
        UIView.animate(withDuration:0.2, animations: {
            self.topView1.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        }) { (_) in
            let AnimationNtimer : NSInteger = 3
            self.topView1.animationImages = self.frames as? [UIImage]//将图片数组加入UIImageView动画数组中
            self.topView1.isUserInteractionEnabled = true
            self.topView1.contentMode = UIViewContentMode.scaleAspectFill
            self.topView1.animationDuration = TimeInterval(AnimationNtimer); //每次动画时长
            self.topView1.startAnimating()
            Timer.scheduledTimer(timeInterval: TimeInterval(AnimationNtimer), target: self, selector: #selector(self.ArrowAnimationPlay), userInfo: nil, repeats: false)
        }
    }
    //播放结束循环播放GIF图的后面1/3部分
    @objc func ArrowAnimationPlay(){
         self.topView1.animationImages = self.framesLast as? [UIImage]//将图片数组加入UIImageView动画数组中
         self.topView1.animationDuration = 1
         self.topView1.startAnimating()
    }
}
