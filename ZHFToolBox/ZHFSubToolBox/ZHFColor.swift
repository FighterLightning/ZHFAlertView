//
//  ZHFColor.swift
//  AmazedBox
//
//  Created by lantian on 2017/12/4.
//  Copyright © 2017年 张海峰. All rights reserved.
//

import UIKit

class ZHFColor: UIColor {
    /// 主题色（及选中颜色）
    open class var zhf_selectColor: UIColor {
        //橙色
        get {
            return self.zhf_color(withHex: 0xF98507)
        }
    }
    /// 标题字体颜色
    open class var zhf33_titleTextColor: UIColor {
        
        get {
            return self.zhf_color(withHex: 0x333333)
        }
    }
    /// 内容字体颜色
    open class var zhf88_contentTextColor: UIColor {
        
        get {
            return self.zhf_color(withHex: 0x888888)
        }
    }
    open class var zhf66_contentTextColor: UIColor {
        
        get {
            return self.zhf_color(withHex: 0x666666)
        }
    }
    open class var zhfe8_backGroundColor: UIColor {
        get {
            return self.zhf_color(withHex: 0xe8e8e8)
        }
    }
    open class var zhff9_backGroundColor: UIColor {
        get {
            return self.zhf_color(withHex: 0xf9f9f9)
        }
    }
    open class var zhfcc_lineColor: UIColor {
        get {
            return self.zhf_color(withHex: 0xcccccc)
        }
    }
    //分割线的颜色
    open class var zhf_lineColor: UIColor {
        get {
            return self.zhf_color(withHex: 0xebf0f5)
        }
    }
    
    /// 随机色
    ///
    /// - Returns: 随机的颜色
    class func zhf_randomColor() -> UIColor {
        
        let r = CGFloat(arc4random() % 256) / 255.0
        let g = CGFloat(arc4random() % 256) / 255.0
        let b = CGFloat(arc4random() % 256) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    /// 十六进制颜色
    ///
    /// - Parameter withHex: 0xFFFFFF
    /// - Returns: color
    class func zhf_color(withHex: UInt32) -> UIColor {
        
        let r = ((CGFloat)((withHex & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((withHex & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(withHex & 0xFF)) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    
    class func zhf_colorAlpha(withHex: UInt32,alpha: CGFloat) -> UIColor {
        
        let r = ((CGFloat)((withHex & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((withHex & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(withHex & 0xFF)) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: alpha)
    }
    
    /// 0~255 颜色
    ///
    /// - Parameters:
    ///   - withRed: red(0~255)
    ///   - green: green(0~255)
    ///   - blue: blue(0~255)
    /// - Returns: color
    class func zhf_color(withRed: UInt8, green: UInt8, blue: UInt8) -> UIColor {
        
        let r = CGFloat(withRed) / 255.0
        let g = CGFloat(green) / 255.0
        let b = CGFloat(blue) / 255.0
        
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
    class func initString(hex: String) -> UIColor {
        let scanner = Scanner(string: hex)
        scanner.scanLocation = 0
        var rgbValue: UInt64 = 0
        scanner.scanHexInt64(&rgbValue)
        let r = ((CGFloat)((rgbValue & 0xFF0000) >> 16)) / 255.0
        let g = ((CGFloat)((rgbValue & 0xFF00) >> 8)) / 255.0
        let b = ((CGFloat)(rgbValue & 0xFF)) / 255.0
        return UIColor(red: r, green: g, blue: b, alpha: 1.0)
    }
}

