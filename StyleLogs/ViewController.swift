//
//  ViewController.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/01.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

let NOTFY_UPDATE_VALUE = "notifyCellDataUpdate"

class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate {

    private let statusPanelHeight:CGFloat = 150
    private let statusPanelMargin:CGFloat = 5
    private let barHeight:CGFloat = 60
    private let buttomzbarHeight:CGFloat = 44
    private var styleLogDatas:[Dictionary<String,Any>]! = []
    private var currentPage:Int = 0
    
    @IBOutlet weak var prevButton: UIBarButtonItem!
    @IBOutlet weak var nextButton: UIBarButtonItem!
    @IBOutlet weak var StatusPanel: GradiateView!
    @IBOutlet weak var barItem: UINavigationItem!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var averageWeightLabel: UILabel!
    @IBOutlet weak var averageBodyFatLabel: UILabel!
    @IBOutlet weak var targetWeightLabel: UILabel!
    @IBOutlet weak var targetBodyFaatLabel: UILabel!
    @IBOutlet weak var BMILabel: UILabel!
    @IBOutlet weak var remainWeightLabel: UILabel!
    @IBOutlet weak var remainBodyFatLabel: UILabel!
    @IBOutlet weak var achivementLabel: UILabel!

    
    @IBAction func nextButtonPushed(sender: AnyObject) {
        if currentPage == styleLogDatas.count-1 {
            nextButton.enabled = false
        }else{
            nextButton.enabled = true
            prevButton.enabled = true
            movePage(currentPage+1)
            if currentPage == styleLogDatas.count-1 {
                nextButton.enabled = false
            }
        }
    }
    
    @IBAction func prevButtonPushed(sender: AnyObject) {
        if currentPage == 0 {
            prevButton.enabled = false
        }else{
            prevButton.enabled = true
            nextButton.enabled = true
            movePage(currentPage-1)
            if currentPage == 0 {
                prevButton.enabled = false
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.StatusPanel.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.StatusPanel.frame = CGRectMake(statusPanelMargin,self.view.frame.height - statusPanelHeight-2*statusPanelMargin-buttomzbarHeight,self.view.frame.width-2*statusPanelMargin, statusPanelHeight)
        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.collectionView.frame = CGRectMake(0,barHeight,self.view.frame.width, self.view.frame.height-barHeight-statusPanelHeight-2*statusPanelMargin-buttomzbarHeight)
        setupDateData()
        seupPanelInfo()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "GetValue", name: NOTFY_UPDATE_VALUE, object:nil)
    }
    func GetValue() {
        styleLogDatas = nil
        let dataManager = DataMngr.sharedInstance
        styleLogDatas = dataManager.selectAll()
        self.collectionView.reloadData()
        seupPanelInfo()
    }

    override func viewDidLayoutSubviews() {
        let offset = styleLogDatas.count
        movePage(offset-1)
        nextButton.enabled = false
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidDisappear(animated: Bool) {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }

    private func movePage( offset:Int ) {
        let index:NSIndexPath! = NSIndexPath(forItem: offset, inSection: 0)
        self.collectionView.scrollToItemAtIndexPath(index, atScrollPosition: UICollectionViewScrollPosition.Left, animated: true)
        let dictionary = styleLogDatas[offset] as Dictionary<String,Any>
        let baseDate:NSDate = (dictionary["date"] as? NSDate)!
        dispTitle(baseDate)
        currentPage = offset
    }
    
    private func setupDateData() {
        let dataManager = DataMngr.sharedInstance
        styleLogDatas = dataManager.selectAll()
        
        func createIfNOtExist( soueseDate:NSDate ) {
            func IsEqualDate( date:NSDate, target:NSDate )->Bool {
                let dateFormatter = NSDateFormatter()
                dateFormatter.locale = NSLocale(localeIdentifier: "ja_JP")
                dateFormatter.dateFormat = "yyyy/MM/dd"
                let sourceDateStr = dateFormatter.stringFromDate( date )
                let targetDataDtr = dateFormatter.stringFromDate( target )
                var result:Bool
                if sourceDateStr == targetDataDtr {
                    result = true
                }else{
                    result = false
                }
                return result
            }

            var flag:Bool = false
            for dict in styleLogDatas {
                println("\(dict.description)")
                if let date:NSDate = dict["date"] as? NSDate {
                    if IsEqualDate(soueseDate, date) {
                        flag = true
                        break
                    }
                }
            }
            if flag == false {
                dataManager.add(soueseDate)
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateFormat = "YYYY/MM/dd"
                let strDate:String = dateFormatter.stringFromDate(soueseDate)
                styleLogDatas = nil
                styleLogDatas = dataManager.selectAll()
            }
        }
        var targetDay:NSDate = NSDate()
        for var i = 0; i < dataManager.startDayBeforeToday; i++ {
            createIfNOtExist(targetDay)
            let calender:NSCalendar = NSCalendar.currentCalendar()
            let dateComponents:NSDateComponents = NSDateComponents()
            dateComponents.day = -(i+1)
            targetDay = NSCalendar.currentCalendar().dateByAddingComponents(dateComponents, toDate: NSDate(), options: nil)!
        }
    }
    
    private func seupPanelInfo() {
        let dataManager = DataMngr.sharedInstance
        averageWeightLabel.text = String(format: "%.2f", arguments: [dataManager.averageWeigh])
        averageBodyFatLabel.text = String(format: "%.1f", arguments: [dataManager.averageBodyFat])
        targetWeightLabel.text = String(format: "%.2f", arguments: [dataManager.personalTargetWeight])
        targetBodyFaatLabel.text = String(format: "%.1f", arguments: [dataManager.personalTargetBodyFat])
        BMILabel.text = String(format: "%.1f", arguments: [dataManager.BMI])
        remainWeightLabel.text = String(format: "%.2f", arguments: [dataManager.remainWeight])
        remainBodyFatLabel.text = String(format: "%.1f", arguments: [dataManager.remainFatRate])
        achivementLabel.text = String(format: "%.2f", arguments: [dataManager.achievement])
        
    }
    func numberOfSectionsInCollectionView(collectionView:UICollectionView)->NSInteger{
        return 1
    }
    
    func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return styleLogDatas.count
    }
    func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let index = indexPath.row
        let cell:MainCollectionViewCell = self.collectionView.dequeueReusableCellWithReuseIdentifier("MaincollectionCell", forIndexPath: indexPath) as! MainCollectionViewCell
        cell.setupStyleData( styleLogDatas[indexPath.row] as Dictionary<String,Any> )
        println("cellForTtemAtIndex: \(indexPath.row)")
        return cell as UICollectionViewCell
    }
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let width:CGFloat = self.collectionView.bounds.width - 10
        let height:CGFloat = self.collectionView.bounds.height
        return CGSizeMake(width, height)
    }
    func scrollViewDidEndDecelerating(scrollView: UIScrollView) {
        let page = scrollView.contentOffset.x / scrollView.bounds.width
        currentPage = Int(page+0.5)
        let dictionary = styleLogDatas[currentPage] as Dictionary<String,Any>
        let baseDate:NSDate = (dictionary["date"] as? NSDate)!
        dispTitle(baseDate)
        if currentPage == styleLogDatas.count-1 {
            nextButton.enabled = false
        }else if currentPage == 0{
            prevButton.enabled = false
        }else{
            nextButton.enabled = true
            prevButton.enabled = true
        }
    }
    private func dispTitle( date:NSDate ) {
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd"
        let strDate:String = dateFormatter.stringFromDate(date)
        barItem.title = strDate
    }

}

