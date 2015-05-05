//
//  SettingTableViewController.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/05.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

enum KindOfInput:String {
    case height = "身長"
    case tartgetWeight = "目標体重"
    case targetBodyFat = "目標体脂肪率"
}

class SettingTableViewController: UITableViewController,UITextFieldDelegate {

    @IBAction func testButton(sender: AnyObject) {
        //showInputSheet()
    }
    @IBOutlet weak var height: UITextField!
    @IBOutlet weak var targetWeight: UITextField!
    @IBOutlet weak var targetFat: UITextField!
    @IBOutlet weak var version: UILabel!
    @IBAction func heightFieldReturned(sender: AnyObject) {
        println("")
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
        let dataManager = DataMngr.sharedInstance
        self.targetFat.text = String(format: "%.1f", arguments: [dataManager.personalTargetBodyFat])
        self.targetWeight.text = String(format: "%.2f", arguments: [dataManager.personalTargetWeight])
        self.height.text = String(format: "%.1f", arguments: [dataManager.personalHeight])
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        
        return super.numberOfSectionsInTableView(tableView)
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return super.tableView(tableView, numberOfRowsInSection: section)
    }

    func showInputSheet( kind:KindOfInput ) {
        var inputField:UITextField!
        let titleString:String = kind.rawValue
        let messageString:String = kind.rawValue+"を入力してください"
        let alertController: UIAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .Alert)
        let cancelAction:UIAlertAction = UIAlertAction(title: "Cancel",
            style: UIAlertActionStyle.Cancel,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("Cancel")
        })
        let defaultAction:UIAlertAction = UIAlertAction(title: "OK",
            style: UIAlertActionStyle.Default,
            handler:{
                (action:UIAlertAction!) -> Void in
                println("OK")
                let textFields:[UITextField] = alertController.textFields as! [UITextField]
                let textField = textFields[0]
                let dataManager = DataMngr.sharedInstance
                switch kind {
                case .height:
                    dataManager.personalHeight =  NSString(string: textField.text).floatValue
                    self.height.text = textField.text
                case .targetBodyFat:
                    let dtr = textField.text
                    println(dtr)
                    dataManager.personalTargetBodyFat =  NSString(string: textField.text).floatValue
                    self.targetFat.text = textField.text
                case .tartgetWeight:
                    dataManager.personalTargetWeight =  NSString(string: textField.text).floatValue
                    self.targetWeight.text = textField.text
                default:
                    println("error")
                }
                
        })
        alertController.addTextFieldWithConfigurationHandler({(text:UITextField!) -> Void in
            text.keyboardType = UIKeyboardType.DecimalPad
            //text.delegate = self
            println("")
        })
        alertController.addAction(cancelAction)
        alertController.addAction(defaultAction)
        presentViewController(alertController, animated: true, completion: nil)
    }

    func textFieldShouldBeginEditing(textField: UITextField) -> Bool {
        if textField == height {
            showInputSheet(KindOfInput.height)
        }else if textField == targetWeight {
            showInputSheet(KindOfInput.tartgetWeight)
        }else{
            showInputSheet(KindOfInput.targetBodyFat)
        }
        return false
    }
    func textFieldDidEndEditing(textField: UITextField) {
        println("")
    }
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        let dataManager = DataMngr.sharedInstance
        if textField == height {
            let str = textField.text
            let num:Float = NSString(string: str).floatValue
            dataManager.personalHeight = num
        }else if textField == targetWeight {
            let str = textField.text
            let num:Float = NSString(string: str).floatValue
            dataManager.personalTargetWeight = num
        }else{
            let str = textField.text
            let num:Float = NSString(string: str).floatValue
            dataManager.personalTargetBodyFat = num
        }
        textField.resignFirstResponder()
        return true
    }
    /*
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
