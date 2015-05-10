//
//  CalendarViewController.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/03.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

class CalendarViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource {

    let margin:CGFloat = 2.0
    let weekLabelmargin:CGFloat = 5.0
    var currentDay:NSDate = NSDate()
    let dataManager = DataMngr.sharedInstance
    var styleDatas:[Dictionary<String,Any>]!
    
    @IBOutlet weak var prevButton: UIBarButtonItem!
    @IBOutlet weak var nexButton: UIBarButtonItem!
    @IBOutlet weak var navBarItem: UINavigationItem!
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var weekLabelView: UIView!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBAction func PrevButtonPushed(sender: AnyObject) {
        let addVal:NSInteger = -1
        let calender:NSCalendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addVal
        let newDate:NSDate = calender.dateByAddingComponents(dateComponents, toDate: self.currentDay, options: nil)!
        self.currentDay = newDate
        self.collectionView.reloadData()
    }
    @IBAction func nextButtonPushed(sender: AnyObject) {
        let addVal:NSInteger = 1
        let calender:NSCalendar = NSCalendar.currentCalendar()
        let dateComponents = NSDateComponents()
        dateComponents.month = addVal
        let newDate:NSDate = calender.dateByAddingComponents(dateComponents, toDate: self.currentDay, options: nil)!
        self.currentDay = newDate
        self.collectionView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(true)
        let barHeight:CGFloat = naviBar.frame.height
        let weekLabelHeight:CGFloat = weekLabelView.frame.height+15
        self.collectionView.frame = CGRectMake(0,barHeight+weekLabelHeight,self.view.frame.width, self.view.frame.height-(barHeight+weekLabelHeight))
        setupWeekLabel()
        styleDatas = dataManager.selectAll()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        styleDatas = dataManager.selectAll()
        self.collectionView.reloadData()
    }
    private func setupWeekLabel() {
        for var i=0; i<7; i++ {
            var interval:CGFloat = (view.frame.width/7)
            let startPoint = interval/2
            let xPoint = interval*CGFloat(i)+startPoint-weekLabelmargin
            let label = UILabel(frame: CGRect(x: xPoint, y: weekLabelView.frame.height/2-weekLabelmargin, width: 20, height: 10) )
            if i % 7 == 0 {
                label.textColor = UIColor.redColor()
            }else if i % 6 == 0 {
                label.textColor = UIColor.blueColor()
            }
            switch i {
            case 0:
                label.text = "日"
            case 1:
                label.text = "月"
            case 2:
                label.text = "火"
            case 3:
                label.text = "水"
            case 4:
                label.text = "木"
            case 5:
                label.text = "金"
            case 6:
                label.text = "土"
            default:
                println("error")
            }
            weekLabelView.addSubview(label)
        }
    }
    func firstDayOfMonth()->NSDate {
        let companents:NSDateComponents = NSCalendar.currentCalendar().components(NSCalendarUnit.CalendarUnitYear|NSCalendarUnit.CalendarUnitMonth|NSCalendarUnit.CalendarUnitDay, fromDate: self.currentDay)
        companents.day = 1
        let firstDateMonth:NSDate = NSCalendar.currentCalendar().dateFromComponents(companents)!
        return firstDateMonth
    }
    func dateForIndexPath(index:NSIndexPath)->(String,NSInteger) {
        let date:NSDate = self.firstDayOfMonth()
        let firstDay:NSInteger  = NSCalendar.currentCalendar().ordinalityOfUnit(NSCalendarUnit.CalendarUnitDay, inUnit: NSCalendarUnit.CalendarUnitWeekOfMonth, forDate: date)
        let dateComponents:NSDateComponents = NSDateComponents()
        dateComponents.day = index.item - (firstDay - 1)
        let tatgetDate:NSDate = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: date, options: nil)!
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "d"
        let str:String = formatter.stringFromDate(tatgetDate)
        
        let calender:NSCalendar = NSCalendar.currentCalendar()
        let componentsWeek:NSDateComponents = calender.components(NSCalendarUnit.CalendarUnitDay|NSCalendarUnit.WeekdayCalendarUnit, fromDate: tatgetDate)
        let dayWeek = componentsWeek.weekday
        
