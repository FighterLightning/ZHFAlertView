//
//  ViewController.swift
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
import UIKit
//设备物理尺寸
let ScreenHeight = UIScreen.main.bounds.size.height
let ScreenWidth = UIScreen.main.bounds.size.width
class ViewController: UIViewController {
    var tableView:UITableView!
    lazy var dataMarr:NSMutableArray = NSMutableArray()
    var popImageView: PopImageView = PopImageView()
    var popTextView: PopTextView = PopTextView()
    var popRadioButtonView: PopRadioButtonView = PopRadioButtonView()
    var popCheckboxButtonView: PopCheckboxButtonView = PopCheckboxButtonView()
    var popTopOrBottomOutView: PopTopOrBottomOutView = PopTopOrBottomOutView()
    var popSomeColorView: PopSomeColorView = PopSomeColorView()
    var slideWhiteViewSubView: SlideWhiteViewSubView = SlideWhiteViewSubView()
    //拆开一个盒子的动画效果
    var popAwayOpenView : PopAwayOpenBackGroundView =  PopAwayOpenBackGroundView() //gif背景图
    var openBoxView : OpenBoxView! //盒子打开动画效果图
    var calendarView: CalendarView = CalendarView()
    var progressBar: PopProgressBar! //进度条
    var displayLink: CADisplayLink! //定时器
    var currentValue: CGFloat = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "自定义几种提示框"
        self.addTableView()
        self.dataMarr = ["一个按钮，无点击事件",
        "一个按钮，有点击事件",
        "两个按钮，有点击事件",
        "提示框由小变大弹出（带图片）",
        "提示框由小变大弹出（带输入框）",
        "提示框由小变大弹出（单选按钮）",
        "提示框由小变大弹出（多选按钮）",
        "商品落入盒子的效果",
        "商品弹出盒子的效果",
        "有序弹出一堆框",
        "弹出一个带列表的左滑框",
        "弹出一个带列表的右滑框",
        "弹出一个带有gif背景图的拆产品",
        "模拟进度条",
        "单选病情",]
    }
    func addTableView(){
        tableView = UITableView.init(frame: CGRect.init(x: 0, y: 44, width: ScreenWidth, height: ScreenHeight - 44), style: UITableViewStyle.plain)
        self.view.addSubview(tableView)
        tableView.backgroundColor = ZHFColor.zhff9_backGroundColor
        tableView.separatorColor = ZHFColor.initString(hex: "cccccc")
        tableView.separatorInset = UIEdgeInsets.init(top: 0, left: 25, bottom: 0, right: 0)
        tableView.delegate = self
        tableView.dataSource = self
    }
}
extension ViewController :UITableViewDataSource,UITableViewDelegate
{
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataMarr.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let alertCellIdentifier  = "alertCellIdentifier"
        var cell = tableView.dequeueReusableCell(withIdentifier: alertCellIdentifier)
        if cell == nil {
            cell = UITableViewCell(style:.default, reuseIdentifier: alertCellIdentifier)
        }
        cell?.textLabel?.text = self.dataMarr[indexPath.row] as? String
        cell?.textLabel?.font = UIFont.systemFont(ofSize: 13)
        cell?.textLabel?.textColor = ZHFColor.zhf_randomColor()
        cell?.selectionStyle = UITableViewCellSelectionStyle.none
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = self.dataMarr[indexPath.row] as! String
        if indexPath.row == 0 {
            // 一个按钮，无点击事件
            ZHFAlertControllerTool.showAlert(currentVC: self, title: "", meg: message, cancelBtn: "确定")
        }
        else if indexPath.row == 1 {
            // 一个按钮，有点击事件
            ZHFAlertControllerTool.showAlert(currentVC: self, title: "提示", meg: message, okBtn: "点击跳页", handler: { (_) in
                let oneVC: OneVC = OneVC()
                self.navigationController?.pushViewController(oneVC, animated: true)
            })
        }
        else if indexPath.row == 2 {
            //两个按钮，有点击事件
            ZHFAlertControllerTool.showAlert(currentVC: self, title: "最美提示", meg: message, oneBtn: "跳页", otherBtn:  "取消", oneHandler: { (_) in
                self.oneBtnClick(btn: UIButton())
            }, otherHandler: { (_) in
                //取消按钮要处理事件
            })
        }
        else if indexPath.row == 3 {
            //带图片的弹框
        self.popImageView.addAnimate()
            self.popImageView.oneBtn.addTarget(self, action: #selector(self.oneBtnClick), for: UIControlEvents.touchUpInside)
            self.popImageView.otherBtn.addTarget(self, action: #selector(self.otherBtnClick), for: UIControlEvents.touchUpInside)
        }
        else if indexPath.row == 4{
           //带输入框的弹框
            self.popTextView.whiteViewEndFrame = CGRect.init(x: 20, y: 100, width: ScreenWidth - 40, height: ScreenHeight - 300)
            self.popTextView.addAnimate()
            self.popTextView.textStr = message
            self.popTextView.oneBtn.addTarget(self, action: #selector(self.oneBtn4Click), for: UIControlEvents.touchUpInside)
            self.popTextView.otherBtn.addTarget(self, action: #selector(self.otherBtn4Click), for: UIControlEvents.touchUpInside)
        }
        else if indexPath.row == 5{
            //单选框的弹框
            self.popRadioButtonView.whiteViewEndFrame = CGRect.init(x: 20, y: 100, width: ScreenWidth - 40, height: ScreenHeight - 300)
            self.popRadioButtonView.contentArr = ["小炒肉","宫爆鸡丁","炒肉","油麦菜","大白菜","蚂蚁上树","西红柿炒鸡蛋","鱼香肉丝","糖醋排骨"]
            self.popRadioButtonView.addAnimate()
            self.popRadioButtonView.delegate = self
        }
        else if indexPath.row == 6{
            //多选框的弹框
            self.popCheckboxButtonView.whiteViewEndFrame = CGRect.init(x: 20, y: 100, width: ScreenWidth - 40, height: ScreenHeight - 300)
            self.popCheckboxButtonView.contentArr = ["小炒肉","宫爆鸡丁","炒肉","油麦菜","大白菜","蚂蚁上树","西红柿炒鸡蛋","鱼香肉丝","糖醋排骨"]
            self.popCheckboxButtonView.addAnimate()
            self.popCheckboxButtonView.delegate = self
        }
        else if indexPath.row == 7{
            //从下向上
           self.popTopOrBottomOutView.topOrBottomViewStartFrame = CGRect.init(x: 25, y: ScreenHeight, width: ScreenWidth - 50, height: 500)
           self.popTopOrBottomOutView.addAnimateFromBottom()
        }
        else if indexPath.row == 8{
            //从上向下
            self.popTopOrBottomOutView.topOrBottomViewStartFrame = CGRect.init(x: 25, y: -ScreenHeight, width: ScreenWidth - 50, height: 500)
            self.popTopOrBottomOutView.addAnimateFromTop()
        }
        else if indexPath.row == 9{
            //有序弹出一堆框
            self.popSomeColorView.addAnimate()
            self.popSomeColorView.delegate = self;
            //实现回调，获取回调回来的值 （闭包）
            self.popSomeColorView.backClosure = {
                (backStr: String) -> Void in
                let redVC: RedVC = RedVC()
                redVC.message = backStr
                self.navigationController?.pushViewController(redVC, animated: true)
            }
        }
        else if indexPath.row == 10{
            //弹出一个带列表的左滑框
            slideWhiteViewSubView.isfromLeft = true //从左边滑出
            let whiteViewWidth = ScreenWidth*3/4
            slideWhiteViewSubView.whiteViewStartFrame = CGRect.init(x: -whiteViewWidth, y: 0, width: whiteViewWidth, height: ScreenHeight)
            slideWhiteViewSubView.whiteViewEndFrame = CGRect.init(x: 0, y: 0, width: whiteViewWidth, height: ScreenHeight)
            slideWhiteViewSubView.addAnimate()
            slideWhiteViewSubView.delegate = self
        }
        else if indexPath.row == 11{
            //弹出一个带列表的右滑框
            slideWhiteViewSubView.isfromLeft = false //从右边滑出
            let whiteViewWidth = ScreenWidth*4/5
            let whiteViewHeight = ScreenHeight*8/9
            slideWhiteViewSubView.whiteViewStartFrame = CGRect.init(x: ScreenWidth, y:(ScreenHeight - whiteViewHeight)/2, width: whiteViewWidth, height: whiteViewHeight)
            slideWhiteViewSubView.whiteViewEndFrame = CGRect.init(x: ScreenWidth - whiteViewWidth, y: (ScreenHeight - whiteViewHeight)/2, width: whiteViewWidth, height: whiteViewHeight)
            slideWhiteViewSubView.addAnimate()
            slideWhiteViewSubView.delegate = self
        }
        else if indexPath.row == 12{
            //播放gif图
            self.popAwayOpenView.addAnimate()
            //当播放GIF图一半时，弹出加载的产品图   1.5 为GIF播放一半所用的时间
            if #available(iOS 10.0, *) {
                Timer.scheduledTimer(withTimeInterval: 1.5, repeats: false, block: { (_) in
                    self.popGood()
                })
            } else {
                sleep(UInt32(1.5))
                self.popGood()
            }
        }
        else if indexPath.row == 13{
            //弹出一个模拟渐变进度条
            currentValue = 0
            progressBar = PopProgressBar()
            progressBar.addAnimate(view: progressBar.initPopBackGroundView())
            displayLink = CADisplayLink.init(target: self, selector: #selector(displayLinkRun))
            displayLink.add(to: RunLoop.current, forMode: RunLoop.Mode.defaultRunLoopMode)
            progressBar.displayLink = displayLink
        }
        else if indexPath.row == 14{
            let arr = ["心率失常","一度房室传导阻滞","心率失常","一度房室传导阻滞","心率失常","一度房室传导阻滞","心率失常","一度房室传导阻滞","心率失常","心率失常","一度房室传导阻滞","心率失常","心率失常","心率失常","一度房室传导阻滞","心率失常","一度房室传导阻滞","心率失常","一度房室传导阻滞","心率失常","一度房室传导阻滞","心率失常","心率失常","一度房室传导阻滞","心率失常","心率失常"]
            let popDiseaseView: PopDiseaseView = PopDiseaseView()
            popDiseaseView.addWhiteViewContent(arr: arr as NSArray)
            popDiseaseView.addAnimate(view: popDiseaseView.initPopDiseaseView())
            popDiseaseView.clickValueClosure { (text) in
                ZHFLog(message: text)
            }
        }
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    @objc func displayLinkRun(){
        if currentValue > 1 {
            //加载完成 关闭定时器，隐藏进度条
            displayLink.invalidate()
            displayLink = nil
            progressBar.removeFromSuperview()
        }
        else{
           currentValue = currentValue + 0.005;
           progressBar.passValue(currentValue: currentValue, allValue: 1.0)
        }
    }
}
extension ViewController{
    @objc func oneBtnClick(btn:UIButton){
        //先移除弹出来的图
        if self.popImageView != nil {
             self.popImageView.removeFromSuperview()
        }
        let oneVC: OneVC = OneVC()
        self.navigationController?.pushViewController(oneVC, animated: true)
    }
    @objc func otherBtnClick(btn:UIButton){
        //先移除弹出来的图
        if self.popImageView != nil {
            self.popImageView.removeFromSuperview()
        }
        let twoVC: TwoVC = TwoVC()
        self.navigationController?.pushViewController(twoVC, animated: true)
    }
    @objc func oneBtn4Click(btn:UIButton){
        self.dataMarr.replaceObject(at: 4, with: self.popTextView.textView.text)
        self.popTextView.tapBtnAndcancelBtnClick()
        let indexPath: IndexPath = NSIndexPath.init(row: 4, section: 0) as IndexPath
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    @objc func otherBtn4Click(btn:UIButton){
       self.popTextView.tapBtnAndcancelBtnClick()
    }
    //弹出加载的产品图
    @objc func popGood(){
        self.openBoxView = OpenBoxView()
        self.openBoxView.backgroundColor1 = UIColor.init(red: 0, green: 0, blue: 0, alpha: 0)
        self.popAwayOpenView.addSubview(self.openBoxView.initPopBackGroundView())
        self.openBoxView.addAnimate()
    }
}
extension ViewController:PopRadioButtonViewDelegate,PopCheckboxButtonViewDelegate,PopSomeColorViewDelegate,SlideWhiteViewSubViewDelegate{
      //PopRadioButtonViewDelegate
    func selectBtnMessage(content: String) {
        self.dataMarr.replaceObject(at: 5, with: content)
        self.popRadioButtonView.tapBtnAndcancelBtnClick()
        let indexPath: IndexPath = NSIndexPath.init(row: 5, section: 0) as IndexPath
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
      //PopCheckboxButtonViewDelegate
    func selectMessage(contentMarr: NSMutableArray) {
        var content :String = ""
        for i in 0 ..< contentMarr.count {
            content.append("  \(contentMarr[i] as! String)")
        }
        self.dataMarr.replaceObject(at: 6, with: content)
        self.popCheckboxButtonView.tapBtnAndcancelBtnClick()
        let indexPath: IndexPath = NSIndexPath.init(row: 6, section: 0) as IndexPath
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
     //PopSomeColorViewDelegate
    func selectBtnTag(btnTag:NSInteger) {
        self.dataMarr.replaceObject(at: 9, with: "选中按钮的tag为\(btnTag)")
        let indexPath: IndexPath = NSIndexPath.init(row: 9, section: 0) as IndexPath
        tableView.reloadRows(at: [indexPath], with: UITableViewRowAnimation.none)
    }
    //SlideWhiteViewSubViewDelegate
    func selectMessage(message: String) {
        let redVC: RedVC = RedVC()
        redVC.message = message
        self.navigationController?.pushViewController(redVC, animated: true)
    }
}

