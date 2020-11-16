//
//  AllArticalesCell.swift
//  AfaqOnline
//
//  Created by MAC on 11/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//



import UIKit
import AVKit

class AllArticalesCell : CustomCollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var instractorName: UILabel!
    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    
    var openDetailsAction: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
  
    }


    func config(articalName: String, articalInstractor: String, rating: Double, imageURL: String) {
        
        if imageURL != "" {
            self.CourseImageView.isHidden = false
           guard let url = URL(string: "https://dev.fv.academy/public/files/" + imageURL) else  { return }
            self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "coursePicture"))
        }
        
        self.CourseNameLabel.text = articalName
        self.instractorName.text = articalName
        self.ratingLabel.text = "\(rating)"
        
    }//END of Config
    
    @IBAction func GoForDetailsAction(_ sender: UIButton) {
        openDetailsAction?()
    }
    
}