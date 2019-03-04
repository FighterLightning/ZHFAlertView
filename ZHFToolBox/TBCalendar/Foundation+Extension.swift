//
//  Foundation+Extension.swift
//  SwiftTest
//
//  Created by 1111 on 2018/3/19.
//  Copyright © 2018年 xuejianfeng. All rights reserved.
//

import UIKit

extension String {
    /// 计算文本的高度
    func textHeight(fontSize: CGFloat, width: CGFloat) -> CGFloat {
        return self.boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: UIFont.systemFont(ofSize: fontSize)], context: nil).size.height
    }
}

extension UIView{
    ///点击事件
    func addTargetForTouch(target: Any, action: Selector){
        let singleTap = UITapGestureRecognizer.init(target: target, action: action)
        self.addGestureRecognizer(singleTap)
    }
    
    // 长按事件
    func addTargetForLongTouch(target: Any, action: Selector){
        let singleTap = UILongPressGestureRecognizer.init(target: target, action: action)
        singleTap.cancelsTouchesInView = false
        singleTap.minimumPressDuration = 0
        self.addGestureRecognizer(singleTap)
    }
    
    func fadeIn() {
        self.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
        self.alpha = 0;
        
        UIView.animate(withDuration: 0.35) {
            self.alpha = 1;
            self.transform = CGAffineTransform.init(scaleX: 1.0, y: 1.0)
        }
    }
    
    func fadeOut() {
        UIView.animate(withDuration: 0.35, animations: {
            self.transform = CGAffineTransform.init(scaleX: 1.3, y: 1.3)
            self.alpha = 0.0;
        }) { (finished) in
            if (finished) {
                self.removeFromSuperview()
            }
        }
    }
    
    func show() {
        let keywindow = UIApplication.shared.keyWindow
        keywindow?.addSubview(self)
    
        self.center = CGPoint.init(x: (keywindow?.bounds.size.width)! / 2, y: (keywindow?.bounds.size.height)! / 2)
        self.fadeIn()
    }
    
    func dismiss(){
        self.fadeOut()
    }
}

extension UILabel {
    class func createWithLable(text: String, textColor: UIColor, textFont: UIFont, aliment: NSTextAlignment) -> UILabel {
        
        let label = UILabel.init()
        label.text = text
        label.textColor = textColor
        label.textAlignment = aliment
        label.font = textFont
        
        return label
    }
}

extension Date {
    
    func getDateWithDay() -> Int {
        
        return NSCalendar.current.component(.day, from: self)
    }
    
    func getDateWithMonth() -> Int {
        return NSCalendar.current.component(.month, from: self)
    }
    
    func getDateWithYear() -> Int {
        return NSCalendar.current.component(.year, from: self)
    }
    
    /// 判断当前日期是否为今年
    func isThisYear() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let yearComps = calender.component(.year, from: self)
        // 获取现在的年份
        let nowComps = calender.component(.year, from: Date())
        
        return yearComps == nowComps
    }
    
    /// 是否是昨天
    func isYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        // 根据头条显示时间 ，我觉得可能有问题 如果comps.day == 0 显示相同，如果是 comps.day == 1 显示时间不同
        // 但是 comps.day == 1 才是昨天 comps.day == 2 是前天
        //        return comps.year == 0 && comps.month == 0 && comps.day == 1
        return comps.year == 0 && comps.month == 0 && comps.day == 0
    }
    
    /// 是否是前天
    func isBeforeYesterday() -> Bool {
        // 获取当前日历
        let calender = Calendar.current
        // 获取日期的年份
        let comps = calender.dateComponents([.year, .month, .day], from: self, to: Date())
        //
        //        return comps.year == 0 && comps.month == 0 && comps.day == 2
        return comps.year == 0 && comps.month == 0 && comps.day == 1
    }
    
    /// 判断是否是今天
    func isToday() -> Bool {
        // 日期格式化
        let formatter = DateFormatter()
        // 设置日期格式
        formatter.dateFormat = "yyyy-MM-dd"
        
        let dateStr = formatter.string(from: self)
        let nowStr = formatter.string(from: Date())
        return dateStr == nowStr
    }
    
}

