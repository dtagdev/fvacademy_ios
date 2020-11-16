//
//  CategoryInstractorCell.swift
//  AfaqOnline
//
//  Created by MAC on 11/5/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos


class CategoryInstractorCell: UICollectionViewCell {
    @IBOutlet weak var instrustorNameLabel: UILabel!
    @IBOutlet weak var instrustorTotatCourseLabel: UILabel!
    @IBOutlet weak var instrustorStudentAttendedLabel: UILabel!
    @IBOutlet weak var instrustorRateLabel: UILabel!
    @IBOutlet weak var instrustorRateview: CosmosView!
    @IBOutlet weak var instrustorImage: UIImageView!
    var openDetailsAction: (() -> Void)? = nil

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func config(InstructorImageURL: String, InstructorName: String,instrustorRate : Double,instrustorRateNum : Double,instrustorTotatCourse : Int ,instrustorStudentAttended : Int ) {
            if InstructorImageURL != "" {
                self.instrustorImage.image = #imageLiteral(resourceName: "HomeCategory")
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + InstructorImageURL) else { return }
                self.instrustorImage.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
            } else {
                self.instrustorImage.image = #imageLiteral(resourceName: "HomeCategory")
            }
    //        self.InstructorImageView.cornerRadius = self.frame.width / 2
            self.instrustorNameLabel.text = InstructorName
        }
    
    @IBAction func GoForDetailsAction(_ sender: UIButton) {
         openDetailsAction?()
     }
    
}
