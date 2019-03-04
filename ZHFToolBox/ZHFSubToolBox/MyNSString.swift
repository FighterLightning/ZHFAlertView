//
//  NSString-Extension.swift
//  Fattykitchen
//
//  Created by 张海峰 on 2017/8/30.
//  Copyright © 2017年 张海峰. All rights reserved.
//

import Foundation
import CommonCrypto
import UIKit
extension NSString{
    //1.判断是否是手机号
    class func initValiMobile(mobile: String) -> Bool {
        let count = mobile.count
        if count != 11
        {
            return false
        }else{
            return true
//            let CM_NUM :NSString = "^((13[4-9])|(147)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
//            let CU_NUM :NSString = "^((13[0-2])|(145)|(15[5-6])|(176)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
//            let CT_NUM :NSString = "^((133)|(153)|(177)|(173)|(18[0,1,9]))\\d{8}$";
//            let pred1: NSPredicate =  NSPredicate(format: "SELF MATCHES %@", CM_NUM)
//            let isMatch1 :Bool = pred1.evaluate(with: mobile)
//            let pred2: NSPredicate = NSPredicate(format: "SELF MATCHES %@", CU_NUM)
//            let isMatch2 :Bool = pred2.evaluate(with: mobile)
//            let pred3: NSPredicate = NSPredicate(format: "SELF MATCHES %@", CT_NUM)
//            let isMatch3 :Bool = pred3.evaluate(with: mobile)
//            if (isMatch1 || isMatch2 || isMatch3) {
//                return true
//            }else{
//                return false
//            }
        }
    }
    // 获取当前时间字符串 当天传入0， 前一天传1， 后一天传-1，以此类推
    class func initNowDateStr(number:NSInteger) -> String{
        let date = Date.init(timeInterval: TimeInterval(-24*60*60*number), since: Date())
        //输出格式
        let dformatter = DateFormatter.init()
        dformatter.dateFormat = "MM月dd日"
        let time  = dformatter.string(from: date)
        return time
    }
    // 获取当前时间字符串 当天传入0， 前一天传1， 后一天传-1，以此类推
    class func initNowMonthStr(number:NSInteger) -> String{
        let date = Date.init(timeInterval: TimeInterval(-24*60*60*number), since: Date())
        //输出格式
        let dformatter = DateFormatter.init()
        dformatter.dateFormat = "yyyy年MM月"
        let time  = dformatter.string(from: date)
        return time
    }
    //把当前时间时间转换成10位时间戳
    class func initNowDate() -> String{
        let timeInterval = NSDate().timeIntervalSince1970 * 1000
        return (String(timeInterval) as NSString).substring(to: 10)
    }
    //时间戳转时间
    class func initTime(timeStamp:NSInteger) -> String{
    let timeInterval:TimeInterval = TimeInterval(timeStamp)
    let date = Date.init(timeIntervalSince1970: timeInterval)
    //输出格式
    let dformatter = DateFormatter.init()
        dformatter.dateFormat = "yyyy\\MM\\dd"
    let time  = dformatter.string(from: date)
    return time
    }
    //判断是否是邮箱
    class func initmailBox(email: String) -> Bool  {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}"
        let emailTest:NSPredicate = NSPredicate(format: "SELF MATCHES %@", emailRegex)
        return emailTest.evaluate(with: email)
    }
}
extension NSString{
     //2.Md5 字典加密
    class func initMd5(Arr: [String]) -> [String : AnyObject] {
        var string :String = "Surprisebox123"
        for  str1 in Arr {
            let strArr = str1.components(separatedBy: "=")
            string.append("\(strArr[0])\(strArr[1])")
        }
        let str = string.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        let strMd5 = String(format: hash as String).uppercased()
        let parameters :NSMutableDictionary = ["sign":strMd5]
        for i in 0 ..< Arr.count {
            let str = Arr[i]
            let strArray = str.components(separatedBy: "=")
            parameters.setObject( strArray[1], forKey: strArray[0] as NSCopying)
        }
        return parameters as! [String : AnyObject]
    }
    //2.Md5 字符串加密
    class func initMd5Str(string: String) -> String {
        let string1 :String = "Surprisebox123\(string)"
        let str = string1.cString(using: String.Encoding.utf8)
        let strLen = CUnsignedInt(string1.lengthOfBytes(using: String.Encoding.utf8))
        let digestLen = Int(CC_MD5_DIGEST_LENGTH)
        let result = UnsafeMutablePointer<CUnsignedChar>.allocate(capacity: digestLen)
        CC_MD5(str!, strLen, result)
        let hash = NSMutableString()
        for i in 0 ..< digestLen {
            hash.appendFormat("%02x", result[i])
        }
        result.deallocate()
        let strMd5 = String(format: hash as String).uppercased()
        return strMd5
    }
}
extension NSString{
    //字典转字符串
    class func initGetJsonString(dic: NSDictionary) -> String{
        if (!JSONSerialization.isValidJSONObject(dic)) {
            // "无法解析"
            return ""
        }
        let data :NSData! = try? JSONSerialization.data(withJSONObject: dic, options: []) as NSData
        let jsonString = NSString(data: data as Data, encoding: String.Encoding.utf8.rawValue)
        return jsonString! as String
    }
    //字符串转字典
    class func getDictionaryFromJSONString(jsonString:String) ->NSDictionary{
        
        let jsonData:Data = jsonString.data(using: .utf8)!
        
        let dict = try? JSONSerialization.jsonObject(with: jsonData, options: .mutableContainers)
        if dict != nil {
            return dict as! NSDictionary
        }
        return NSDictionary()
    }
}
extension NSString{
    var removeAllSapce: String {
        if self.length != 11{
            //过滤手机号中的 " " 和 "-" 和不是数字的东西
        return self.replacingOccurrences(of: "[^0-9]", with: "", options: NSString.CompareOptions.regularExpression, range: NSRange.init(location: 0, length: self.length))
        }
        else{
            return self as String
        }
    }
}