        return (str,dayWeek)
    }
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let rangeOfWeek:NSRange = NSCalendar.currentCalendar().rangeOfUnit(NSCalendarUnit.CalendarUnitWeekOfMonth, inUnit: NSCalendarUnit.CalendarUnitMonth, forDate: currentDay)
        let count = rangeOfWeek.length * 7
        
        let formatter:NSDateFormatter = NSDateFormatter()
        formatter.dateFormat = "YYYY/MM"
        let str:String = formatter.stringFromDate(currentDay)
        navBarItem.title = str
        
        return count
    }
    
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell:CalendarCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("CalendarCollectionCell", forIndexPath: indexPath) as! CalendarCollectionViewCell
        func searchDay( dateString:String )->NSDate? {
            for dict in styleDatas {
                let date = (dict["date"] as? NSDate)!
                let formatter:NSDateFormatter = NSDateFormatter()
                formatter.dateFormat = "YYYY/MM/dd"
                let str:String = formatter.stringFromDate(date)
                if dateString == str {
                    return date
                }
            }
            return nil
        }
        func dateString()->(String,Bool) {
            var flag = false
            let formatter:NSDateFormatter = NSDateFormatter()
            formatter.dateFormat = "YYYY/MM"
            var str:String = formatter.stringFromDate(currentDay)
            let (dayString, week) = dateForIndexPath( indexPath )
            let day:Int = dayString.toInt()!
            
            if day > 24 && indexPath.row < 8 {
                flag = true
                let sub = str.substringFromIndex(advance(str.startIndex, 5))
                let year = str.substringToIndex(advance(str.startIndex, 5))
                var month:Int = sub.toInt()!
                month--
                if month < 0 {
                    month = 12
                }
                if month > 0 && month < 10 {
                    str = year+String(format: "0%d", arguments: [month])
                }else{
                    str = year+String(format: "%d", arguments: [month])
                }
                
            }else if day < 7 && indexPath.row > 26 {
                flag = true
                let sub = str.substringFromIndex(advance(str.startIndex, 5))
                let year = str.substringToIndex(advance(str.startIndex, 5))
                var month:Int = sub.toInt()!
                month++
                if month < 0 {
                    month = 12
                }
                if month > 0 && month < 10 {
                    str = year+String(format: "0%d", arguments: [month])
                }else{
                    str = year+String(format: "%d", arguments: [month])
                }
                
            }
            var addStr:String
            
            if day > 0 && day < 10 {
                addStr = String(format: "/0%d", arguments: [day])
            }else{
                addStr = String(format: "/%d", arguments: [day])
            }
            let result:String = str+addStr
            return (result, flag)
            
        }

        let (dayString,week) = self.dateForIndexPath(indexPath)
        cell.dayLabel.text = dayString
        if week == 1 {
            cell.dayLabel.textColor = UIColor.redColor()
        }else if week == 7 {
            cell.dayLabel.textColor = UIColor.blueColor()
        }else{
            cell.dayLabel.textColor = UIColor.blackColor()
        }

        let (str,flag) = dateString()
        if flag == true {
            cell.backgroundColor = UIColor.grayColor()
        }else{
            cell.backgroundColor = UIColor(red: 0.9, green: 0.7, blue: 0.6, alpha: 1.0)
        }
        let date:NSDate? = searchDay(str)
        if date != nil {
            let aveWeight = dataManager.ondeDayAverageWeight(date!)
            if aveWeight == -1 {
                cell.weightLabel.text = "--"
            }else{
                cell.weightLabel.text = String(format: "%.2f", arguments: [aveWeight])
            }
            let aveFat = dataManager.ondeDayAverageFat(date!)
            if aveFat == -1 {
                cell.fatLabel.text = "--"
            }else{
                cell.fatLabel.text = String(format: "%.1f", arguments: [aveFat])
            }
        }else{
            cell.weightLabel.text = "--"
            cell.fatLabel.text = "--"
        }
        return cell as UICollectionViewCell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let w:CGFloat = self.collectionView.frame.width
        let width:CGFloat = (w - margin*8)/7
        let height:CGFloat = width*1.5
        return CGSizeMake(width, height)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsetsMake(margin,margin,margin,margin)
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return margin
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return margin
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
