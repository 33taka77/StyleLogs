//
//  GraphViewController.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/04.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

class GraphViewController: UIViewController {

    var styleDatas:[Dictionary<String,Any>]!
    var currentDayFromToday:Int = 0
    var axisLabel:[String] = []
    var morningData:[CGFloat] = []
    var eveningData:[CGFloat] = []
    
    @IBOutlet weak var prevButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var naviItem: UINavigationItem!
    @IBOutlet weak var scaleSelector: UISegmentedControl!
    @IBOutlet weak var graphVIew: SmartGraph!
    @IBOutlet weak var kindSelector: UISegmentedControl!
    @IBOutlet weak var maxValue: NSLayoutConstraint!
    @IBOutlet weak var minValue: UILabel!
    @IBOutlet weak var maxValueLabel: UILabel!
    @IBAction func prevButtonPushed(sender: AnyObject) {
        switch scaleSelector.selectedSegmentIndex {
        case 0:
            prevWeek()
        case 1:
            prev1Month()
        case 2:
            prev3Month()
        case 3:
            pre6Month()
        case 4:
            prev1Year()
        default:
            println("error")
        }
    }
    
    @IBAction func nexButtonPushed(sender: AnyObject) {
        switch scaleSelector.selectedSegmentIndex {
        case 0:
            nextWeek()
        case 1:
            next1Month()
        case 2:
            next3Month()
        case 3:
            next6Month()
        case 4:
            next1Year()
        default:
            println("error")
        }
    }
    @IBAction func selectScale(sender: AnyObject) {
        let num = scaleSelector.selectedSegmentIndex
        switch num {
        case 0:
            currentDayFromToday = 0
            drawWeekGraph(currentDayFromToday)
        case 1:
            currentDayFromToday = 0
            draw1MonthGraph(currentDayFromToday)
        case 2:
            currentDayFromToday = 0
            draw3MonthGraph(currentDayFromToday)
        case 3:
            currentDayFromToday = 0
            draw6MonthGraph(currentDayFromToday)
        case 4:
            currentDayFromToday = 0
            draw1YearGraph(currentDayFromToday)
        default:
            println("error")
        }
    }
    @IBAction func selectKind(sender: AnyObject) {
        let dataManager = DataMngr.sharedInstance
        if kindSelector.selectedSegmentIndex == 1 {
            graphVIew.targetWeight = CGFloat(dataManager.personalTargetBodyFat)
        }else{
            graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
        }
        selectScale(sender)
    }
    func prev1Month() {
        currentDayFromToday = currentDayFromToday+30
        if currentDayFromToday+30 > styleDatas.count {
            currentDayFromToday -= 30
            return
        }
        draw1MonthGraph(currentDayFromToday)
    }
    func prev3Month() {
        currentDayFromToday = currentDayFromToday+90
        if currentDayFromToday+90 > styleDatas.count {
            currentDayFromToday -= 90
            return
        }
        draw3MonthGraph(currentDayFromToday)
    }
    func pre6Month() {
        currentDayFromToday = currentDayFromToday+180
        if currentDayFromToday+180 > styleDatas.count {
            currentDayFromToday -= 180
            return
        }
       draw6MonthGraph(currentDayFromToday)
    }
    func prev1Year() {
        currentDayFromToday = currentDayFromToday+365
        if currentDayFromToday+365 > styleDatas.count {
            currentDayFromToday -= 365
            return
        }
        draw1YearGraph(currentDayFromToday)
    }
    func prevWeek() {
        currentDayFromToday = currentDayFromToday+7
        let count = styleDatas.count
        if currentDayFromToday+7 > styleDatas.count {
            currentDayFromToday -= 7
            return
        }
        drawWeekGraph(currentDayFromToday)
    }
    
