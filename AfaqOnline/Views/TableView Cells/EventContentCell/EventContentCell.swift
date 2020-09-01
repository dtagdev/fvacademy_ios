//
//  EventContentCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class EventContentCell: UITableViewCell {

    @IBOutlet weak var ContentType: UILabel!
    @IBOutlet weak var liveView: UIStackView!
    @IBOutlet weak var TimeView: UIStackView!
    @IBOutlet weak var StartTimeLabel: UILabel!
    @IBOutlet weak var EndTimeLabel: UILabel!
    @IBOutlet weak var InstructorJobLabel: UILabel!
    @IBOutlet weak var InstructorNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        ContentType.adjustsFontSizeToFitWidth = true
        ContentType.minimumScaleFactor = 0.5
        StartTimeLabel.adjustsFontSizeToFitWidth = true
        StartTimeLabel.minimumScaleFactor = 0.5
        EndTimeLabel.adjustsFontSizeToFitWidth = true
        EndTimeLabel.minimumScaleFactor = 0.5
        InstructorJobLabel.adjustsFontSizeToFitWidth = true
        InstructorJobLabel.minimumScaleFactor = 0.5
        InstructorNameLabel.adjustsFontSizeToFitWidth = true
        InstructorNameLabel.minimumScaleFactor = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(InstructorName: String, InstructorJob: String, StartTime: String, EndTime: String, ContentType: String, selected: Bool) {
        if selected {
            self.liveView.isHidden = false
            self.TimeView.isHidden = true
        } else {
            self.liveView.isHidden = true
            self.TimeView.isHidden = false
        }
        self.InstructorNameLabel.text = InstructorName
        self.InstructorJobLabel.text = InstructorJob
        self.StartTimeLabel.text = StartTime
        self.EndTimeLabel.text = EndTime
        self.ContentType.text = ContentType
    }
}
