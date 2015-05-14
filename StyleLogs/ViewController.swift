//
//  ViewController.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/01.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

let NOTFY_UPDATE_VALUE = "notifyCellDataUpdate"

class ViewController: UIViewController,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate,UICollectionViewDataSource, UIScrollViewDelegate,NADViewDelegate {

    private let statusPanelHeight:CGFloat = 150
    private let statusPanelMargin:CGFloat = 5
    private let barHeight:CGFloat = 60
    private let buttomzbarHeight:CGFloat = 44
    private var styleLogDatas:[Dictionary<String,Any>]! = []
    private var currentPage:Int = 0
    private var nadViewManually: NADView!
    private var currentCollecionCell:MainCollectionViewCell!
    private var isShowAD = true
    
    @IBOutlet weak var naviBar: UINavigationBar!
    @IBOutlet weak var bannerViewFromNib: NADView!
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
        if isShowAD == true {
            // Do any additional setup after loading the view, typically from a nib.
            self.bannerViewFromNib.setTranslatesAutoresizingMaskIntoConstraints(true)
            self.bannerViewFromNib.frame = CGRectMake(0, 0, self.view.frame.width, 50)
            bannerViewFromNib.delegate = self
        
            // コードでバナー広告を生成
            nadViewManually = NADView()
            nadViewManually.autoresizingMask = UIViewAutoresizing.FlexibleRightMargin | UIViewAutoresizing.FlexibleLeftMargin | UIViewAutoresizing.FlexibleTopMargin
        
            // 広告枠のapikey/spotidを設定(必須)
            nadViewManually.setNendID("b8fcb4074aa07e3b20349bd4aa7501bfd9c33ffe", spotID: "365711")
        
            // nendSDKログ出力の設定(任意)
            nadViewManually.isOutputLog = true
        
            // delegateを受けるオブジェクトを指定(必須)
            nadViewManually.delegate = self
        
            // 読み込み開始(必須)
            nadViewManually.load()
            self.naviBar.setTranslatesAutoresizingMaskIntoConstraints(true)

            self.naviBar.frame = CGRectMake(0, 50+16, self.view.frame.width, 44)

        }else{
            self.naviBar.setTranslatesAutoresizingMaskIntoConstraints(true)
            
            self.naviBar.frame = CGRectMake(0, 16, self.view.frame.width, 44)
        }
        self.StatusPanel.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.StatusPanel.frame = CGRectMake(statusPanelMargin,self.view.frame.height - statusPanelHeight-2*statusPanelMargin-buttomzbarHeight,self.view.frame.width-2*statusPanelMargin, statusPanelHeight)
        self.collectionView.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.collectionView.showsHorizontalScrollIndicator = false
        if isShowAD == true {
            self.collectionView.frame = CGRectMake(0,barHeight+50,self.view.frame.width, self.view.frame.height-barHeight-statusPanelHeight-2*statusPanelMargin-buttomzbarHeight-50)
        }else{
            self.collectionView.frame = CGRectMake(0,barHeight,self.view.frame.width, self.view.frame.height-barHeight-statusPanelHeight-2*statusPanelMargin-buttomzbarHeight)
        }
        setupDateData()
        seupPanelInfo()
        currentPage = styleLogDatas.count-1
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "GetValue", name: NOTFY_UPDATE_VALUE, object:nil)
        
    }
    
    deinit{
        
        // delegateには必ずnilセットして解放する
        bannerViewFromNib.delegate = nil
        bannerViewFromNib = nil
        
        nadViewManually.delegate = nil
        nadViewManually = nil
    }

    func GetValue() {
        styleLogDatas = nil
        let dataManager = DataMngr.sharedInstance
        styleLogDatas = dataManager.selectAll()
        self.collectionView.reloadData()
        seupPanelInfo()
    }
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if isShowAD == true {
            // 再開
            bannerViewFromNib.resume()
            nadViewManually.resume()
        
            // 注意：他アプリ起動から、自アプリが復帰した際に広告のリフレッシュを再開するには
            // AppDelegate applicationWillEnterForeground などを利用してください
        
            // 画面下部に広告を表示させる場合

            nadViewManually.frame = CGRect(x: (self.view.frame.size.width - 320)/2, y: 16, width: 320, height: 50)

        }
    }
    // この画面が隠れたら、広告のリフレッシュを中断します
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        if isShowAD == true{
            // 中断
            bannerViewFromNib.pause()
            nadViewManually.pause()
        
            // 注意：safariなど他アプリが起動し自分自身が背後に回った際に広告のリフレッシュを中止するには
            // AppDelegate applicationDidEnterBackground などを利用してください
        }
    }

    override func shouldAutorotate() -> Bool {
        return false
    }
    override func viewDidLayoutSubviews() {
        setupDateData()
        let offset = styleLogDatas.count
        movePage(currentPage)
        if offset-1 == currentPage {
            nextButton.enabled = false
        }
        if currentCollecionCell != nil {
            currentCollecionCell.updateTableView()
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewDidAppear(animated: Bool) {
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "GetValue", name: NOTFY_UPDATE_VALUE, object:nil)
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
                //println("\(dict.description)")
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
        var value = dataManager.averageWeigh
        if value == -1 {
            averageWeightLabel.text = "--"
        }else{
            averageWeightLabel.text = String(format: "%.2f", arguments: [dataManager.averageWeigh])
        }
        value = dataManager.averageBodyFat
        if value == -1 {
            averageBodyFatLabel.text = "--"
        }else{
            averageBodyFatLabel.text = String(format: "%.1f", arguments: [dataManager.averageBodyFat])
        }
        value = dataManager.personalTargetWeight
        if value == -1 {
            targetWeightLabel.text = "--"
        }else{
            targetWeightLabel.text = String(format: "%.2f", arguments: [dataManager.personalTargetWeight])
        }
        value = dataManager.personalTargetBodyFat
        if value == -1 {
            targetBodyFaatLabel.text = "--"
        }else{
            targetBodyFaatLabel.text = String(format: "%.1f", arguments: [dataManager.personalTargetBodyFat])
        }
        value = dataManager.BMI
        if value == -1 {
            BMILabel.text = "--"
        }else{
            BMILabel.text = String(format: "%.1f", arguments: [dataManager.BMI])
        }
        value = dataManager.remainWeight
        if value == -1 {
            remainWeightLabel.text = "--"
        }else{
            remainWeightLabel.text = String(format: "%.2f", arguments: [dataManager.remainWeight])
        }
        value = dataManager.remainFatRate
        if value == -1 {
            remainBodyFatLabel.text = "--"
        }else{
            remainBodyFatLabel.text = String(format: "%.1f", arguments: [dataManager.remainFatRate])
        }
        value = dataManager.achievement
        if value == -1 {
            achivementLabel.text = "--"
        }else{
            achivementLabel.text = String(format: "%.2f", arguments: [dataManager.achievement])
        }
        
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
        cell.setupStyleData( styleLogDatas[indexPath.row] as Dictionary<String,Any>, rect: CGRectMake(self.collectionView.frame.origin.x, self.collectionView.frame.origin.y, self.collectionView.frame.width, self.collectionView.frame.height))
        println("cellForTtemAtIndex: \(indexPath.row)")
        cell.updateTableView()
        currentCollecionCell = cell
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

    func nadViewDidFinishLoad(adView: NADView!) {
        if isShowAD == true {
            if (adView == bannerViewFromNib){
                println("nadViewDidFinishLoad,bannerViewFromNib:\(adView)")
            }else if (adView == nadViewManually){
                println("nadViewDidFinishLoad,nadViewManually:\(adView)")
            
                // 広告の受信と表示の成功が通知されてからViewを乗せる場合はnadViewDidFinishLoadを利用します。
                self.view.addSubview(nadViewManually)
            }else{
            
            }
        }
    }

}

