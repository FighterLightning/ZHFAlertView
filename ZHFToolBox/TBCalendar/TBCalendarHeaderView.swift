//
//  TBCalendarHeaderView.swift
//  SwiftTest
//
//  Created by 1111 on 2018/4/2.
//  Copyright © 2018年 xuejianfeng. All rights reserved.
//

import UIKit
class TBCalendarHeaderView: UIView {
    
    typealias click = (NSDate) -> Void
    public var previousMonth: ((_ date: NSDate) -> Void)?
    public var nextMonth: ((_ date: NSDate) -> Void)?
    public var monthDate: NSDate{
        get{
            return remberMonthDate
        }
        
        set{
            remberMonthDate = newValue
            self.setMonthDate(date: newValue)
        }
    }
    private var remberMonthDate = NSDate()
    private var headType: TBCalendarHeaderViewType
    private var style: TBCalendarAppearStyle
    lazy var topView: UIView = getTopView()
    lazy var dateLable: UILabel = getDateLable()
    lazy var previousButton: UIButton = getPreviousButton()
    lazy var nextButton: UIButton = getNextButton()
    lazy var bottomView: UIView = UIView.init()
    lazy var weekdayLabels: [UILabel] = [UILabel]()
    lazy var lineView: UIView = UIView.init()
    
    init(type: TBCalendarHeaderViewType, style: TBCalendarAppearStyle, frame: CGRect) {
        self.headType = type
        self.style = style
        super.init(frame: frame)
        self.setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.topView)
        self.addSubview(self.bottomView)
        self.addSubview(self.lineView)
        self.topView.addSubview(self.dateLable)
        
        switch self.headType {
        case TBCalendarHeaderViewType.leftDate:
            break;
        case TBCalendarHeaderViewType.centerDate:
            self.topView.addSubview(self.previousButton)
            self.topView.addSubview(self.nextButton)
            self.previousButton.isHidden = false
            self.nextButton.isHidden = false
            break;
        }
        
        let weekDateDays: [String] = self.style.weekDateDays
        
        for _ in weekDateDays
        {
            let label = UILabel.init(frame: CGRect.zero)
            label.textAlignment = .center
            self.bottomView.addSubview(label)
            self.weekdayLabels.append(label)
        }
        
        self.initValidSettingData()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        let selfWidth: CGFloat = self.bounds.size.width
        
