//
//  TBCalendar.swift
//  SwiftTest
//
//  Created by 1111 on 2018/4/9.
//  Copyright © 2018年 xuejianfeng. All rights reserved.
//

import UIKit

@objc protocol TBCalendarDataSource: NSObjectProtocol{
    /**
     * Tells the dataSource a call back is the calendar of height.
     */
    @objc func calender(calender: TBCalendar, layoutCallBackHeight: CGFloat) -> Void
    
    /**
     * Asks the dataSource for a title for the specific date as a replacement of the day text
     */
    @objc optional func calendar(calendar: TBCalendar, titleForDate: NSDate) -> String
    
    /**
     * Asks the dataSource for a subtitle for the specific date under the day text.
     */
    @objc optional func calender(calendar: TBCalendar, subTitleForDate: NSDate) -> String
}

@objc protocol TBCalendarDataDelegate: NSObjectProtocol{
    /**
     * Asks the delegate whether the specific date is allowed to be selected by tapping.
     */
    @objc optional func calender(calender: TBCalendar, shouldSelectDate: NSDate) -> Void
    
    /**
     * Tells the delegate a date in the calendar is selected by tapping.
     */
    @objc optional func calender(calender: TBCalendar, didSelectDate: NSDate) -> Void
}


class TBCalendar: UIView, UICollectionViewDelegate, UICollectionViewDataSource{
    static let TBCalendarDateCellID = "LZBCalendarDateCellID"
    static let limitation_Low = 28
    static let limitation_Medium = 35
    static let limitation_High = 42
    
    /**
     * The object that acts as the data source of the calendar.
     */
    var dataSource: TBCalendarDataSource?
    
    /**
     * The object that acts as the data source of the calendar.
     */
    var delegate: TBCalendarDataDelegate?
    
    private var itemHeight: CGFloat = 0
    private var style: TBCalendarAppearStyle?
    private var currentSelctCell: TBCalendarDateCell?
    private var dotArr = [UIView]()
    private var itemNum: Int?
    
    lazy var contentView: UIView = getContentView()
    lazy var collectionView: UICollectionView = getCollectionView()
    lazy var collectFlowLayout: UICollectionViewFlowLayout = getCollectFlowLayout()
    lazy var headerView: TBCalendarHeaderView = self.getHeaderView()
    
    init(style: TBCalendarAppearStyle, frame: CGRect) {
        super.init(frame: frame)
        self.style = style
        self.setupUI()
    }
    
    func setupUI() {
        self.addSubview(self.headerView)
        self.headerView.monthDate = (self.style?.today)!
        self.addSubview(self.contentView)
        self.contentView.addSubview(self.collectionView)
        self.collectionView.register(TBCalendarDateCell.self, forCellWithReuseIdentifier: TBCalendar.TBCalendarDateCellID)
        
        
        self.headerView.previousMonth = {(date) ->Void in
            self.style?.today = date;
            self.setNeedsLayout()
            self.collectionView.reloadData()
        }
        
        self.headerView.nextMonth = {(date) ->Void in
            self.style?.today = date;
            self.setNeedsLayout()
            self.collectionView.reloadData()
        }
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        let width = self.bounds.size.width;
        self.headerView.frame = CGRect.init(x: 0, y: 0, width: width, height: (self.style?.headerViewHeihgt!)!);
        layoutCollectionView()
        self.itemNum = 1;
    }
    
    func layoutCollectionView() {
        
        let itemWidth = Int(self.bounds.size.width) / (self.style?.weekDateDays.count)!;
        var itemHeight = itemWidth;
        if((self.style?.isNeedCustomHeihgt)! && (self.style?.itemHeight)! > 0.0)
        {
            itemHeight = Int((self.style?.itemHeight)!)
        }
        else
        {
            itemHeight = itemWidth;
        }
        self.itemHeight = CGFloat(itemHeight);
        self.collectFlowLayout.itemSize = CGSize.init(width: CGFloat(itemWidth), height: CGFloat(itemHeight - 10))
        
        //collectinView高度
        let marginDays = self.firstDayInFirstWeekThisMonth(date: (self.style?.today)!)
        let itemCount = marginDays + self.totalDaysThisMonth(date: (self.style?.today)!)
        var collectionViewHeight = 0;
        if(itemCount <= TBCalendar.limitation_Low){
            collectionViewHeight = TBCalendar.limitation_Low / (self.style?.weekDateDays.count)! * Int(self.itemHeight)
        }
        else if(itemCount > TBCalendar.limitation_Low && itemCount <= TBCalendar.limitation_Medium){
            collectionViewHeight = TBCalendar.limitation_Medium/(self.style?.weekDateDays.count)! * Int(self.itemHeight)
        }
        else{
            collectionViewHeight = TBCalendar.limitation_High/(self.style?.weekDateDays.count)! * Int(self.itemHeight)
        }
        
        
        self.collectionView.frame = CGRect.init(x: 0, y: 0, width: Int(self.bounds.size.width), height: collectionViewHeight - 50);
        
        
        self.contentView.frame = CGRect.init(x: 0, y: self.headerView.frame.maxY, width: self.bounds.size.width, height: CGFloat(Int(collectionViewHeight) - 50))
        self.collectionView.collectionViewLayout = self.collectFlowLayout
        
        self.callBackHeight(height: CGFloat(collectionViewHeight) + (self.style?.headerViewHeihgt)! + 10)
    }
    // collectCell-dataSource
    func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        
        let marginDays = self.firstDayInFirstWeekThisMonth(date: (self.style?.today)!)
        let daysThisMonth = self.totalDaysThisMonth(date: (self.style?.today)!)
        
