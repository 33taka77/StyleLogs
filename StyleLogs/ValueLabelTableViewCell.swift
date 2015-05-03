//
//  ValueLabelTableViewCell.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/01.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

enum KindOfCell {
    case morningWeight
    case morningFat
    case eveningWeight
    case eveningFat
}

class ValueLabelTableViewCell: UITableViewCell {
    
    var kindOfCell:KindOfCell = KindOfCell.morningWeight

    @IBOutlet weak var mainLabel: UILabel!
    @IBOutlet weak var valueLabel: UILabel!
    @IBOutlet weak var unitLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
