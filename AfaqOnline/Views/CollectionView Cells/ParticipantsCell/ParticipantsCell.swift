//
//  ParticipantsCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ParticipantsCell: UICollectionViewCell {

    @IBOutlet weak var ParticipantImageView: CustomImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    func config(ImageUrl: String) {
        if ImageUrl != "" {
            guard let url = URL(string: ImageUrl) else { return }
            
            self.ParticipantImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "Instructor"))
        } else {
            self.ParticipantImageView.image = #imageLiteral(resourceName: "Instructor")
        }
    }
}
