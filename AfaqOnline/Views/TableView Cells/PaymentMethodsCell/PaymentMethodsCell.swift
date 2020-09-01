//
//  PaymentMethodsCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class PaymentMethodsCell: UITableViewCell {

    @IBOutlet weak var currentView: CustomView!
    @IBOutlet weak var creditImageView: UIImageView!
    @IBOutlet weak var cardNumberTF: UITextField!
    @IBOutlet weak var selectedImageView: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(cardImageURL: String, cardNumber: String, selected: Bool) {
        if selected {
            self.currentView.borderColor = #colorLiteral(red: 1, green: 0.5042124391, blue: 0.4857309461, alpha: 1)
            self.currentView.borderWidth = 0.5
            self.selectedImageView.isHidden = false
        } else {
            self.currentView.borderWidth = 0
            self.selectedImageView.isHidden = true
        }
        self.cardNumberTF.text = cardNumber
        self.creditImageView.image = #imageLiteral(resourceName: "visa")
//        if cardImageURL != "" {
//            guard let url = URL(string: cardImageURL) else { return }
//
//            self.creditImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "visa"))
//        } else {
//            self.creditImageView.image = #imageLiteral(resourceName: "visa")
//        }
    }
}
