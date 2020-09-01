//
//  ContentHeaderCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ContentHeaderCell: UITableViewCell {

    @IBOutlet weak var ContentHeaderLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ContentHeaderLabel.adjustsFontSizeToFitWidth = true
        ContentHeaderLabel.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(StepHeaderContent: String) {
        self.ContentHeaderLabel.text = StepHeaderContent
    }
}
