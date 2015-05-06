//
//  MainCollectionViewCell.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/01.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

class MainCollectionViewCell: UICollectionViewCell,UITableViewDataSource,UITableViewDelegate {
    private var styleData:Dictionary<String,Any> = [:]
    private var datas:[NSIndexPath] = []
    private var currentTableCellCount = 4
    private var clickIndex:Int = -1
    
    @IBOutlet weak var tableView: UITableView!
    
    func setupStyleData( data:Dictionary<String,Any>) {
        styleData = data
        tableView.delegate = self
        tableView.dataSource = self
        datas.removeAll(keepCapacity: false)
        for var i:Int = 0; i < currentTableCellCount; i++ {
            let index:NSIndexPath = NSIndexPath(forItem: i, inSection: 0)
            datas.append(index)
        }
        tableView.reloadData()
    }
    /*
    override init(frame: CGRect) {
        self.tableView.setTranslatesAutoresizingMaskIntoConstraints(true)
        self.tableView.frame = frame
        super.init(frame: frame)
    }

    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
*/
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let num = datas.count
        println("print")
        return datas.count
    }
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell:UITableViewCell
        if isChildCell(indexPath) {
            cell = tableView.dequeueReusableCellWithIdentifier("expandInputCell") as! UITableViewCell
            let expandCell:ValueInputTableViewCell = cell as! ValueInputTableViewCell
            switch clickIndex {
            case 0:
                expandCell.setupDataPicker(KindOfCell.morningWeight, date: styleData["date"] as! NSDate)
                expandCell.unit.text = "Kg"
            case 1:
                expandCell.setupDataPicker(KindOfCell.morningFat, date: styleData["date"] as! NSDate)
                expandCell.unit.text = "%"
            case 2:
                expandCell.setupDataPicker(KindOfCell.eveningWeight, date: styleData["date"] as! NSDate)
                expandCell.unit.text = "Kg"
            case 3:
                expandCell.setupDataPicker(KindOfCell.eveningFat, date: styleData["date"] as! NSDate)
                expandCell.unit.text = "%"
            default:
                println("error")
            }
        }else{
            cell = tableView.dequeueReusableCellWithIdentifier("valueLabelCell") as! UITableViewCell
            let topCell:ValueLabelTableViewCell = cell as! ValueLabelTableViewCell
            if clickIndex == -1 {
                switch indexPath.row {
                case 0:
                    topCell.mainLabel.text = "朝 体重"
                    topCell.unitLabel.text = "Kg"
                    println("styleDta:" + styleData.description)
                    let value:Double = (self.styleData["weightMorning"] as? Double)!
                    let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                    topCell.valueLabel.text = valStr
                    topCell.kindOfCell = KindOfCell.morningWeight
                case 1:
                    topCell.mainLabel.text = "朝 体脂肪率"
                    topCell.unitLabel.text = "%"
                    let value:Double = (styleData["bodyFatPercentageMorning"] as? Double)!
                    let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                    topCell.valueLabel.text = valStr
                    topCell.kindOfCell = KindOfCell.morningFat
                case 2:
                    topCell.mainLabel.text = "夕 体重"
                    topCell.unitLabel.text = "Kg"
                    let value:Double = (styleData["weightEvening"] as? Double)!
                    let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                    topCell.valueLabel.text = valStr
                    topCell.kindOfCell = KindOfCell.eveningWeight
                case 3:
                    topCell.mainLabel.text = "夕 体脂肪率"
                    topCell.unitLabel.text = "%"
                    let value:Double = (styleData["bodyFatPercentageEvening"] as? Double)!
                    let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                    topCell.valueLabel.text = valStr
                    topCell.kindOfCell = KindOfCell.eveningFat
                default:
                    println("error")
                }
            }else{
                switch clickIndex {
                case 0:
                    switch indexPath.row {
                    case 0:
                        topCell.mainLabel.text = "朝 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningWeight
                    case 2:
                        topCell.mainLabel.text = "朝 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningFat
                    case 3:
                        topCell.mainLabel.text = "夕 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningWeight
                    case 4:
                        topCell.mainLabel.text = "夕 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningFat
                    default:
                        println("error")
                    }
                case 1:
                    switch indexPath.row {
                    case 0:
                        topCell.mainLabel.text = "朝 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningWeight
                    case 1:
                        topCell.mainLabel.text = "朝 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningFat
                    case 3:
                        topCell.mainLabel.text = "夕 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningWeight
                    case 4:
                        topCell.mainLabel.text = "夕 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningFat
                    default:
                        println("error")
                    }
                case 2:
                    switch indexPath.row {
                    case 0:
                        topCell.mainLabel.text = "朝 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningWeight
                    case 1:
                        topCell.mainLabel.text = "朝 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningFat
                    case 2:
                        topCell.mainLabel.text = "夕 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningWeight
                    case 4:
                        topCell.mainLabel.text = "夕 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningFat
                    default:
                        println("error")
                    }
                case 3:
                    switch indexPath.row {
                    case 0:
                        topCell.mainLabel.text = "朝 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningWeight
                    case 1:
                        topCell.mainLabel.text = "朝 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageMorning"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.morningFat
                    case 2:
                        topCell.mainLabel.text = "夕 体重"
                        topCell.unitLabel.text = "Kg"
                        let value:Double = (styleData["weightEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 2)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningWeight
                    case 3:
                        topCell.mainLabel.text = "夕 体脂肪率"
                        topCell.unitLabel.text = "%"
                        let value:Double = (styleData["bodyFatPercentageEvening"] as? Double)!
                        let valStr = convertFloatToString(value, numOfUnderPoint: 1)
                        topCell.valueLabel.text = valStr
                        topCell.kindOfCell = KindOfCell.eveningFat
                    default:
                        println("error")
                    }
                default:
                    println("error")
                }
            }
        }
        //var cell:UITableViewCell
        return cell
    }
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        let cell:UITableViewCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath)
        var height:CGFloat
        if isChildCell(indexPath) {
            height = 170
        }else{
            height = 50
        }
        return height
    }
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        if isChildCell(indexPath) {
            return
        }else{
            self.tableView.beginUpdates()
            if clickIndex == indexPath.row {
                /*
                let val = getValueToLabel( tableView, indexPath: indexPath )
                let cell:ValueLabelTableViewCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! ValueLabelTableViewCell
                let dataManager = DataMngr.sharedInstance
                let date:NSDate = (styleData["date"] as? NSDate)!
                switch cell.kindOfCell {
                case .morningWeight:
                    dataManager.update(["weightMorning":val], targetDate: date)
                case .morningFat:
                    dataManager.update(["bodyFatPercentageMorning":val], targetDate: date)
                case .eveningWeight:
                    dataManager.update(["weightEvening":val], targetDate: date)
                case .eveningFat:
                    dataManager.update(["bodyFatPercentageEvening":val], targetDate: date)
                default:
                    println("error")
                }
                */
                closeCell(indexPath.row)
                clickIndex = -1
                NSNotificationCenter.defaultCenter().postNotificationName(NOTFY_UPDATE_VALUE, object: nil)
            }else{
                if clickIndex > -1 {
                    closeCell(clickIndex)
                }
                if clickIndex > -1 && indexPath.row > clickIndex {
                    clickIndex = indexPath.row-1
                }else{
                    clickIndex = indexPath.row
                }
                openCell(clickIndex)
            }
            self.tableView.endUpdates()
            //let cell:ValueLabelTableViewCell = self.tableView(tableView, cellForRowAtIndexPath: indexPath) as! ValueLabelTableViewCell
            //cell.valueLabel.text = "yyyyy"
        }
    }
    
    private func closeCell( index:Int ) {
        let removeIndexPath:NSIndexPath = NSIndexPath(forItem: index+1, inSection: 0)
        var removePaths:NSMutableArray = NSMutableArray()
        removePaths.addObject(removeIndexPath)
        self.tableView.deleteRowsAtIndexPaths(removePaths as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
        datas.removeAtIndex(index)
        currentTableCellCount = datas.count
        /*
        for var index:Int = 0; index < datas.count; index++ {
        if datas[index] as NSIndexPath == removeIndexPath {
        datas.removeAtIndex(index)
        currentDataCount = datas.count
        }
        }
        */
    }
    private func openCell( index:Int ) {
        let insertIndexPath:NSIndexPath = NSIndexPath(forItem: index+1, inSection: 0)
        var insertPaths:NSMutableArray = NSMutableArray()
        insertPaths.addObject(insertIndexPath)
        self.tableView.insertRowsAtIndexPaths(insertPaths as [AnyObject], withRowAnimation: UITableViewRowAnimation.Fade)
        datas.append(insertIndexPath)
        currentTableCellCount = datas.count
    }
    
    private func getValueToLabel( tableView:UITableView, indexPath:NSIndexPath )->CGFloat {
        let targetIndexPath:NSIndexPath = NSIndexPath(forItem: indexPath.row+1, inSection: 0)
        let cell:ValueInputTableViewCell = self.tableView(tableView, cellForRowAtIndexPath: targetIndexPath) as! ValueInputTableViewCell
        var result:CGFloat
        var tag:Int = cell.getTag()
        if tag == 0 {
            result = cell.getWeightValue()
        }else{
            result = cell.getFatValue()
        }
        return result
    }

    private func convertFloatToString( fData:Double, numOfUnderPoint:Int )->String {
        var str:String
        if( fData != -1 ) {
            if numOfUnderPoint == 1 {
                str = String(format: "%.1f", arguments: [fData])
            }else{
                str = String(format: "%.2f", arguments: [fData])
            }
        }else{
            str = "未入力"
        }
        return str
    }
    
    private func isChildCell( index:NSIndexPath )->Bool {
        var result:Bool = false
        if clickIndex > -1 && index.row > clickIndex && index.row <= clickIndex+1 {
            result = true
        }
        return result
    }

}
