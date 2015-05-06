//
//  ListDisplayViewController.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/03.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

class ListDisplayViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    /* ["id":201505,"data":[<String,Any>]] */
    private var styleLogDatas:[[Dictionary<String,Any>]] = []
    private var sectionArray:[NSInteger] = []
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let dataManager = DataMngr.sharedInstance
        let dateDatas = dataManager.selectAll()
        let calender:NSCalendar = NSCalendar.currentCalendar()
        
        for dict in dateDatas {
            let date = (dict["date"] as? NSDate)!
            let components:NSDateComponents = calender.components(NSCalendarUnit.YearCalendarUnit|NSCalendarUnit.MonthCalendarUnit, fromDate: date)
            let year:NSInteger = components.year
            let month:NSInteger = components.month
            let id = year*100+month
            var flag:Bool = false
            for (index, sectionId) in enumerate(sectionArray) {
                if id == sectionId {
                    styleLogDatas[index].append(dict)
                    flag = true
                }
            }
            if flag == false {
                sectionArray.append(id)
                var array:[Dictionary<String,Any>] = []
                array.append(dict)
                styleLogDatas.append(array)
            }
        }
    }

    override func viewDidLayoutSubviews() {
        let index:NSIndexPath = NSIndexPath(forRow: styleLogDatas[sectionArray.count-1].count-1, inSection: sectionArray.count-1)
        self.tableView.scrollToRowAtIndexPath(index, atScrollPosition: UITableViewScrollPosition.Bottom, animated: false)
    }
    override func viewDidAppear(animated: Bool) {
        tableView.reloadData()
        //scrollView.setContentOffset(
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return sectionArray.count

    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return styleLogDatas[section].count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell:ListDisplayTableViewCell = tableView.dequeueReusableCellWithIdentifier("ListDisplayCell") as! ListDisplayTableViewCell
        let dataManager = DataMngr.sharedInstance
        let data = styleLogDatas[indexPath.section][indexPath.row]
        
        let date = (data["date"] as? NSDate)!
        let calender:NSCalendar = NSCalendar.currentCalendar()
        let components:NSDateComponents = calender.components(NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.WeekdayCalendarUnit, fromDate: date)
        let day:NSInteger = components.day
        cell.day.text = String(format: "%d", arguments: [day])
        let dayWeek = components.weekday
        switch dayWeek {
        case 1:
            cell.dayOfWeek.text = "日"
        case 2:
            cell.dayOfWeek.text = "月"
        case 3:
            cell.dayOfWeek.text = "火"
        case 4:
            cell.dayOfWeek.text = "水"
        case 5:
            cell.dayOfWeek.text = "木"
        case 6:
            cell.dayOfWeek.text = "金"
        case 7:
            cell.dayOfWeek.text = "土"
        default:
            println("error")
        }
        let morningWeight = (data["weightMorning"] as? Double)!
        if morningWeight == -1 {
            cell.morningWeight.text = "--"
        }else{
            cell.morningWeight.text = String(format: "%.2f", arguments: [morningWeight])
        }
        let eveningWeight = (data["weightEvening"] as? Double)!
        if eveningWeight == -1 {
            cell.eveningWeight.text = "--"
        }else{
            cell.eveningWeight.text = String(format: "%.2f", arguments: [eveningWeight])
        }
        let morningFat = (data["bodyFatPercentageMorning"] as? Double)!
        if morningFat == -1 {
            cell.morningFat.text = "--"
        }else{
            cell.morningFat.text = String(format: "%.1f", arguments: [morningFat])
        }
        let eveingFat = (data["bodyFatPercentageEvening"] as? Double)!
        if eveingFat == -1 {
            cell.eveningFat.text = "--"
        }else{
            cell.eveningFat.text = String(format: "%.1f", arguments: [eveingFat])
        }
        let delta:Float = dataManager.onedayDelta((data["date"] as? NSDate)!)
        if delta == -1 {
            cell.deltaOneDay.text = "--"
            cell.deltaImage.image = nil
        }else{
            cell.deltaOneDay.text = String(format: "%.2f", arguments: [delta])
            if delta < 0 {
                cell.deltaImage.image = UIImage(named: "1430837614_StockIndexUp48.png")
            }else{
                cell.deltaImage.image = UIImage(named: "1430837623_StockIndexDown48.png")
            }
        }
        let averageWeight = dataManager.ondeDayAverageWeight((data["date"] as? NSDate)!)
        if averageWeight == -1 {
            cell.dayAverageWeight.text = "--"
        }else{
            cell.dayAverageWeight.text = String(format: "%.2f", arguments: [averageWeight])
        }
        let averageFat = dataManager.ondeDayAverageFat((data["date"] as? NSDate)!)
        if averageFat == -1 {
            cell.dayAverageFat.text = "--"
        }else{
            cell.dayAverageFat.text = String(format: "%.1f", arguments: [averageFat])
        }
        
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return 74.0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 30.0
    }
    func tableView(tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let id = sectionArray[section] as NSInteger
        let str = String(format: "%d", arguments: [id])
        let title:String = str.substringFromIndex(advance(str.startIndex, 4))
        return title
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