        if(indexPath.row >= marginDays && indexPath.row <= marginDays + daysThisMonth - 1)
        {
            var day = 0;
            day = indexPath.row - marginDays + 1
            let date = self.dateByday(day: day, date: (self.style?.today)!)
            
            return self.shouldSelectDate(date: date as NSDate)
        }
        else{
            return false
        }
        
    }
    
    @objc func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let marginDays: NSInteger = self.firstDayInFirstWeekThisMonth(date: (self.style?.today)!);
        let daysThisMonth: NSInteger = self.totalDaysThisMonth(date: (self.style?.today)!);
        if(indexPath.row >= marginDays && (indexPath.row <= (marginDays + daysThisMonth - 1))){
            
            let day: NSInteger = indexPath.row - marginDays + 1
            let date: Date = self.dateByday(day: day, date: (self.style?.today)!)
            let cell: TBCalendarDateCell = collectionView.cellForItem(at: indexPath) as! TBCalendarDateCell
            if(self.style!.isSupportMoreSelect!){
                self.didSelectDate(date: date as NSDate)
                cell.updateCellSelectCellColor()
            }
            else
            {
                if(self.currentSelctCell == cell)
                {
                    return;
                }
                
                self.currentSelctCell?.isSelected = false
                self.currentSelctCell?.updateCellSelectCellColor()
                cell.isSelected = true
                self.currentSelctCell = cell
                self.didSelectDate(date: date as NSDate)
                cell.updateCellSelectCellColor(animation:true)
            }
        }
        else
        {
            //            self.collectionView(collectionView, didDeselectItemAt: indexPath)
        }
    }
    
    // DataSource
    func titleForDate(date: NSDate) -> String {
        
        if (self.dataSource != nil) && (self.dataSource?.responds(to: #selector(TBCalendarDataSource.calendar(calendar:titleForDate:))))! {
            return (self.dataSource?.calendar!(calendar: self, titleForDate: date))!
        }
        
        return "";
    }
    
    
    func subtitleForDate(date: NSDate) -> String {
        if (self.dataSource != nil) && (self.dataSource?.responds(to: #selector(TBCalendarDataSource.calender(calendar:subTitleForDate:))))! {
            return (self.dataSource?.calender!(calendar: self, subTitleForDate: date))!
        }
        
        return ""
    }
    
    func callBackHeight(height: CGFloat) -> Void {
        if (self.dataSource != nil) && (self.dataSource?.responds(to: #selector(TBCalendarDataSource.calender(calender:layoutCallBackHeight:))))! {
            return (self.dataSource?.calender(calender: self, layoutCallBackHeight: height))!
        }
    }
    
    // delegate
    func shouldSelectDate(date: NSDate) -> Bool {
        
        if (self.delegate != nil) && (self.delegate?.responds(to: #selector(TBCalendarDataDelegate.calender(calender:shouldSelectDate:))))! {
            return ((self.delegate?.calender!(calender: self, shouldSelectDate: date)) != nil)
        }
        
        return true
    }
    
    func didSelectDate(date: NSDate) {
        
        if (self.delegate != nil) && (self.delegate?.responds(to: #selector(TBCalendarDataDelegate.calender(calender:didSelectDate:))))! {
            self.delegate?.calender!(calender: self, didSelectDate: date)
        }
    }
    
    func setDataArr(arr: [UIView]) {
        self.dotArr.removeAll()
        self.dotArr += arr
        self.collectionView.reloadData()
    }
    
    // private
    func totalDaysThisMonth(date: NSDate) -> Int {
        let range = NSCalendar.current.range(of: .day, in: .month, for: date as Date)
        
        return (range?.count)!
    }
    
    func firstDayInFirstWeekThisMonth(date: NSDate) -> Int {
        var calendar = NSCalendar.current
        calendar.firstWeekday = 1
        
        var comp = calendar.dateComponents([.year, .month, .day], from: date as Date)
        comp.day = 1;
        
        let firstDayOfMonthDate = calendar.date(from: comp)
        let firstWeekday = calendar.ordinality(of: .weekday, in: .weekOfMonth, for: firstDayOfMonthDate!)
        return firstWeekday! - 1
    }
    
    func dateByday(day: Int, date: NSDate) -> Date {
        let calendar = NSCalendar.current
        let comp = calendar.dateComponents([.year, .month, .day], from: date as Date)
        let newComp = NSDateComponents.init()
        newComp.day = day
        newComp.year = comp.year!
        newComp.month = comp.month!
        
        let formatter = DateFormatter.init()
        formatter.dateFormat = "YYYY-MM-dd"
        let string: String = "\(newComp.year)" + "-" + "\(newComp.month)" + "-" + "\(newComp.day)"
        
        return formatter.date(from: string)!
    }
    
    // UICollectionViewDataSource
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        
        let marginDays = self.firstDayInFirstWeekThisMonth(date: (self.style?.today)!)
        let itemCount = marginDays + self.totalDaysThisMonth(date: (self.style?.today)!)
        
        if itemCount >= TBCalendar.limitation_High {
            return 0
        }
        
        if (itemCount > TBCalendar.limitation_Medium) && (itemCount <= TBCalendar.limitation_High) {
            return TBCalendar.limitation_High
        }
        else if (itemCount > TBCalendar.limitation_Low) && (itemCount <= TBCalendar.limitation_Medium){
            return TBCalendar.limitation_Medium
        }
        else{
            return TBCalendar.limitation_Low
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: TBCalendarDateCell = collectionView.dequeueReusableCell(withReuseIdentifier: TBCalendar.TBCalendarDateCellID, for: indexPath) as! TBCalendarDateCell
        cell.isSelected = false
        cell.updateCellSelectCellColor()
        cell.style = (self.style)!
        let marginDays = self.firstDayInFirstWeekThisMonth(date: (self.style?.today)!)
        let daysThisMonth = self.totalDaysThisMonth(date: (self.style?.today)!)
        
        cell.updateCellDotView(status: "7")
        if indexPath.row < marginDays {
            cell.updateCellDotView(status: "7")
            cell.reloadCellData(title: "", subTitle: "")
        }
        else if indexPath.row > (marginDays + daysThisMonth - 1) {
            cell.updateCellDotView(status: "7")
            cell.reloadCellData(title: "", subTitle: "")
        }
        else{
            cell.updateCellDotView(status: "7")
            
            let day = indexPath.row - marginDays + 1
            let date = self.dateByday(day: day, date: (self.style?.today)!)
            cell.isSelected = self.isToday(date: date, cell: cell)
            
            let row = indexPath.row
            if (row % 7 == 0) || ((row + 1) % 7 == 0){
                cell.dateLabel.textColor = UIColor.UIColorFromRGB(rgb: 0x999999)
            }
            else{
                cell.dateLabel.textColor = UIColor.UIColorFromRGB(rgb: 0x000000)
            }
            
            let dateFormatter = DateFormatter.init()
            dateFormatter.dateFormat = "dd"
            
            if self.dotArr.count > 0 {
                
                let v = self.dotArr[indexPath.row - marginDays]
                if v.tag == -2 || v.tag == -1{
                    cell.isSelected = true;
                    self.currentSelctCell = cell
                }
                else
                {
                    cell.isSelected = false
                }
            }
            else{
                cell.updateCellDotView(status: "7")
            }
            
            let dateStr: String = self.titleForDate(date: date as NSDate)
            if dateStr.count > 0{
                cell.reloadCellData(title: dateStr)
            }
            else {
                cell.reloadCellData(title: "\(day)")
            }
        }
        
        cell.updateCellSelectBackgroundColor()
        return cell
    }
    
    func isToday(date: Date, cell: TBCalendarDateCell) -> Bool {
        
        let nowDate = Date()
        if date.getDateWithMonth() == nowDate.getDateWithMonth() {
            let result = nowDate.getDateWithDay() - date.getDateWithDay()
            if result == 0 {
                self.currentSelctCell = cell
                return true
            }
            else {
                return false
            }
        }
        
        return true
    }
    
    // lazy
    func getHeaderView() -> TBCalendarHeaderView {
        let headerView = TBCalendarHeaderView.init(type: .centerDate, style: self.style!, frame: CGRect.init())
        return headerView
    }
    
    func getContentView() -> UIView {
        let view = UIView.init()
        view.backgroundColor = UIColor.UIColorFromRGB(rgb: 0xffffff)
        return view
    }
    
    func getCollectionView() -> UICollectionView {
        let collectionView = UICollectionView.init(frame: self.contentView.bounds, collectionViewLayout: self.collectFlowLayout)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = UIColor.UIColorFromRGB(rgb: 0xffffff)
        return collectionView
    }
    
    func getCollectFlowLayout() -> UICollectionViewFlowLayout {
        let collectFlowLayout = UICollectionViewFlowLayout.init()
        collectFlowLayout.minimumLineSpacing = 0.0;
        collectFlowLayout.minimumInteritemSpacing = 0.0;
        collectFlowLayout.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0);
        return collectFlowLayout
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
