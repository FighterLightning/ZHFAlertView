//
//  Const.swift
//  SwiftTest
//
//  Created by 1111 on 2017/11/7.
//  Copyright © 2017年 xuejianfeng. All rights reserved.
//

import UIKit

let kScreenHeight = UIScreen.main.bounds.size.height
let kScreenWidth = UIScreen.main.bounds.size.width

//=================系统参数相关===============
// iPhone X
let iPhoneX = (kScreenWidth == 375 && kScreenHeight == 812) ? true : false
let CURRENT_SYS_VERSION = (UIDevice.current.systemVersion as NSString).floatValue
let IOS8 = (UIDevice.current.systemVersion as NSString).doubleValue >= 8.0
let NAV_HEIGHT = iPhoneX ? (44 + 44) : 64
let TABBAR_HEIGHT = iPhoneX ? (49 + 34) : 49
let kTabbarSafeBottomMargin = iPhoneX ? 34 : 0
let BATTERY_BARHEIGHT = iPhoneX ? 44 : 20
//===================================
enum TBCalendarHeaderViewType: Int {
    case leftDate
    case centerDate
}

let CHANGE_SELECT_DATE: String = "change_select_date"
