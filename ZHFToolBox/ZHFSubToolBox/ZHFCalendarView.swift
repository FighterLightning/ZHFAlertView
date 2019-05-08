//
//  ZHFCalendarView.swift
//  日历弹窗
//
//  Created by 张海峰 on 2019/4/5.
//  Copyright © 2019年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中集成一个日历弹窗，用自己可想到的最少代码实现日历弹窗
 当然这个弹窗也是我自定义弹窗的极小部分，对Swift弹窗感兴趣的帅哥美女，可戳下面链接
 https://github.com/FighterLightning/ZHFToolBox.git
 */
import UIKit

class ZHFCalendarView: UpDownView {
    var pointColor: UIColor = ZHFColor.zhf_color(withHex: 0x42D2BE)
    //声明闭包
    typealias clickBtnClosure = (String?) -> Void
    //把申明的闭包设置成属性
    var clickClosure: clickBtnClosure?
    //为闭包设置调用函数
    func clickValueClosure(closure:clickBtnClosure?){
        clickClosure = closure
    }
    var bigGreenPoints:[NSInteger] = [5,7,10]
    var smallGreenPoints:[NSInteger] = [3,7,8,10,25]
    var nowMonth: NSInteger = 1 //现在时间
    var nowYear: NSInteger = 2019 //现在时间
    var monthNumber: NSInteger = 1  // 可变化的时间
    var yearNumber: NSInteger = 2019 // 可变化的时间
    let topMargin :CGFloat = 10;
    let leftMargin :CGFloat = 25;//靠边数字距离左边和右边距离
    let bothMargin :CGFloat = 10;//两个数字间距离
    let viewWH :CGFloat = (ScreenWidth - 25*2 - 10*6)/7; //每个数字的宽高
    var titleLabel1: UILabel = UILabel()
    var rightBtn:UIButton = UIButton()
    var calendarView: UIView  = UIView()
    override func addAnimate() {
        UIApplication.shared.keyWindow?.addSubview(self.initPopBackGroundView())
        self.isHidden = false
        //按钮不要在动画完成后初始化（否则按钮没点击效果）
        UIView.animate(withDuration:TimeInterval(defaultTime), animations: {
            self.WhiteView.frame = self.whiteViewEndFrame
        }) { (_) in
            self.addWhiteVieSubView()
        }
    }
    //放一张展示图片
    func addWhiteVieSubView(){
       monthNumber = convertDateToMonth(date: NSDate.init())
       yearNumber = convertDateToYear(date: NSDate.init())
       nowMonth = convertDateToMonth(date: NSDate.init())
       nowYear = convertDateToYear(date: NSDate.init())
       calendarViewHeader()
       test(month: monthNumber)
    }
    //日历头
    func calendarViewHeader(){
        let headerView: UIView = UIView.init(frame: CGRect.init(x: 0, y: 50, width: ScreenWidth, height: 80))
        WhiteView.addSubview(headerView)
        let leftBtn:UIButton = UIButton.init(type: UIButton.ButtonType.custom)
        leftBtn.frame = CGRect.init(x: 25, y: 0, width: 60, height: 40)
        leftBtn.setImage(UIImage.init(named: "left"), for:  UIControl.State.normal)
        leftBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        leftBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        leftBtn.addTarget(self, action: #selector(leftBtnClick), for: UIControl.Event.touchUpInside)
        headerView.addSubview(leftBtn)
        titleLabel1 = UILabel.init(frame: CGRect.init(x: ScreenWidth/2 - 80, y: 0, width: 160, height: 40))
        titleLabel1.textAlignment = NSTextAlignment.center
        titleLabel1.textColor = ZHFColor.zhf_color(withHex: 0x333333)
        titleLabel1.font = UIFont.systemFont(ofSize: 17)
        headerView.addSubview(titleLabel1)
        rightBtn = UIButton.init(type: UIButton.ButtonType.custom)
        rightBtn.frame = CGRect.init(x: ScreenWidth - 85, y: 0, width: 60, height: 40)
        rightBtn.setImage(UIImage.init(named: "right"), for:  UIControl.State.normal)
        rightBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        rightBtn.setTitleColor(UIColor.gray, for: UIControl.State.normal)
        rightBtn.addTarget(self, action: #selector(rightBtnClick), for: UIControl.Event.touchUpInside)
        headerView.addSubview(rightBtn)
        let arr = ["S","M","T","W","T","F","S"]
        for i in 0 ..< 7 {
            let textLabel: UILabel = UILabel.init(frame: CGRect.init(x: leftMargin + (viewWH+bothMargin)*CGFloat(i), y: 40, width: viewWH, height: 40))
            textLabel.text = arr[i]
            textLabel.font = UIFont.systemFont(ofSize: 13)
            textLabel.textAlignment = NSTextAlignment.center
            textLabel.textColor = ZHFColor.zhf_color(withHex: 0x999999);
            headerView.addSubview(textLabel)
        }
        calendarView = UIView.init(frame: CGRect.init(x: 0, y: headerView.frame.maxY, width: ScreenWidth, height: WhiteView.frame.size.height - headerView.frame.maxY))
        WhiteView.addSubview(calendarView)
    }
    //上个月
    @objc func leftBtnClick(){
        monthNumber =  monthNumber - 1
        test(month: monthNumber)
    }
    //下个月
    @objc func rightBtnClick(){
        monthNumber = monthNumber + 1
        test(month: monthNumber)
    }
    //是否隐藏右按钮
    func isHiddenRightBtn() {
        if nowYear > yearNumber {
            rightBtn.isHidden = false
        }
        else{
            if nowMonth > monthNumber{
                rightBtn.isHidden = false
            }
            else{
                rightBtn.isHidden = true
            }
        }
    }
    func test(month:NSInteger){
        for view1 in calendarView.subviews {
            view1.removeFromSuperview()
        }
        if (monthNumber > 12) {
            monthNumber = 1;
            yearNumber = yearNumber + 1;
        }
        if (monthNumber <= 0) {
            monthNumber = 12;
            yearNumber = yearNumber - 1;
        }
        let  dateFormatter: DateFormatter = DateFormatter.init()
        dateFormatter.dateFormat = "yyyy-MM"
        var string:String = "\(yearNumber)-\(monthNumber)"
        if monthNumber < 10 {
            string = "\(yearNumber)-0\(monthNumber)"
        }
        isHiddenRightBtn()
        titleLabel1.text = string
        let date: NSDate = dateFormatter.date(from: string)! as NSDate
        logCalendarWith(date: date, day: 5, isHiden: false)
    }
    func logCalendarWith(date:NSDate,day:NSInteger,isHiden:Bool) {
        let firstWeekDay :NSInteger  = convertDateToFirstWeekDay(date: date) //本月第一天是周几
        let totalDays: NSInteger = convertDateToTotalDays(date: date)//本月总天数
        var available: NSInteger = 1//本月第一天
        var nextMonthDay: NSInteger = 1//下月第一天
        let lastMonthDate: NSDate = getDateFrom(date: date, offsetMonths: -1)//上月月数
        let lastMonthTotalDays :NSInteger  = convertDateToTotalDays(date: lastMonthDate) //上月总天数
        let line :NSInteger = (totalDays + firstWeekDay + 6)/7; //计算行数
        let column: NSInteger = 7 //一共从周日到周一7列
        for i in 0 ..< line {
            for j in 0 ..< column {
                //尾
                if (available > totalDays) {
                    if (isHiden  == true) {
                      //  print("\t");
                    }
                    else{
                        //print("\t%ld",nextMonthDay);
                        let view: UIView = UIView.init(frame: CGRect.init(x: leftMargin + (bothMargin+viewWH)*CGFloat(j) , y:  topMargin+(bothMargin+viewWH)*CGFloat(i), width: viewWH, height: viewWH))
                        calendarView.addSubview(view)
                        view.tag = nextMonthDay;
                       // self.isSelect(isSelect: false, isHavePoint: false, fatherView: view)
                    }
                    nextMonthDay = nextMonthDay + 1;
                    continue;
                }
                //头
                if (i == 0 && j < firstWeekDay) {
                    //根据当月第一天是周几，回推出上个月最后几天对应的位置。
                    let lastMonthDay :NSInteger  = lastMonthTotalDays - firstWeekDay + j + 1; //j从0开始，所以这里+1
                    if (isHiden  == true) {
                       // print("\t");
                    }
                    else{
                     //   print("\t%ld",lastMonthDay);
                        let view: UIView = UIView.init(frame: CGRect.init(x: leftMargin + (bothMargin+viewWH)*CGFloat(j), y:  topMargin, width: viewWH, height: viewWH))
                        calendarView.addSubview(view)
                        view.tag = lastMonthDay;
                       // self.isSelect(isSelect: false, isHavePoint: false, fatherView: view)
                    }
                }else {
                    //打印当月数据
                    let view: UIView = UIView.init(frame: CGRect.init(x: leftMargin + (bothMargin+viewWH)*CGFloat(j), y:  topMargin+(bothMargin+viewWH)*CGFloat(i), width: viewWH, height: viewWH))
                    calendarView.addSubview(view)
                    view.tag = available
                    if (bigGreenPoints.contains(available)&&smallGreenPoints.contains(available)){
                         self.isSelect(isSelect: true, isHavePoint: true, fatherView: view)
                    }
                    else if (bigGreenPoints.contains(available)&&(smallGreenPoints.contains(available)==false)){
                         self.isSelect(isSelect: true, isHavePoint: false, fatherView: view)
                    }
                    else if (smallGreenPoints.contains(available)&&(bigGreenPoints.contains(available)==false)){
                        self.isSelect(isSelect: false, isHavePoint: true, fatherView: view)
                    }
                    else{
                        self.isSelect(isSelect: false, isHavePoint: false, fatherView: view)
                    }
                    available  = available + 1;
                }
            }
        }
    }
    func isSelect(isSelect:Bool,isHavePoint:Bool,fatherView:UIView){
        let tap:UITapGestureRecognizer = UITapGestureRecognizer.init(target: self, action: #selector(tapClick))
        fatherView.addGestureRecognizer(tap)
        let textLabel:UILabel = UILabel.init(frame: CGRect.init(x: 5, y: 0, width: viewWH-10, height: viewWH-10))
        textLabel.layer.masksToBounds = true
        textLabel.layer.cornerRadius = (viewWH-10)/2
        textLabel.text = "\(fatherView.tag)"
        textLabel.font = UIFont.systemFont(ofSize: 12)
        textLabel.textAlignment = NSTextAlignment.center
        textLabel.backgroundColor = UIColor.white
        textLabel.textColor = UIColor.black
        fatherView.addSubview(textLabel)
        if (isSelect == true) {
            textLabel.backgroundColor = pointColor
        }
        else{
            textLabel.backgroundColor = UIColor.white
        }
        if (isHavePoint == true) {
            let pointView:UIView = UIView.init(frame: CGRect.init(x: viewWH/2-4, y: viewWH-8, width: 6, height: 6))
            pointView.backgroundColor = pointColor
            pointView.layer.masksToBounds = true
            pointView.layer.cornerRadius = 3
            fatherView.addSubview(pointView)
        }
    }
    @objc func tapClick(tap:UITapGestureRecognizer) {
        if clickClosure != nil{
            tapBtnAndcancelBtnClick()
             clickClosure!("\(yearNumber)-\(monthNumber)-\(tap.view!.tag)")
        }
    }
    //根据date获取日
    func convertDateToDay(date: NSDate) -> NSInteger {
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        let components:NSDateComponents = calendar.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.day.rawValue), from: date as Date) as NSDateComponents
        return components.day;
    }
    
    //根据date获取月
    func convertDateToMonth(date: NSDate) -> NSInteger {
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        let components:NSDateComponents = calendar.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.month.rawValue), from: date as Date) as NSDateComponents
        return components.month;
    }
    //根据date获取年
    func convertDateToYear(date: NSDate) -> NSInteger {
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        let components:NSDateComponents = calendar.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue), from: date as Date) as NSDateComponents
        return components.year;
    }
    //根据date获取当月周几
    func convertDateToFirstWeekDay(date:NSDate) -> NSInteger {
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        calendar.firstWeekday = 1//1.Sun. 2.Mon. 3.Thes. 4.Wed. 5.Thur. 6.Fri. 7.Sat.
        let comp :NSDateComponents = calendar.components(NSCalendar.Unit(rawValue: NSCalendar.Unit.year.rawValue | NSCalendar.Unit.month.rawValue | NSCalendar.Unit.day.rawValue), from: date as Date) as NSDateComponents
        comp.day = 1
        let firstDayOfMonthDate:NSDate = calendar.date(from: comp as DateComponents)! as NSDate
        let firstWeekday :UInt  = UInt(calendar.ordinality(of: NSCalendar.Unit.weekday, in:NSCalendar.Unit.weekOfMonth, for: firstDayOfMonthDate as Date))
        let firstWeekday1 = firstWeekday - 1
        return NSInteger(firstWeekday1);  //美国时间周日为星期的第一天，所以周日-周六为1-7，改为0-6方便计算
    }
    //根据date获取当月总天数
    func convertDateToTotalDays(date: NSDate) -> NSInteger {
        let calendar = Calendar(identifier:Calendar.Identifier.gregorian)
        let daysInOfMonth:NSRange =  ((calendar as NSCalendar?)?.range(of: NSCalendar.Unit.day, in: NSCalendar.Unit.month, for: date as Date))!
        return daysInOfMonth.length
    }
    //根据date获取偏移指定月数的date
    func getDateFrom(date: NSDate,offsetMonths: NSInteger) -> NSDate {
        let formatter: DateFormatter = DateFormatter.init()
        formatter.dateFormat = "yyyy-MM"
        let calendar:NSCalendar = NSCalendar.current as NSCalendar
        let lastMonthComps:NSDateComponents = NSDateComponents.init()
        lastMonthComps.month = offsetMonths  //year = 1表示1年后的时间 year = -1为1年前的日期，month day 类推
        let newdate:NSDate = calendar.date(byAdding: lastMonthComps as DateComponents, to: date as Date, options: NSCalendar.Options.init(rawValue: 0))! as NSDate
        return newdate;
    }
}
