//
//  HomeArticalsCell.swift
//  AfaqOnline
//
//  Created by MAC on 10/20/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class HomeArticalsCell: CustomCollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
     @IBOutlet weak var articalDesc: UILabel!
     @IBOutlet weak var CourseImageView: UIImageView!
     @IBOutlet weak var CourseNameLabel: UILabel!
     
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(articalName: String, articalDesc: String, rating: Double ,imageURL: String) {
           if imageURL != "" {
              guard let url = URL(string: "https://dev.fv.academy/public/files/" + imageURL) else  { return }
               self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "coursePicture"))
           }
           self.CourseNameLabel.text = articalName
           self.ratingLabel.text = "\(rating)"
          self.articalDesc.text = articalDesc
       }//END of Config

}
