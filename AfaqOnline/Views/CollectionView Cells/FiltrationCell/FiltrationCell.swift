//
//  FiltrationCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/9/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class FiltrationCell: UICollectionViewCell {

    @IBOutlet weak var BackGroundView: CustomView!
    @IBOutlet weak var CategoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CategoryNameLabel.adjustsFontSizeToFitWidth = true
        CategoryNameLabel.minimumScaleFactor = 0.5
    }

    func config(CategoryName: String, selected: Bool) {
        if selected {
            self.CategoryNameLabel.textColor = #colorLiteral(red: 0.9525628686, green: 0.9752941728, blue: 0.9938910604, alpha: 1)
            self.BackGroundView.backgroundColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            self.BackGroundView.borderWidth = 0
        } else {
            self.CategoryNameLabel.textColor = #colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1)
            self.BackGroundView.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.BackGroundView.borderColor = #colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1)
            self.BackGroundView.borderWidth = 1
        }
        self.CategoryNameLabel.text = CategoryName
    }
}
