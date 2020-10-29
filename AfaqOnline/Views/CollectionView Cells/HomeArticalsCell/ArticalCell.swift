//
//  ArticalCell.swift
//  AfaqOnline
//
//  Created by MAC on 10/20/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import AVKit

class ArticalsCell : CustomCollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var instractorName: UILabel!
    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
   
    }
    
    func config(courseName: String, courseDesc: String, rating: Double ,imageURL: String) {
        if imageURL != "" {
           guard let url = URL(string: "https://dev.fv.academy/public/files/" + imageURL) else  { return }
            self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "coursePicture"))
        }
        self.CourseNameLabel.text = courseName
        self.ratingLabel.text = "\(rating)"
    
        
    }//END of Config
 
    
}
