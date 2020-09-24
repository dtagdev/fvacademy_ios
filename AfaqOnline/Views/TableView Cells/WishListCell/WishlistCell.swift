//
//  WishlistCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class WishlistCell: UITableViewCell {
    
    @IBOutlet weak var CourseDescLabel: UILabel!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var InstructorImageView: UIImageView!
    @IBOutlet weak var lastImageView: CustomImageView!
    @IBOutlet weak var thirdImageView: CustomImageView!
    @IBOutlet weak var secondImageView: CustomImageView!
    @IBOutlet weak var firstImageView: CustomImageView!
    @IBOutlet weak var CoursePriceLabel: UILabel!
    @IBOutlet weak var PriceView: CustomView!
    
    var goForDetails:(() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CoursePriceLabel.adjustsFontSizeToFitWidth = true
        CoursePriceLabel.minimumScaleFactor = 0.5
        CourseDescLabel.adjustsFontSizeToFitWidth = true
        CourseDescLabel.minimumScaleFactor = 0.5
        CourseNameLabel.adjustsFontSizeToFitWidth = true
        CourseNameLabel.minimumScaleFactor = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(InstructorImageUrl: String, CourseName: String, CourseDescription: String, CoursePrice: Double, discountedPrice: Double, EnrolledUserImageURLs: [String]) {
        self.CourseNameLabel.text = CourseName
        self.CourseDescLabel.text = CourseDescription
                if InstructorImageUrl != "" {
                    guard let url = URL(string: "https://dev.fv.academy/public/files/" + InstructorImageUrl) else {return}
                    self.InstructorImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
                } else {
                    self.InstructorImageView.image = #imageLiteral(resourceName: "HomeCategory")
                }
        if discountedPrice == 0 {
            self.CoursePriceLabel.text = "\(CoursePrice) SAR"
        } else {
            self.CoursePriceLabel.attributedText = NSAttributedString(attributedString: "\(CoursePrice)".strikeThrough()) + NSAttributedString(string: " \(discountedPrice) SAR")
        }
        
        for i in 0..<EnrolledUserImageURLs.count {
            if EnrolledUserImageURLs[i] != "" {
                guard let url = URL(string: EnrolledUserImageURLs[i]) else {
                    return
                }
                if i == 0 {
                    self.firstImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
                } else if i == 1 {
                    self.secondImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
                } else if i == 2 {
                    self.thirdImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
                } else if i == 3 {
                    self.lastImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
                }
            } else {
                if i == 0 {
                    self.firstImageView.image = #imageLiteral(resourceName: "HomeCategory")
                } else if i == 1 {
                    self.secondImageView.image = #imageLiteral(resourceName: "HomeCategory")
                } else if i == 2 {
                    self.thirdImageView.image = #imageLiteral(resourceName: "HomeCategory")
                } else if i == 3 {
                    self.lastImageView.image = #imageLiteral(resourceName: "HomeCategory")
                }
            }
        }
    }
    @IBAction func CourseDetailsAction(_ sender: UIButton) {
        goForDetails?()
    }
    
}