        if self.style.isNeedCustomHeihgt! {
            self.topView.frame = CGRect.init(x: 0, y:0, width: selfWidth, height: self.style.headerViewDateHeight!)
            self.lineView.frame = CGRect.init(x: 0, y: self.topView.frame.maxY, width: selfWidth, height: self.style.headerViewLineHeight!)
            self.bottomView.frame = CGRect.init(x: 0, y: self.lineView.frame.maxY, width: selfWidth, height: self.style.headerViewWeekHeight!)
            
            switch (self.headType)
            {
            case .leftDate:
                
                self.dateLable.frame = CGRect.init(x: 0, y: 0, width: selfWidth, height: self.topView.frame.size.height);
                self.dateLable.textAlignment = .center;
                
                break;
            case .centerDate:
                
                let image = UIImage.init(named: "icon_switch")
                self.dateLable.frame = CGRect.init(x: selfWidth * 0.5 - 60, y: 0, width: 120, height: self.topView.frame.size.height);
                
                self.previousButton.frame = CGRect.init(x: 30, y: 0, width: (image?.size.width)! + 20, height: self.topView.frame.size.height);
                self.nextButton.frame = CGRect.init(x: selfWidth - (image?.size.width)! - 50, y: 0, width: (image?.size.width)! + 20, height: self.topView.frame.size.height);
                break;
            }
            
            let weekdayWidth = self.bottomView.bounds.size.width / CGFloat(self.style.weekDateDays.count)
            let weekdayHeight = self.bottomView.bounds.size.height;
            
            
            for (index, value) in self.weekdayLabels.enumerated() {
                
                value.frame = CGRect.init(x: CGFloat(index) * weekdayWidth, y: 0, width: weekdayWidth, height: weekdayHeight)
            }
        }
        else
        {
            //计算高度
        }
    }
    
    func initValidSettingData(){
        self.dateLable.font = self.style.headerViewDateFont;
        self.dateLable.textColor = self.style.headerViewDateColor;
        
        for item: UILabel in self.weekdayLabels {
            item.font = self.style.headerViewWeekFont
            item.textColor = self.style.headerViewWeekColor
        }
        
        for (index, value) in self.weekdayLabels.enumerated() {
            
            if index < self.style.weekDateDays.count {
                value.text = self.style.weekDateDays[index];
            }
        }
    }
    
    func getTopView() -> UIView {
        let topView = UIView.init()
        topView.backgroundColor = UIColor.white
        return topView
    }
    
    func getDateLable() -> UILabel {
        let dateLabel = UILabel.init()
        dateLabel.numberOfLines = 2
        dateLabel.textAlignment = .center
        return dateLabel
    }
    
    func getPreviousButton() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_switch"), for: .normal)
        btn.addTarget(self, action: #selector(previousButtonClick), for: .touchUpInside)
        return btn
    }
    
    func getNextButton() -> UIButton {
        let btn = UIButton.init(type: .custom)
        btn.setImage(UIImage.init(named: "icon_switch_r"), for: .normal)
        btn.addTarget(self, action: #selector(nextButtonClick), for: .touchUpInside)
        return btn
    }
    
    @objc func previousButtonClick() {
        self.monthDate = self.lastMonth(date: self.monthDate)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHANGE_SELECT_DATE), object: monthDate)
        if self.previousMonth != nil {
            self.previousMonth!(self.monthDate)
        }
    }
    
    @objc func nextButtonClick() {
        self.monthDate = self.nextMonth(date: self.monthDate)
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: CHANGE_SELECT_DATE), object: monthDate)
        if self.nextMonth != nil {
            self.nextMonth!(self.monthDate)
        }
    }
    
    func setMonthDate(date: NSDate){
        //如果点击的日期超过当前日期 不让其点击 || [TBUtils compareOneDay:monthDate withAnotherDay:[NSDate dateWithString:@"2017-03" format:@"yyyy-MM"]] == -1
        if compareDate(oneDay: monthDate, anotherDay: Date() as NSDate) == 1 {
            return;
        }
        
        self.nextButton.alpha = 1;
        self.previousButton.alpha = 1;
        
        let monthStr: String = self.month(date: date)
        let yearStr: String = "\(self.year(year: date))."
        self.dateLable.text = yearStr + monthStr
        //self.dateLable.attributedText = self.createAttrStr(monthStr: monthStr, yearStr: yearStr)
        
        var date = getMonthEnd(date: date)
        
        let myDateFormatter = DateFormatter.init()
        myDateFormatter.dateFormat = "yyyy-MM-dd"
        let endDate = Date.init(timeInterval: 86400, since: date as Date)
        
        
        if (compareDate(oneDay: endDate as NSDate, anotherDay: NSDate()) == 1) {
            self.nextButton.alpha = 0.5;
            self.nextButton.isEnabled = false;
        }
        else
        {
            self.nextButton.alpha = 1;
            self.nextButton.isEnabled = true;
        }
        
        date = getMonthBegin(date: date)
        let PreDate = Date.init(timeInterval: -86400, since: date as Date)
        
        let dateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM"
        
        if compareDate(oneDay: PreDate as NSDate, anotherDay: dateFormatter.date(from: "2017-03")! as NSDate) == -1 {
            self.previousButton.alpha = 0.5;
            self.previousButton.isEnabled = false;
        }
        else
        {
            self.previousButton.alpha = 1;
            self.previousButton.isEnabled = true;
        }
    }
    
    func nextMonth(date: NSDate) -> NSDate{
        
        let dateComponents = NSDateComponents.init()
        let currentMonth = self.month(date: date)
        
        if(currentMonth == "12")
        {
            dateComponents.year = +1;
            dateComponents.month = -11;
        }
        else
        {
            dateComponents.month = +1;
        }
        
        return NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: date as Date)! as NSDate
    }
    
    func lastMonth(date: NSDate) -> NSDate{
        let dateComponents = NSDateComponents.init()
        let currentMonth = self.month(date: date)
        if(currentMonth == "01")
        {
            dateComponents.year = -1;
            dateComponents.month = +11;
        }
        else
        {
            dateComponents.month = -1;
        }
        
        return NSCalendar.current.date(byAdding: dateComponents as DateComponents, to: date as Date)! as NSDate
    }
    
    func month(date: NSDate) -> String {
        var str = ""
        if (NSCalendar.current.component(.month, from: date as Date) < 10) {
            str = "0" + "\(NSCalendar.current.component(.month, from: date as Date))"
        }
        else
        {
            str = "\(NSCalendar.current.component(.month, from: date as Date))"
        }
        
        return str;
    }
    
    func year(year: NSDate) -> Int{
        return NSCalendar.current.component(.year, from: year as Date)
    }
    
    func createAttrStr(monthStr: String, yearStr: String) -> NSMutableAttributedString{
        let monthDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 24), NSAttributedStringKey.foregroundColor:ZHFColor.zhf_color(withHex: 0x4F505F)]
        let yearDict = [NSAttributedStringKey.font: UIFont.systemFont(ofSize: 14), NSAttributedStringKey.foregroundColor:ZHFColor.zhf_color(withHex: 0x999999)]
        
        let str: String = monthStr + yearStr
        
        let mutableAtt: NSMutableAttributedString = NSMutableAttributedString.init(string: str, attributes: monthDict)
        mutableAtt.addAttributes(yearDict, range: NSRange.init(location: monthStr.count, length: yearStr.count))
        
        return mutableAtt
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
