//
//  PopTopOrBottomOutFatherView.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2018/5/10.
//  Copyright © 2018年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
    https://github.com/FighterLightning/ZHFToolBox.git
https://www.jianshu.com/p/88420bc4d32d
 */
/*从底部或顶部弹出卡片，带回弹*/
import UIKit

class PopTopOrBottomOutView: UIView {
    var cancelBtn :UIButton = UIButton()
    var outerImage:UIImageView = UIImageView()
    var whiteView :UIView = UIView()
    //背景区域的颜色和透明度
    var backgroundColor1:UIColor  = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0.4)
    var topOrBottomViewStartFrame = CGRect.init(x: 25, y: ScreenHeight, width: ScreenWidth - 50, height: 500)
    //初始化视图
    func initPopBackGroundView() -> UIView {
        self.frame = CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight)
        self.backgroundColor = backgroundColor1
        self.isHidden = true
        //为落下的视图添加背景图
        let innerImage:UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: ScreenHeight - 210, width: ScreenWidth, height: 210))
        innerImage.image = UIImage.init(named: "inner_layerImage")
        self.addSubview(innerImage)
        
        outerImage = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: ScreenWidth, height: ScreenHeight))
        outerImage.image = UIImage.init(named: "outer_layerImage")
        self.addSubview(outerImage)
        return self
    }
    //为白色视图添加子视图
    func addWhiteViewSubView() {
        let imageView: UIImageView = UIImageView.init(frame: CGRect.init(x: 0, y: 0, width: whiteView.frame.size.width, height: whiteView.frame.size.height))
        imageView.layer.masksToBounds = true
        imageView.contentMode = UIViewContentMode.scaleAspectFill
        imageView.image = UIImage.init(named: "bmw_image")
        whiteView.addSubview(imageView)
        let titleLabel: UILabel = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: whiteView.frame.size.width - 10, height: 50))
        titleLabel.textColor = UIColor.white
        titleLabel.font = UIFont.systemFont(ofSize: 20)
        titleLabel.text = "恭喜你获得一台 “别摸我”！！！！"
        imageView.addSubview(titleLabel)
        let contentLabel: UILabel = UILabel.init(frame: CGRect.init(x: 20, y: titleLabel.frame.maxY, width: whiteView.frame.size.width - 40, height: 70))
        contentLabel.textColor = UIColor.orange
        contentLabel.font = UIFont.systemFont(ofSize: 15)
        contentLabel.numberOfLines = 0
        contentLabel.textAlignment = NSTextAlignment.right
        contentLabel.text = "别摸我是一款超级牛逼的车，据说上天都不用梯子，全靠空气动力支撑,能上天，能下海，我只不过是瞎说的。"
        imageView.addSubview(contentLabel)
    }
     //从下面弹出来
    func addAnimateFromBottom() {
    UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        self.cancelBtn.isHidden = true
        self.whiteView.frame = topOrBottomViewStartFrame
        self.whiteView.backgroundColor = ZHFColor.zhf_colorAlpha(withHex: 0xffffff, alpha: 0)
        self.addSubview(self.whiteView)
        addWhiteViewSubView()
        
        self.cancelBtn = UIButton.init(type: UIButtonType.custom)
        UIView.animate(withDuration:0.5, animations: {
            self.whiteView.frame.origin.y = ScreenHeight - 670
            self.bringSubview(toFront:self.outerImage)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.whiteView.frame.origin.y = ScreenHeight - 530
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.whiteView.frame.origin.y = ScreenHeight - 570
                }, completion: { (_) in
                    self.cancelBtn.isHidden = false
                    self.cancelBtn.frame = CGRect.init(x:self.frame.maxX - 60, y:ScreenHeight - 610, width: 40, height: 40)
                    self.cancelBtn.tag = 1
                    self.cancelBtn.setImage(UIImage.init(named: "cancel_white"), for: UIControlState.normal)
                    self.cancelBtn.addTarget(self, action: #selector(self.cancelBtnClickBottom), for: UIControlEvents.touchUpInside)
                    self.addSubview(self.cancelBtn)
                })
            })
        }
    }
    //从上面弹出来
    func addAnimateFromTop() {
    UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        self.cancelBtn.isHidden = true
        self.whiteView.frame = topOrBottomViewStartFrame
        self.whiteView.backgroundColor = ZHFColor.zhf_colorAlpha(withHex: 0xffffff, alpha: 0.5)
        self.addSubview(self.whiteView)
        addWhiteViewSubView()
        
        self.cancelBtn = UIButton.init(type: UIButtonType.custom)
        UIView.animate(withDuration:0.5, animations: {
            self.whiteView.frame.origin.y = ScreenHeight - 470
            self.bringSubview(toFront:self.outerImage)
        }) { (_) in
            UIView.animate(withDuration: 0.2, animations: {
                self.whiteView.frame.origin.y = ScreenHeight - 610
            }, completion: { (_) in
                UIView.animate(withDuration: 0.2, animations: {
                    self.whiteView.frame.origin.y = ScreenHeight - 570
                }, completion: { (_) in
                    self.cancelBtn.isHidden = false
                    self.cancelBtn.frame = CGRect.init(x:self.frame.maxX - 60, y:ScreenHeight - 610, width: 40, height: 40)
                    self.cancelBtn.setImage(UIImage.init(named: "cancel_white"), for: UIControlState.normal)
                    self.cancelBtn.addTarget(self, action: #selector(self.cancelBtnClickTop), for: UIControlEvents.touchUpInside)
                    self.addSubview(self.cancelBtn)
                })
            })
        }
    }
    @objc func cancelBtnClickTop(btn:UIButton){
        self.cancelBtn.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
             self.whiteView.frame.origin.y = -ScreenHeight
        }) { (_) in
             self.removeFromSuperview()
        }
    }
    @objc func cancelBtnClickBottom(btn:UIButton){
        self.cancelBtn.isHidden = true
        UIView.animate(withDuration: 0.5, animations: {
            self.whiteView.frame.origin.y = ScreenHeight
        }) { (_) in
            self.removeFromSuperview()
        }
    }
}
