//
//  PopImageView.swift
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
/*弹出一个带图片的提示框*/
import UIKit

class PopImageView: PopSmallChangeBigFatherView {
    let titleHeight: CGFloat = 75
    var oneBtn:UIButton = UIButton()
    var otherBtn:UIButton = UIButton()
    override func addAnimate() {
    UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        //按钮不要在动画完成后初始化（否则按钮没点击效果）
        oneBtn = UIButton.init(type: UIButtonType.custom)
        otherBtn = UIButton.init(type: UIButtonType.custom)
        UIView.animate(withDuration:TimeInterval(defaultTime), animations: {
            self.WhiteView.frame = self.whiteViewEndFrame
        }) { (_) in
            self.cancelBtn.frame.origin.y = self.WhiteView.frame.maxY +  20
            self.cancelBtn.isHidden = false
            self.addWhiteVieSubView1()
            }
        }
    //放一张展示图片
    func addWhiteVieSubView1(){
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.WhiteView.frame.width, height: titleHeight))
        titleLabel.text = "带图片的弹框"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        titleLabel.textColor = ZHFColor.zhf_randomColor()
        self.WhiteView.addSubview(titleLabel)
        let imageView :UIImageView = UIImageView.init(frame: CGRect.init(x: 20, y: titleHeight, width: self.WhiteView.frame.width - 40, height: self.WhiteView.frame.height - titleHeight - 80))
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = UIImage.init(named: "test1")
        self.WhiteView.addSubview(imageView)
       
        oneBtn.frame = CGRect.init(x:20, y: self.WhiteView.frame.height - 55, width: (self.WhiteView.frame.width - 50)/2, height: 40)
        oneBtn.layer.masksToBounds = true
        oneBtn.layer.cornerRadius = 5
        oneBtn.backgroundColor = ZHFColor.zhf_selectColor
        oneBtn.setTitle("按钮One", for: UIControlState.normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        oneBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.WhiteView.addSubview(oneBtn)
       
        otherBtn.frame = CGRect.init(x:oneBtn.frame.maxX + 10, y: self.WhiteView.frame.height - 55, width: (self.WhiteView.frame.width - 50)/2, height: 40)
        otherBtn.layer.masksToBounds = true
        otherBtn.layer.cornerRadius = 5
        otherBtn.backgroundColor = ZHFColor.zhf_selectColor
        otherBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        otherBtn.setTitle("按钮Two", for: UIControlState.normal)
        otherBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.WhiteView.addSubview(otherBtn)
    }
}
