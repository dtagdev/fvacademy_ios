//
//  AllCourseCell.swift
//  AfaqOnline
//
//  Created by MAC on 10/29/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import AVKit

class AllCourseCell: CustomCollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var instractorName: UILabel!
    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CourseTimeLabel: CustomLabel!
    @IBOutlet weak var priceLabel: UILabel!
    
    var openDetailsAction: (() -> Void)? = nil
    var openFullScreenVideo: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.priceLabel.minimumScaleFactor = 0.5
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
        CoursesCell.videoPlayer?.seek(to: CMTime.zero)
        CoursesCell.videoPlayer?.play()
    }
    func config(courseName: String, courseInstractor: String, courseTime: String, courseType: String, rating: Double, price: Double, discountPrice: Double, imageURL: String, videoURL: String) {
        if imageURL != "" {
            self.CourseImageView.isHidden = false
            CoursesCell.videoPlayer?.pause()
           guard let url = URL(string: "https://dev.fv.academy/public/files/" + imageURL) else  { return }
            self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "coursePicture"))
        }
        
        self.CourseNameLabel.text = courseName
        self.instractorName.text = courseInstractor
        self.CourseTimeLabel.text = "\(courseTime)mins"
        //self.courseTypeLabel.text = courseType
        self.ratingLabel.text = "\(rating)"
        if discountPrice == 0.0 {
            self.priceLabel.text = "\(price) SAR"
        } else {
            self.priceLabel.attributedText = NSAttributedString(attributedString: "\(price)".strikeThrough()) + NSAttributedString(string: " \(discountPrice) SAR")
        }
        
    }//END of Config
    
    @IBAction func PlayAction(_ sender: UIButton) {
        openFullScreenVideo?()
    }
    @IBAction func GoForDetailsAction(_ sender: UIButton) {
        openDetailsAction?()
    }
    
}
