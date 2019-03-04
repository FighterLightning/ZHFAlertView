//
//  ZHFAlertControllerTool.swift
//  ZHFToolBox
//
//  Created by 张海峰 on 2018/5/9.
//  Copyright © 2018年 张海峰. All rights reserved.
//
/*该demo是和大家分享一下，在项目中自定义各种弹框的思路，用来支撑自己项目的使用，无论什么样的弹框，只要有思路，
相信大家都能完美实现。感觉我这个demo对你有启发或者帮助，不妨给个星星吧
    https://github.com/FighterLightning/ZHFToolBox.git
    https://www.jianshu.com/p/88420bc4d32d
 */
import Foundation
import UIKit
/*
 - parameter currentVC: 当前控制器
 - parameter title:     标题
 - parameter meg:       提示消息
 - parameter cancelBtn: 取消按钮
 - parameter otherBtn:  其他按钮
 - parameter handler:   其他按钮处理事件
 */
class ZHFAlertControllerTool {
    /**
     alterController 一个按钮 不处理事件，简单实用
     */
    static func showAlert(currentVC:UIViewController, title:String,meg:String, cancelBtn:String){
        var title1 = ""
        if title == "" ||  title == nil  {
            title1 = "温馨提示"}
        else{
            title1 = title
        }
        let alertController = UIAlertController(title:title1,message:meg , preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:cancelBtn, style: .cancel, handler:nil)
        alertController.addAction(cancelAction)
        currentVC.present(alertController, animated: true, completion: nil)
    }
    /**
     alterController 一个按钮 处理事件
     */
    static func showAlert(currentVC:UIViewController, title:String, meg:String, okBtn:String, handler:((UIAlertAction) -> Void)?){
        var title1 = ""
        if title == "" ||  title == nil  {
            title1 = "温馨提示"}
        else{
            title1 = title
        }
        let alertController = UIAlertController(title:title1,message:meg , preferredStyle: .alert)
        if okBtn != nil{
            let settingsAction = UIAlertAction(title: okBtn, style: .default, handler: { (action) -> Void in
                handler?(action)
            })
            alertController.addAction(settingsAction)
        }
        currentVC.present(alertController, animated: true, completion: nil)
    }
    /**
     两个按钮 都处理事件
     **/
    static func showAlert(currentVC:UIViewController, title:String, meg:String, oneBtn:String, otherBtn:String?,oneHandler:((UIAlertAction) -> Void)?, otherHandler:((UIAlertAction) -> Void)?){
        var title1 = ""
        if title == "" ||  title == nil  {
            title1 = "温馨提示"}
        else{
            title1 = title
        }
        let alertController = UIAlertController(title:title1,
                                                message:meg ,
                                                preferredStyle: .alert)
        let cancelAction = UIAlertAction(title:oneBtn, style: .cancel, handler:{ (action) -> Void in
            oneHandler?(action)
        })
        alertController.addAction(cancelAction)
        if otherBtn != nil{
            let settingsAction = UIAlertAction(title: otherBtn, style: .default, handler: { (action) -> Void in
                otherHandler?(action)
            })
            alertController.addAction(settingsAction)
        }
        currentVC.present(alertController, animated: true, completion: nil)
    }
}
