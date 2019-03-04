//
//  TBCalendarDateCell.swift
//  SwiftTest
//
//  Created by 1111 on 2018/4/9.
//  Copyright © 2018年 xuejianfeng. All rights reserved.
//

import UIKit

class TBCalendarDateCell: UICollectionViewCell {
    public var style: TBCalendarAppearStyle{
        get{
            return TBCalendarAppearStyle.init()
        }
        
        set{
            self.setStyle(style: newValue)
        }
    }
    lazy var dateLabel: UILabel = getDateLabel()
    lazy var dotView: UIView = getDotView()
    public var isToday: Bool?
    
    lazy var descLabel: UILabel = getDescLabel()
    private var dateLableHeight: CGFloat = 0
    private var descLabelHeiht: CGFloat = 0
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        self.contentView.addSubview(dateLabel)
        self.contentView.addSubview(descLabel)
        self.dateLabel.addSubview(dotView)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.size.width
        let height = self.bounds.size.height
        if(self.dateLableHeight > 0)
        {
            self.dateLabel.center = CGPoint.init(x: width * 0.5, y: height * 0.5)
            self.dateLabel.bounds = CGRect.init(x: 0, y: 0, width: 34, height: 34)
            
            self.dotView.center.x = self.dateLabel.frame.width * 0.5;
            self.dotView.center.y = self.dateLabel.frame.height * 0.5 + 10;
            self.dotView.bounds = CGRect.init(x: 0, y: 0, width: 4, height: 4)
        }
        if(self.descLabelHeiht > 0)
        {
            self.descLabel.center = CGPoint.init(x: width*0.5, y: height*0.5 + self.descLabelHeiht*0.5+(self.style.dateTitleDescOffset?.vertical)! * 0.5);
            self.descLabel.bounds = CGRect.init(x: 0, y: 0, width: Int(width), height: Int(self.descLabelHeiht) - 2)
        }
    }
    
    func setStyle(style: TBCalendarAppearStyle) {
        
        let str = "1"
        self.dateLableHeight = str.textHeight(fontSize: (style.dateTittleFont?.pointSize)!, width: 20)
        self.descLabelHeiht = str.textHeight(fontSize: (style.dateDescFont?.pointSize)!, width: 20)
        self.dateLabel.font = style.dateTittleFont;
        self.dateLabel.textColor = self.isSelected ? style.dateTittleSelectColor:style.dateTittleUnselectColor;
        self.descLabel.font = style.dateDescFont;
        self.descLabel.textColor = self.isSelected ? style.dateDescSelectColor:style.dateDescUnselectColor;
    }
    // 暴露出来的方法，供外界使用
    func reloadCellData(title: String) {
        self.dateLabel.text = title.count > 0 ? title : ""
    }
    
    func reloadCellData(subtitle: String) {
        self.descLabel.text = subtitle.count > 0 ? subtitle : ""
    }
    
    func reloadCellData(title: String, subTitle: String) {
        reloadCellData(title: title)
        reloadCellData(subtitle: subTitle)
    }
    
    func updateCellDotView(status: String) {
        // 旷工0  迟到1 早退2  异常3  人工处理过异常4  ERP处理过异常5  法定节假日6  休息7 正常8
        // 蓝色8  橙色0，1，2，3，9  剩下状态为没有颜色
        
        let statusToInt = Int(status)
        if (status.count > 0) {
            if (statusToInt == 8) { //正常签到或者ERP有补签卡都是正常
                self.dotView.backgroundColor = UIColor.UIColorFromRGB(rgb: 0x29B6F6)
            }
            else if (statusToInt == 0 || statusToInt == 1 || statusToInt == 2 || statusToInt == 3 || statusToInt == 9)
            {
                self.dotView.backgroundColor = UIColor.UIColorFromRGB(rgb: 0xF48900)
            }
            else
            {
                self.dotView.backgroundColor = UIColor.clear
            }
        }
        else
        {
            // 现在后台返回30条数据，然后status为null然后doubleValue后为0，所以会显示为旷工颜色，所以要做判空处理
            self.dotView.backgroundColor = UIColor.clear
        }
    }
    
    func updateCellSelectBackgroundColor() {
        self.dateLabel.backgroundColor = self.isSelected ? UIColor.UIColorFromRGB(rgb: 0xEEEEEE) : UIColor.UIColorFromRGB(rgb: 0xffffff);
    }
    
    func updateCellSelectTitleColor() {
        //self.dateLabel.textColor = self.isSelected ? self.style.dateTittleSelectColor:self.style.dateTittleUnselectColor;
    }
    
    func updateCellSelectSubtitleColor() {
        //self.descLabel.textColor = self.isSelected ? self.style.dateDescSelectColor:self.style.dateDescUnselectColor;
    }
    
    func updateCellSelectCellColor() {
        updateCellSelectCellColor(animation: false)
    }
    
    func updateCellSelectCellColor(animation: Bool) {
        
        updateCellSelectTitleColor()
        updateCellSelectSubtitleColor()
        updateCellSelectBackgroundColor()
    }
    
    // lazy 相关函数
    func getDateLabel() -> UILabel {
        let dateLabel = UILabel.init()
        dateLabel.layer.cornerRadius = 17
        dateLabel.layer.masksToBounds = true
        dateLabel.textAlignment = .center
        return dateLabel
    }
    
    func getDotView() -> UIView {
        let dotView = UIView.init()
        dotView.layer.cornerRadius = 2;
        dotView.layer.masksToBounds = true
        dotView.backgroundColor = UIColor.clear
        return dotView
    }
    
    func getDescLabel() -> UILabel {
        let descLabel = UILabel.init()
        descLabel.textAlignment = .center
        return descLabel
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