/**
 *  扩展部分
 */
extension UIColor {
    
    /**
     *  16进制 转 RGBA
     */
    class func UIColorFromRGBA(rgb:Int, alpha:CGFloat) ->UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: alpha)
    }
    
    /**
     *  16进制 转 RGB
     */
    class func UIColorFromRGB(rgb:Int) ->UIColor {
        
        return UIColor(red: ((CGFloat)((rgb & 0xFF0000) >> 16)) / 255.0,
                       green: ((CGFloat)((rgb & 0xFF00) >> 8)) / 255.0,
                       blue: ((CGFloat)(rgb & 0xFF)) / 255.0,
                       alpha: 1.0)
    }
}

/**
 * 设置控件的阴影参数
 */

func setShadowForView(view: UIView, color: UIColor, shadowOffset: CGSize, shadowOpacity: CGFloat, shadowRadius: CGFloat){
    view.layer.shadowColor = color.cgColor//shadowColor阴影颜色
    view.layer.shadowOffset = shadowOffset//shadowOffset阴影偏移,x向右偏移4，y向下偏移4，默认(0, -3),这个跟shadowRadius配合使用
    view.layer.shadowOpacity = Float(shadowOpacity)//阴影透明度，默认0
    view.layer.shadowRadius = shadowRadius//阴影半径，默认3
}

func compareDate(oneDay: NSDate, anotherDay: NSDate) -> Int{
    
    let dateFormatter = DateFormatter.init()
    dateFormatter.dateFormat = "yyyy-MM"
    
    let dateA = dateFormatter.date(from: dateFormatter.string(from: oneDay as Date))
    let dateB = dateFormatter.date(from: dateFormatter.string(from: anotherDay as Date))
    
    let result = dateA?.compare(dateB!)
    if (result!.rawValue == ComparisonResult.orderedDescending.rawValue) {
        //NSLog(@"Date1  is in the future");
        return 1;
    }
    else if (result!.rawValue == ComparisonResult.orderedAscending.rawValue){
        //NSLog(@"Date1 is in the past");
        return -1;
    }
    //NSLog(@"Both dates are the same");
    return 0;
}

func getMonthEnd(date: NSDate) -> NSDate {
    let format = DateFormatter.init()
    format.dateFormat = "yyyy-MM"
    let newDate: Date = format.date(from: format.string(from: date as Date))!
    var interval: Double = 0
    var beginDate: Date = Date()
    var endDate: Date = Date()
    var calendar = NSCalendar.current
    calendar.firstWeekday = 2 //设定周一为周首日
    let ok: Bool = calendar.dateInterval(of: .month, start: &beginDate, interval: &interval, for: newDate)
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = beginDate.addingTimeInterval(interval - 1)
    }else {
        return Date.init() as NSDate;
    }
    let myDateFormatter = DateFormatter.init()
    myDateFormatter.dateFormat = "yyyy-MM-dd"
    endDate = myDateFormatter.date(from: myDateFormatter.string(from: endDate))!
    return endDate as NSDate;
}

func getMonthBegin(date: NSDate) -> NSDate {
    let format = DateFormatter.init()
    format.dateFormat = "yyyy-MM"
    let newDate: Date = format.date(from: format.string(from: date as Date))!
    var interval: Double = 0
    var beginDate: Date = Date()
    var endDate: Date = Date()
    var calendar = NSCalendar.current
    calendar.firstWeekday = 2 //设定周一为周首日
    
    let ok: Bool = calendar.dateInterval(of: .month, start: &beginDate, interval: &interval, for: newDate)
    //分别修改为 NSDayCalendarUnit NSWeekCalendarUnit NSYearCalendarUnit
    if (ok) {
        endDate = beginDate.addingTimeInterval(interval - 1)
    }else {
        return Date.init() as NSDate;
    }
    
    let myDateFormatter = DateFormatter.init()
    myDateFormatter.dateFormat = "yyyy-MM-dd"
    endDate = Date.init(timeInterval: -86400, since: beginDate)
    
    return endDate as NSDate;
}