    func nextWeek() {
        currentDayFromToday = currentDayFromToday-7
        if currentDayFromToday < 0 {
            currentDayFromToday = 0
        }
        drawWeekGraph(currentDayFromToday)
    }
    func next1Month() {
        currentDayFromToday = currentDayFromToday-30
        if currentDayFromToday < 0 {
            currentDayFromToday = 0
        }
        draw1MonthGraph(currentDayFromToday)
    }
    func next3Month() {
        currentDayFromToday = currentDayFromToday-90
        if currentDayFromToday < 0 {
            currentDayFromToday = 0
        }
        draw3MonthGraph(currentDayFromToday)
    }
    func next6Month() {
        currentDayFromToday = currentDayFromToday-180
        if currentDayFromToday < 0 {
            currentDayFromToday = 0
        }
        draw6MonthGraph(currentDayFromToday)
    }
    func next1Year() {
        currentDayFromToday = currentDayFromToday-365
        if currentDayFromToday < 0 {
            currentDayFromToday = 0
        }
        draw1YearGraph(currentDayFromToday)
    }
    
    func draw1YearGraph( offsetDay:Int ) {
        var startDateString:String = ""
        var endDateString:String = ""
        
        axisLabel.removeAll(keepCapacity: false)
        morningData.removeAll(keepCapacity: false)
        eveningData.removeAll(keepCapacity: false)
        for viewItem in graphVIew.subviews {
            viewItem.removeFromSuperview()
        }
        
        let startIndex = styleDatas.count-1 - offsetDay
        if startIndex < 7 {
            return
        }
        for var i=0; i < 365; i++ {
            let dict = styleDatas[startIndex-(364-i)]
            let date:NSDate = (dict["date"] as? NSDate)!
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            let str:String = formatter.stringFromDate(date)
            let tempStr:String = str.substringFromIndex(advance(str.startIndex, 3))
            let day:Int = tempStr.toInt()!
            if day == 1{
                axisLabel.append(str)
            }
            if i == 0 {
                startDateString = str
            }else if i == 364 {
                endDateString = str
            }
            let dataManager:DataMngr = DataMngr.sharedInstance
            if kindSelector.selectedSegmentIndex == 0 {
                morningData.append(CGFloat((dict["weightMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["weightEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
            }else{
                morningData.append(CGFloat((dict["bodyFatPercentageMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["bodyFatPercentageEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetBodyFat)
            }
            graphVIew.setAxisLabel(SmartGraph.graphScale.month, labels: axisLabel)
            graphVIew.setPlot1(morningData)
            graphVIew.setPlot2(eveningData)
            graphVIew.setNeedsDisplay()
            updateStatus()
            naviItem.title = startDateString+" -- "+endDateString

        }
    }
    func draw6MonthGraph( offsetDay:Int ) {
        var startDateString:String = ""
        var endDateString:String = ""
        axisLabel.removeAll(keepCapacity: false)
        morningData.removeAll(keepCapacity: false)
        eveningData.removeAll(keepCapacity: false)
        for viewItem in graphVIew.subviews {
            viewItem.removeFromSuperview()
        }
        
        let startIndex = styleDatas.count-1 - offsetDay
        if startIndex < 7 {
            return
        }
        for var i=0; i < 180; i++ {
            let dict = styleDatas[startIndex-(179-i)]
            let date:NSDate = (dict["date"] as? NSDate)!
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            let str:String = formatter.stringFromDate(date)
            if i%14 == 0 {
                axisLabel.append(str)
            }
            if i == 0 {
                startDateString = str
            }else if i == 89 {
                endDateString = str
            }
            let dataManager:DataMngr = DataMngr.sharedInstance
            if kindSelector.selectedSegmentIndex == 0 {
                morningData.append(CGFloat((dict["weightMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["weightEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
            }else{
                morningData.append(CGFloat((dict["bodyFatPercentageMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["bodyFatPercentageEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetBodyFat)
            }
            graphVIew.setAxisLabel(SmartGraph.graphScale.month, labels: axisLabel)
            graphVIew.setPlot1(morningData)
            graphVIew.setPlot2(eveningData)
            graphVIew.setNeedsDisplay()
            updateStatus()
            naviItem.title = startDateString+" -- "+endDateString

        }
    }
    func draw3MonthGraph( offsetDay:Int ) {
        var startDateString:String = ""
        var endDateString:String = ""
        axisLabel.removeAll(keepCapacity: false)
        morningData.removeAll(keepCapacity: false)
        eveningData.removeAll(keepCapacity: false)
        for viewItem in graphVIew.subviews {
            viewItem.removeFromSuperview()
        }
        
        let startIndex = styleDatas.count-1 - offsetDay
        if startIndex < 7 {
            return
        }
        for var i=0; i < 90; i++ {
            let dict = styleDatas[startIndex-(89-i)]
            let date:NSDate = (dict["date"] as? NSDate)!
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            let str:String = formatter.stringFromDate(date)
            if i%7 == 0 {
                axisLabel.append(str)
            }
            if i == 0 {
                startDateString = str
            }else if i == 89 {
                endDateString = str
            }
           let dataManager:DataMngr = DataMngr.sharedInstance
            if kindSelector.selectedSegmentIndex == 0 {
                morningData.append(CGFloat((dict["weightMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["weightEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
            }else{
                morningData.append(CGFloat((dict["bodyFatPercentageMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["bodyFatPercentageEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetBodyFat)
            }
            graphVIew.setAxisLabel(SmartGraph.graphScale.month, labels: axisLabel)
            graphVIew.setPlot1(morningData)
            graphVIew.setPlot2(eveningData)
            graphVIew.setNeedsDisplay()
            updateStatus()
            naviItem.title = startDateString+" -- "+endDateString

        }
    }
 
    func draw1MonthGraph( offsetDay:Int ) {
        var startDateString:String = ""
        var endDateString:String = ""
        axisLabel.removeAll(keepCapacity: false)
        morningData.removeAll(keepCapacity: false)
        eveningData.removeAll(keepCapacity: false)
        for viewItem in graphVIew.subviews {
            viewItem.removeFromSuperview()
        }
        
        let startIndex = styleDatas.count-1 - offsetDay
        if startIndex < 7 {
            return
        }
        for var i=0; i < 31; i++ {
            let dict = styleDatas[startIndex-(30-i)]
            let date:NSDate = (dict["date"] as? NSDate)!
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            let str:String = formatter.stringFromDate(date)
            if i%7 == 0 {
                axisLabel.append(str)
            }
            if i == 0 {
                startDateString = str
            }else if i == 30 {
                endDateString = str
            }
            let dataManager:DataMngr = DataMngr.sharedInstance
            if kindSelector.selectedSegmentIndex == 0 {
                morningData.append(CGFloat((dict["weightMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["weightEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
            }else{
                morningData.append(CGFloat((dict["bodyFatPercentageMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["bodyFatPercentageEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetBodyFat)
            }
            graphVIew.setAxisLabel(SmartGraph.graphScale.month, labels: axisLabel)
            graphVIew.setPlot1(morningData)
            graphVIew.setPlot2(eveningData)
            graphVIew.setNeedsDisplay()
            updateStatus()
            naviItem.title = startDateString+" -- "+endDateString

        }
    }

    func drawWeekGraph( offsetDay:Int ) {
        var startDateString:String = ""
        var endDateString:String = ""
        
        axisLabel.removeAll(keepCapacity: false)
        morningData.removeAll(keepCapacity: false)
        eveningData.removeAll(keepCapacity: false)
        for viewItem in graphVIew.subviews {
            viewItem.removeFromSuperview()
        }
        
        let startIndex = styleDatas.count-1 - offsetDay
        if startIndex < 7 {
            return
        }
        for var i=0; i < 7; i++ {
            let dict = styleDatas[startIndex-(6-i)]
            let date:NSDate = (dict["date"] as? NSDate)!
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            let str:String = formatter.stringFromDate(date)
            if i == 0 {
                startDateString = str
            }else if i == 6 {
                endDateString = str
            }
            let dataManager:DataMngr = DataMngr.sharedInstance
            axisLabel.append(str)
            if kindSelector.selectedSegmentIndex == 0 {
                morningData.append(CGFloat((dict["weightMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["weightEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
            }else{
                morningData.append(CGFloat((dict["bodyFatPercentageMorning"] as? Double)!))
                eveningData.append(CGFloat((dict["bodyFatPercentageEvening"] as? Double)!))
                graphVIew.targetWeight = CGFloat(dataManager.personalTargetBodyFat)
            }
            graphVIew.setAxisLabel(SmartGraph.graphScale.week, labels: axisLabel)
            graphVIew.setPlot1(morningData)
            graphVIew.setPlot2(eveningData)
            graphVIew.setNeedsDisplay()
            updateStatus()
            naviItem.title = startDateString+" -- "+endDateString
        }
    }
    func CalcMaxValue()->Float {
        var max:Float = 0
        for var i = 0; i < morningData.count; i++ {
            if max < Float(morningData[i]) {
                max = Float(morningData[i])
            }
            if max < Float(eveningData[i]) {
                max = Float(eveningData[i])
            }
        }
        return max
    }
    func CalcMinValue()->Float {
        //var min:Float = Float(morningData[0])
        var min:Float = CalcMaxValue()
        for var i = 0; i < morningData.count; i++ {
            if morningData[i] != -1 {
                if min > Float(morningData[i]) {
                    min = Float(morningData[i])
                }
            }
            if eveningData[i] != -1{
                if min > Float(eveningData[i]) {
                    min = Float(eveningData[i])
                }
            }
        }
        return min
    }

    func updateStatus() {
        let maxV:Float = CalcMaxValue()
        maxValueLabel.text = String(format: "%.2f", arguments: [maxV])
        let minV:Float = CalcMinValue()
        minValue.text = String(format: "%.2f", arguments: [minV])
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        scaleSelector.selectedSegmentIndex = 0
        kindSelector.selectedSegmentIndex = 0
        let dataManager:DataMngr = DataMngr.sharedInstance
        styleDatas = dataManager.selectAll()
        drawWeekGraph(0)
        let dataCount = styleDatas.count
        if dataCount < 31 {
            scaleSelector.setEnabled(false , forSegmentAtIndex: 1)
            scaleSelector.setEnabled(false , forSegmentAtIndex: 2)
            scaleSelector.setEnabled(false, forSegmentAtIndex: 3)
            scaleSelector.setEnabled(false, forSegmentAtIndex: 4)
        }else if dataCount < 90 {
            scaleSelector.setEnabled(false , forSegmentAtIndex: 2)
            scaleSelector.setEnabled(false, forSegmentAtIndex: 3)
            scaleSelector.setEnabled(false, forSegmentAtIndex: 4)
        }else if dataCount < 180 {
            scaleSelector.setEnabled(false, forSegmentAtIndex: 3)
            scaleSelector.setEnabled(false, forSegmentAtIndex: 4)
        }else if dataCount < 365 {
            scaleSelector.setEnabled(false, forSegmentAtIndex: 4)
        }
        updateStatus()
        /*
        let startIndex = styleDatas.count-1
        for var i=0; i < 7; i++ {
            let dict = styleDatas[startIndex-(6-i)]
            let date:NSDate = (dict["date"] as? NSDate)!
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "MM/dd"
            let str:String = formatter.stringFromDate(date)
            axisLabel.append(str)
            morningData.append(CGFloat((dict["weightMorning"] as? Double)!))
            eveningData.append(CGFloat((dict["weightEvening"] as? Double)!))
            graphVIew.setAxisLabel(SmartGraph.graphScale.week, labels: axisLabel)
            graphVIew.setPlot1(morningData)
            graphVIew.setPlot2(eveningData)
            graphVIew.setNeedsDisplay()
            graphVIew.targetWeight = CGFloat(dataManager.personalTargetWeight)
        }
        */
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let dataManager:DataMngr = DataMngr.sharedInstance
        styleDatas = dataManager.selectAll()
        graphVIew.setNeedsDisplay()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
