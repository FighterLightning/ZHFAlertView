//
//  PopButtonView.swift
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
/*弹出一个单选框*/
import UIKit
protocol PopRadioButtonViewDelegate {
    func selectBtnMessage(content: String)
}
class PopRadioButtonView: PopSmallChangeBigFatherView {
    var delegate:PopRadioButtonViewDelegate?
    let titleHeight: CGFloat = 75
    var contentArr : [String] = [String]()
    var radioBtn:UIButton = UIButton()
    var trueBtn:UIButton = UIButton()
    override func addAnimate() {
        UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        
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
        titleLabel.text = "请选择一个菜"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        titleLabel.textColor = ZHFColor.zhf_randomColor()
        self.WhiteView.addSubview(titleLabel)
        //添加按钮
        var x: CGFloat = 25
        var y: CGFloat = titleHeight
        for i in 0 ..< contentArr.count{
            let name: String = contentArr[i]
            let nameLenth : CGFloat = CGFloat(name.count * 25)
            let btn : UIButton = UIButton.init(type: UIButtonType.custom)
            if x + nameLenth > ScreenWidth - 50{
                x = 25
                y = y + 40
            }
            btn.frame = CGRect.init(x: x, y: y - 10, width: nameLenth, height: 30)
            btn.layer.masksToBounds = true
            btn.layer.cornerRadius = 15
            btn.layer.borderColor = ZHFColor.zhf88_contentTextColor.cgColor
            btn.layer.borderWidth = 0.5
            btn.titleLabel?.font = UIFont.systemFont(ofSize: 13, weight: UIFont.Weight.ultraLight)
            btn.setTitle(name, for: UIControlState.normal)
            btn.setTitleColor(ZHFColor.zhf88_contentTextColor, for: UIControlState.normal)
            btn.setTitle(name, for: UIControlState.selected)
            btn.setTitleColor(ZHFColor.zhf_selectColor, for: UIControlState.selected)
            x = x + nameLenth + 15
            btn.tag = i
            btn.isSelected = false
            btn.addTarget(self, action: #selector(btnClick), for: UIControlEvents.touchUpInside)
            self.WhiteView.addSubview(btn)
        }
        trueBtn = UIButton.init(type: UIButtonType.custom)
        trueBtn.frame = CGRect.init(x:25, y: self.WhiteView.frame.height - 55, width: self.WhiteView.frame.width - 50, height: 40)
        trueBtn.layer.masksToBounds = true
        trueBtn.layer.cornerRadius = 5
        trueBtn.backgroundColor = ZHFColor.orange
        trueBtn.setTitle("确定", for: UIControlState.normal)
        trueBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        trueBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        trueBtn.addTarget(self, action: #selector(trueBtnClick), for: UIControlEvents.touchUpInside)
        self.WhiteView.addSubview(trueBtn)
    }
    @objc func btnClick(btn:UIButton){
        radioBtn.isSelected = false
        radioBtn.layer.borderColor = ZHFColor.zhf88_contentTextColor.cgColor
        btn.layer.borderColor = ZHFColor.zhf_selectColor.cgColor
        btn.isSelected = true
        radioBtn = btn
    }
    @objc func trueBtnClick(btn:UIButton){
        self.delegate?.selectBtnMessage(content: (radioBtn.titleLabel?.text)!)
    }
}
