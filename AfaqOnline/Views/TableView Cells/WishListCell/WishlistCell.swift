//
//  WishlistCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class WishlistCell: UITableViewCell {
    
    @IBOutlet weak var InstructNameLabel: UILabel!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var InstructorImageView: UIImageView!
    @IBOutlet weak var CoursePriceLabel: UILabel!
   
    var deleteClosure: (() -> Void)? = nil
    var goForDetails:(() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CoursePriceLabel.adjustsFontSizeToFitWidth = true
        CoursePriceLabel.minimumScaleFactor = 0.5
        CourseNameLabel.adjustsFontSizeToFitWidth = true
        CourseNameLabel.minimumScaleFactor = 0.5
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        // Configure the view for the selected state
    }
    
    func config(InstructorImageUrl: String, CourseName: String, CourseDescription: String, CoursePrice: Double, discountedPrice: Double) {
        self.CourseNameLabel.text = CourseName
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
        
   
    }
    @IBAction func CourseDetailsAction(_ sender: UIButton) {
        goForDetails?()
    }
    
    @IBAction func DeleteAction(_ sender: CustomButtons) {
        deleteClosure?()
    }

    
}
