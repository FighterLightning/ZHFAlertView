//
//  PopTextView.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2018/5/10.
//  Copyright © 2018年 张海峰. All rights reserved.
//

import UIKit

class PopTextView: PopSmallChangeBigFatherView {
    let titleHeight: CGFloat = 75
    var placeHoldLable: UILabel = UILabel()
    var textView:UITextView = UITextView()
    var textStr : String = "请输入内容"
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
            self.addWhiteVieSubView1()
        }
    }
    //放一个输入框
    func addWhiteVieSubView1(){
        let titleLabel:UILabel = UILabel.init(frame: CGRect.init(x: 0, y: 0, width: self.WhiteView.frame.width, height: titleHeight))
        titleLabel.text = "修改cell内容"
        titleLabel.textAlignment = NSTextAlignment.center
        titleLabel.font = UIFont.systemFont(ofSize: 25, weight: UIFont.Weight.bold)
        titleLabel.textColor = ZHFColor.zhf_randomColor()
        self.WhiteView.addSubview(titleLabel)
        
        //占位Label的位置自行调整
        placeHoldLable = UILabel.init(frame: CGRect.init(x: 25, y: titleHeight + 8, width: self.WhiteView.frame.width - 50, height: 20))
        placeHoldLable.text = textStr
        placeHoldLable.textColor = ZHFColor.black
        placeHoldLable.font = UIFont.systemFont(ofSize: 15)//大小和textView字体大小一致
        self.WhiteView.addSubview(placeHoldLable)
        
        textView = UITextView.init(frame: CGRect.init(x: 20, y: titleHeight, width: self.WhiteView.frame.width - 40, height: self.WhiteView.frame.height - titleHeight - 80))
        textView.layer.masksToBounds = true
        textView.layer.borderColor = ZHFColor.zhfcc_lineColor.cgColor
        textView.layer.borderWidth = 1
        textView.layer.cornerRadius = 5
        textView.backgroundColor = UIColor.white
        textView.alpha = 0.5
        textView.delegate = self
        textView.returnKeyType = UIReturnKeyType.done
        textView.font = UIFont.systemFont(ofSize: 15)
        self.WhiteView.addSubview(textView)
        
        oneBtn.frame = CGRect.init(x:20, y: self.WhiteView.frame.height - 55, width: (self.WhiteView.frame.width - 50)/2, height: 40)
        oneBtn.layer.masksToBounds = true
        oneBtn.layer.cornerRadius = 5
        oneBtn.backgroundColor = ZHFColor.orange
        oneBtn.setTitle("确定", for: UIControlState.normal)
        oneBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        oneBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.WhiteView.addSubview(oneBtn)
        
        otherBtn.frame = CGRect.init(x:oneBtn.frame.maxX + 10, y: self.WhiteView.frame.height - 55, width: (self.WhiteView.frame.width - 50)/2, height: 40)
        otherBtn.layer.masksToBounds = true
        otherBtn.layer.cornerRadius = 5
        otherBtn.backgroundColor = ZHFColor.orange
        otherBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        otherBtn.setTitle("取消", for: UIControlState.normal)
        otherBtn.setTitleColor(UIColor.white, for: UIControlState.normal)
        self.WhiteView.addSubview(otherBtn)
    }
}
extension PopTextView:UITextViewDelegate{
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.endEditing(true);
        textView.resignFirstResponder;
    }
    func textViewDidChange(_ textView: UITextView) {
        if textView.text == ""{
            placeHoldLable.isHidden = false
            textView.alpha = 0.5
        }
        else{
            placeHoldLable.isHidden = true
            textView.alpha = 1
        }
    }
    //监听return 按钮被点击
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if text == "\n" {
            self.endEditing(true);
            textView.resignFirstResponder;
            return false;
        }
        return true;
    }
}
