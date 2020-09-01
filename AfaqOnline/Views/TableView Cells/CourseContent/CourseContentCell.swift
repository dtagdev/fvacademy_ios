//
//  CourseContentCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CourseContentCell: UITableViewCell {

    @IBOutlet weak var courseContentLabel: UILabel!
    @IBOutlet weak var contentDurationLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var playAction: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        courseContentLabel.adjustsFontSizeToFitWidth = true
        courseContentLabel.minimumScaleFactor = 0.5
        contentDurationLabel.adjustsFontSizeToFitWidth = true
        contentDurationLabel.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(StepContent: String, stepDuration: String) {
        self.courseContentLabel.text = StepContent
        self.contentDurationLabel.text = stepDuration
    }
    @IBAction func playAction(_ sender: UIButton) {
        playAction?()
    }
}
