//
//  RecommendationCoursesCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class RecommendationCoursesCell: UICollectionViewCell {

    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CourseNameLabel.adjustsFontSizeToFitWidth = true
        CourseNameLabel.minimumScaleFactor = 0.5
    }
    func config(imageURL: String, CourseName: String) {
        self.CourseNameLabel.text = CourseName
        self.CourseImageView.image = #imageLiteral(resourceName: "HomeCategory")
//        if imageURL != "" {
//            guard let url = URL(string: imageURL) else { return }
//
//            self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
//        } else {
//            self.CourseImageView.image = #imageLiteral(resourceName: "HomeCategory")
//        }
    }
}
