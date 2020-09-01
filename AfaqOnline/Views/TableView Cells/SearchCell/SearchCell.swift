//
//  SearchCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class SearchCell: UITableViewCell {

    @IBOutlet weak var InstructorImageView: UIImageView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var InstructorNameLabel: UILabel!
    @IBOutlet weak var CoursePriceLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CourseNameLabel.adjustsFontSizeToFitWidth = true
        CourseNameLabel.minimumScaleFactor = 0.5
        InstructorNameLabel.adjustsFontSizeToFitWidth = true
        InstructorNameLabel.minimumScaleFactor = 0.5
        CoursePriceLabel.adjustsFontSizeToFitWidth = true
        CoursePriceLabel.minimumScaleFactor = 0.5
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(InstructorImageUrl: String, CourseName: String, InstructorName: String, CourseTime: String, CoursePrice: String, discountPrice: String) {
//        if InstructorImageUrl != "" {
//            guard let url = URL(string: InstructorImageUrl) else { return }
//
//            self.InstructorImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
//        } else {
//            self.InstructorImageView.image = #imageLiteral(resourceName: "HomeCategory")
//        }
        self.InstructorImageView.image = #imageLiteral(resourceName: "HomeCategory")
        self.CourseNameLabel.text = CourseName
        self.InstructorNameLabel.text = "\(InstructorName), \(CourseTime) Min"
        
        if Int(discountPrice) ?? 0 == 0 {
            self.CoursePriceLabel.text = "\(CoursePrice) SAR"
        } else {
            self.CoursePriceLabel.attributedText = NSAttributedString(attributedString: "\(CoursePrice)".strikeThrough()) + NSAttributedString(string: " \((Int(CoursePrice) ?? 0) - (Int(discountPrice) ?? 0)) SAR")
        }
        
    }
}
