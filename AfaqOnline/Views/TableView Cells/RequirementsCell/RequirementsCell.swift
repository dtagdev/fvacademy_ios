//
//  RequirementsCell.swift
//  AfaqOnline
//
//  Created by MAC on 11/9/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class RequirementsCell: UITableViewCell {

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
    
    func config(StepHeader : String) {
        self.ContentHeaderLabel.text = StepHeader
    }

}
