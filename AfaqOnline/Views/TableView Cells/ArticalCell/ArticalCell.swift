//
//  ArticalCell.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//




import UIKit

class ArticalCell: UITableViewCell {

    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CourseDetailsTV: UITextView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.translatesAutoresizingMaskIntoConstraints = false
        self.CourseDetailsTV.isScrollEnabled = false
        CourseNameLabel.adjustsFontSizeToFitWidth = true
        CourseNameLabel.minimumScaleFactor = 0.5
       
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(articalName: String, articalDesc: String) {
        self.CourseNameLabel.text = articalName
        self.CourseDetailsTV.text = articalDesc
    }
    

}
