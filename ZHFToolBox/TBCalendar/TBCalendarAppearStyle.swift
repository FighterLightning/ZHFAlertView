//
//  TBCalendarAppearStyle.swift
//  SwiftTest
//
//  Created by 1111 on 2018/4/2.
//  Copyright © 2018年 xuejianfeng. All rights reserved.
//

import UIKit

class TBCalendarAppearStyle: NSObject {
    // head-data
    /**
     *  设置item的高度，isNeedCustomHeihgt是YES，可以设置itemHeight
     */
    var isNeedCustomHeihgt: Bool?
    /**
     *  设置当前日期
     */
    var today: NSDate?
    /**
     *  设置是否支持同时选中多个日期，默认isSupportMoreSelect = NO
     */
    var isSupportMoreSelect: Bool?
    /**
     *  设置星期日期的样式，默认是中文  @"日",@"一",@"二",@"三",@"四",@"五",@"六"
     */
    var weekDateDays = [String]()
    
    //头部style设置
    /**
     *  设置头部View的选择月份View的高度
     */
    var headerViewDateHeight: CGFloat?
    /**
     *  设置头部View的星期几View的高度
     */
    var headerViewWeekHeight: CGFloat?
    /**
     *  设置头部View的星期几View与选择月份View中间分割线的高度
     */
    var headerViewLineHeight: CGFloat?
    /**
     *  获得整个头部View的高度
     */
    var headerViewHeihgt: CGFloat?
    /**
     *  设置头部View的选择月份View的字体
     */
    var headerViewDateFont: UIFont?
    /**
     *  设置头部View的选择月份View的字体颜色
     */
    var headerViewDateColor: UIColor?
    /**
     *  设置头部View的星期几View的字体
     */
    var headerViewWeekFont: UIFont?
    /**
     *  设置头部View的星期几View的字体颜色
     */
    var headerViewWeekColor: UIColor?
    
    // 日期sytle设置
    /**
     *  设置日期item的的高度，宽度根据屏幕宽度自动适应  isNeedCustomHeihgt = YES 有效
     */
    var itemHeight: CGFloat?
    /**
     *  设置日期item的标题字体大小
     */
    var dateTittleFont: UIFont?
    /**
     *  设置日期item的描述字体大小
     */
    var dateDescFont: UIFont?
    /**
     *  设置日期item的标题字体选中颜色
     */
    var dateTittleSelectColor: UIColor?
    /**
     *  设置日期item的标题字体未选中颜色
     */
    var dateTittleUnselectColor: UIColor?
    /**
     *  设置日期item的选中背景颜色
     */
    var dateBackSelectColor: UIColor?
    /**
     *  设置日期item的未选中背景颜色
     */
    var dateBackUnselectColor: UIColor?
    /**
     *  设置日期item的描述选中背景颜色
     */
    var dateDescSelectColor: UIColor?
    /**
     *  设置日期item的描述未选中背景颜色
     */
    var dateDescUnselectColor: UIColor?
    /**
     *  设置日期item的title与描述间距 UIOffset
     */
    var dateTitleDescOffset: UIOffset?
    
    override init() {
        self.isNeedCustomHeihgt = true;
        self.today = NSDate.init();
        
        self.headerViewDateHeight = 70;
        self.headerViewLineHeight = 1.0;
        self.headerViewWeekHeight = 20;
        self.weekDateDays = ["S","M","T","W","T","F","S"]
        self.headerViewDateFont = UIFont.systemFont(ofSize: 18)
        self.headerViewWeekFont = UIFont.systemFont(ofSize: 14)
        self.headerViewWeekColor = ZHFColor.zhf_color(withHex: 0x4F505F)
        self.headerViewDateColor = ZHFColor.zhf_color(withHex: 0x4F505F)
        
        self.itemHeight = 0;
        self.dateTittleFont = UIFont.systemFont(ofSize: 14)
        self.dateDescFont = UIFont.systemFont(ofSize: 14)
        self.dateTittleSelectColor = ZHFColor.zhf_color(withHex: 0x000000)
        self.dateTittleUnselectColor = ZHFColor.zhf_color(withHex: 0x000000)
        self.dateDescSelectColor = UIColor.blue
        self.dateDescUnselectColor = UIColor.purple
        self.dateBackUnselectColor = UIColor.white
        self.dateBackSelectColor = ZHFColor.zhf_color(withHex: 0xEEEEEE)
        self.isSupportMoreSelect = false;
        self.dateTitleDescOffset = UIOffsetMake(0, 10);
        self.headerViewHeihgt = headerViewDateHeight! + headerViewLineHeight! + headerViewWeekHeight!
    }
}
