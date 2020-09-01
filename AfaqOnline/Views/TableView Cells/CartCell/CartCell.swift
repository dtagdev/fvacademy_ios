//
//  CartCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/5/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CartCell: UITableViewCell {

    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CourseDetailsTV: UITextView!
    @IBOutlet weak var priceLabel: UILabel!
    var deleteClosure: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.translatesAutoresizingMaskIntoConstraints = false
        self.CourseDetailsTV.isScrollEnabled = false
        CourseNameLabel.adjustsFontSizeToFitWidth = true
        CourseNameLabel.minimumScaleFactor = 0.5
        priceLabel.adjustsFontSizeToFitWidth = true
        priceLabel.minimumScaleFactor = 0.5
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(courseName: String, courseDesc: String, coursePrice: Double) {
        self.CourseNameLabel.text = courseName
        self.CourseDetailsTV.text = courseDesc
        self.priceLabel.text = "\(coursePrice) SAR"
    }
    
    @IBAction func DeleteAction(_ sender: CustomButtons) {
        deleteClosure?()
    }
}
