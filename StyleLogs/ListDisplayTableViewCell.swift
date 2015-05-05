//
//  ListDisplayTableViewCell.swift
//  StyleLogs
//
//  Created by AizawaTakashi on 2015/05/03.
//  Copyright (c) 2015年 AizawaTakashi. All rights reserved.
//

import UIKit

class ListDisplayTableViewCell: UITableViewCell {

    @IBOutlet weak var dayAverageWeight: UILabel!
    @IBOutlet weak var dayAverageFat: UILabel!
    @IBOutlet weak var morningWeight: UILabel!
    @IBOutlet weak var eveningWeight: UILabel!
    @IBOutlet weak var morningFat: UILabel!
    @IBOutlet weak var eveningFat: UILabel!
    @IBOutlet weak var deltaOneDay: UILabel!
    @IBOutlet weak var deltaImage: UIImageView!
    @IBOutlet weak var day: UILabel!
    @IBOutlet weak var dayOfWeek: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
