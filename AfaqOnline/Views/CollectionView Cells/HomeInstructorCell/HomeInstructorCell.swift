//
//  InstructorsCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class HomeInstructorCell: UICollectionViewCell {

    @IBOutlet weak var InstructorImageView: UIImageView!
    @IBOutlet weak var InstructorNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        InstructorNameLabel.adjustsFontSizeToFitWidth = true
        InstructorNameLabel.minimumScaleFactor = 0.5
    }

    func config(InstructorImageURL: String, InstructorName: String) {
        if InstructorImageURL != "" {
            self.InstructorImageView.image = #imageLiteral(resourceName: "HomeCategory")
            guard let url = URL(string: "https://dev.fv.academy/public/files/" + InstructorImageURL) else { return }
            self.InstructorImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
        } else {
            self.InstructorImageView.image = #imageLiteral(resourceName: "HomeCategory")
        }
        self.InstructorNameLabel.text = InstructorName
    }
}
