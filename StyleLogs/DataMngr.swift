//
//  DataMngr.swift
//  SwiftSQLite
//
//  Created by Aizawa Takashi on 2015/04/21.
//  Copyright (c) 2015年 Aizawa Takashi. All rights reserved.
//

import Foundation

class DataMngr{
    let TABLE_NAME = "StyleLog"
    var startDayBeforeToday:Int = 30
    var personalHeight:Float = 173.0
    var personalTargetWeight:Float = 75.00
    var personalTargetBodyFat:Float = 25.0

    var averageWeigh:Float {
        get {
            let list = self.selectAll()
            var totalWeight:Float = 0.0
            var counter:Int = 0
            for dict in list {
                var weight:Double = (dict["weightMorning"] as? Double)!
                if weight != -1 {
                    totalWeight += Float(weight)
                    counter++
                }
                weight = (dict["weightEvening"] as? Double)!
                if weight != -1 {
                    totalWeight += Float(weight)
                    counter++
                }
            }
            return totalWeight/Float(counter)
        }
    }
    var averageBodyFat:Float {
        get {
            let list = self.selectAll()
            var totalFat:Float = 0.0
            var counter:Int = 0
            for dict in list {
                var weight:Double = (dict["bodyFatPercentageMorning"] as? Double)!
                if weight != -1 {
                    totalFat += Float(weight)
                    counter++
                }
                weight = (dict["bodyFatPercentageEvening"] as? Double)!
                if weight != -1 {
                    totalFat += Float(weight)
                    counter++
                }
            }
            return totalFat/Float(counter)
        }
    }
    var BMI:Float {
        get {
            let list = selectAll()
            //let dict = list[list.count-1]
            var total:Float = 0.0
            var counter:Int = 0
            for var i = list.count-1; i > -1; i-- {
                let dict = list[i]
                var weight = (dict["weightMorning"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                weight = (dict["weightEvening"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                if( counter != 0 ) {
                    break
                }
            }
            let averageWeight = total/Float(counter)
            let bmi = averageWeight/(personalHeight/100 * personalHeight/100)
            return bmi
        }
    }
    var remainWeight:Float {
        get {
            let list = selectAll()
            //let dict = list[list.count-1]
            var total:Float = 0.0
            var counter:Int = 0
            for var i = list.count-1; i > -1; i-- {
                let dict = list[i]
                var weight = (dict["weightMorning"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                weight = (dict["weightEvening"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                if( counter != 0 ) {
                    break
                }
            }
            let averageWeight = total/Float(counter)
            return averageWeight-personalTargetWeight
        }
    }
    var remainFatRate:Float {
        get {
            let list = selectAll()
            //let dict = list[list.count-1]
            var total:Float = 0.0
            var counter:Int = 0
            for var i = list.count-1; i > -1; i-- {
                let dict = list[i]
                var weight = (dict["bodyFatPercentageMorning"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                weight = (dict["bodyFatPercentageEvening"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                if( counter != 0 ) {
                    break
                }
            }
            let averageRate = total/Float(counter)
            return averageRate-personalTargetBodyFat
        }
    }
    var achievement:Float {
        get {
            let list = selectAll()
            //let dict = list[list.count-1]
            var total:Float = 0.0
            var counter:Int = 0
            var max:Float = 0.0
            for var i = list.count-1; i > -1; i-- {
                let dict = list[i]
                for dict in list {
                    var weight = (dict["weightMorning"] as? Double)!
                    if weight != -1 {
                        if max < Float(weight) {
                            max = Float(weight)
                        }
                    }
                    weight = (dict["weightEvening"] as? Double)!
                    if weight != -1 {
                        if max < Float(weight) {
                            max = Float(weight)
                        }
                    }
                }
                var weight = (dict["weightMorning"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                weight = (dict["weightEvening"] as? Double)!
                if weight != -1 {
                    total += Float(weight)
                    counter++
                }
                if( counter != 0 ) {
                    break
                }
            }
            let averageWeight = total/Float(counter)
            let achive = max - averageWeight
            let bandWidth = max - personalTargetWeight
            return (achive/bandWidth) * 100.0
        }
    }
    
    private func searchDay( list:[Dictionary<String,Any>], date:NSDate )->Int {
        for (index, dict) in enumerate(list) {
            if date == (dict["date"] as? NSDate)! {
                return index
            }
        }
        return -1
    }
    func onedayDelta( today:NSDate )->Float {
            let list = selectAll()
            let index = searchDay( list, date: today )
            if index == -1 {
                return -1
            }
            var dict = list[index]
            var total:Float = 0.0
            var counter:Int = 0
            var weight = (dict["weightMorning"] as? Double)!
            if weight != -1 {
                total += Float(weight)
                counter++
            }
            weight = (dict["weightEvening"] as? Double)!
            if weight != -1 {
                total += Float(weight)
                counter++
            }
            if counter == 0 {
                return -1
            }
            let todayAve = total/Float(counter)
            dict = list[index-1]
            counter = 0
            total = 0
            weight = (dict["weightMorning"] as? Double)!
            if weight != -1 {
                total += Float(weight)
                counter++
            }
            weight = (dict["weightEvening"] as? Double)!
            if weight != -1 {
                total += Float(weight)
                counter++
            }
            if counter == 0 {
                return -1
            }
            let yesterday = total/Float(counter)
            
            return todayAve - yesterday
    }
    
    func ondeDayAverageWeight( date:NSDate )->Float {
        let list = selectAll()
        let index = searchDay( list, date: date )
        var dict = list[index]
        var total:Float = 0.0
        var counter:Int = 0
        var weight = (dict["weightMorning"] as? Double)!
        if weight != -1 {
            total += Float(weight)
            counter++
        }
        weight = (dict["weightEvening"] as? Double)!
        if weight != -1 {
            total += Float(weight)
            counter++
        }
        if counter == 0 {
            return -1
        }
        let todayAve = total/Float(counter)
        return todayAve
    }
    func ondeDayAverageFat( date:NSDate )->Float {
        let list = selectAll()
        let index = searchDay( list, date: date )
        var dict = list[index]
        var total:Float = 0.0
        var counter:Int = 0
        var weight = (dict["bodyFatPercentageMorning"] as? Double)!
        if weight != -1 {
            total += Float(weight)
            counter++
        }
        weight = (dict["bodyFatPercentageEvening"] as? Double)!
        if weight != -1 {
            total += Float(weight)
            counter++
        }
        if counter == 0 {
            return -1
        }
        let todayAve = total/Float(counter)
        return todayAve
    }
    
    init(){
        //self.deleteTable()
        if !self.isExistDataBase() {
            if !self.createTable() {
                println("error: cannot create Table")
            }
        }
        
    }
    class var sharedInstance:DataMngr {
        struct Static{
            static let instance:DataMngr = DataMngr()
        }
        return Static.instance
    }
    
    func isExistDataBase()->Bool {
        let (tables, error) = SwiftData.existingTables()
        var result:Bool = false
        if( contains(tables, TABLE_NAME) ) {
            result = true
        }else{
            result = false
        }
        return result
    }

    private func createTable()->Bool {
        var result:Bool = false
        if let error = SwiftData.createTable(TABLE_NAME, withColumnNamesAndTypes: ["date":SwiftData.DataType.StringVal, "weightMorning":SwiftData.DataType.DoubleVal, "weightEvening":SwiftData.DataType.DoubleVal, "bodyFatPercentageMorning":SwiftData.DataType.DoubleVal, "bodyFatPercentageEvening":SwiftData.DataType.DoubleVal]) {
            result = false
        }else{
            result = true
        }
        return result
    }
    
    func deleteTable() {
        SwiftData.deleteTable(TABLE_NAME)
    }
    
    func add(date:NSDate)->Bool {
        var result:Bool = false
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        let strDate:String = dateFormatter.stringFromDate(date)
        //let sql = "INSERT INTO "+TABLE_NAME+" (date,weightMorning) VALUES (?,?)"
        //let num:Double = 8.9
        let sql = "INSERT INTO "+TABLE_NAME+" (date) VALUES (?)"
        let num:Double = 8.9
        if let error = SwiftData.executeChange(sql, withArgs: [strDate]) {
            let message = SwiftData.errorMessageForCode(error)
            println(message)
        }else{
            result = true
        }
        return result
    }
    
    func update(datas:Dictionary<String,Any>, targetDate date:NSDate)->Bool {
        var result:Bool = false
        var sql = "UPDATE "+TABLE_NAME+" set "
        let keyArray = Array(datas.keys)
        for key in keyArray {
            sql += key+" = ? ,"
        }
        var startIndex:String.Index
        var endIndex:String.Index
        var len = count(sql)
        startIndex = advance(sql.startIndex,0)
        endIndex = advance(sql.startIndex,len-2)
        var newSql = sql.substringToIndex(endIndex)
        newSql += " where date = ?"
        let values: Array = Array(datas.values)
        var args:[AnyObject] = []
        for value in values {
            args.append(value as! AnyObject)
        }
        let dateFormatter = NSDateFormatter()
        dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
        let strDate:String = dateFormatter.stringFromDate(date)
        args.append(strDate)
        if let error = SwiftData.executeChange(newSql, withArgs: args) {
            let message = SwiftData.errorMessageForCode(error)
            println(message)
        }else{
            result = true
        }
        return result
    }
    
    func selectAll()->[Dictionary<String,Any>] {
        let sql = "select * from "+TABLE_NAME+" order by date asc;"
        var results:[Dictionary<String,Any>] = []
        let (fetchDatas,error) = SwiftData.executeQuery(sql)
        if error != nil {
            let message = SwiftData.errorMessageForCode(error!)
            println(message)
        }else{
            for row in fetchDatas {
                //let date:NSDate? = row["date"]?.asDate()
                let dateFormatter = NSDateFormatter()
                let dataStr = row["date"]?.asString()!
                dateFormatter.dateFormat = "YYYY/MM/dd HH:mm:ss"
                let date:NSDate = dateFormatter.dateFromString(dataStr!)!
                var weightMorning:Double
                if let vmm = row["weightMorning"]?.asDouble()! {
                    weightMorning = vmm
                }else{
                    weightMorning = -1
                }
                //let weightMorning:Double = (row["weightMorning"]?.asDouble())!
                //let weightEvening:Double? = row["weightEvening"]?.asDouble()
                var weightEvening:Double
                if let vmm = row["weightEvening"]?.asDouble()! {
                    weightEvening = vmm
                }else{
                    weightEvening = -1
                }
                //let bodyFatPercentageMorning:Double? = row["bodyFatPercentageMorning"]?.asDouble()!
                var bodyFatPercentageMorning:Double
                if let vmm = row["bodyFatPercentageMorning"]?.asDouble()! {
                    bodyFatPercentageMorning = vmm
                }else{
                    bodyFatPercentageMorning = -1
                }
                //let bodyFatPercentageEvening:Double? = row["bodyFatPercentageEvening"]?.asDouble()
                var bodyFatPercentageEvening:Double
                if let vmm = row["bodyFatPercentageEvening"]?.asDouble()! {
                    bodyFatPercentageEvening = vmm
                }else{
                    bodyFatPercentageEvening = -1
                }

                results.append(["date":date, "weightMorning":weightMorning, "weightEvening":weightEvening, "bodyFatPercentageMorning":bodyFatPercentageMorning, "bodyFatPercentageEvening":bodyFatPercentageEvening])
            }
        }
        return results
    }
}