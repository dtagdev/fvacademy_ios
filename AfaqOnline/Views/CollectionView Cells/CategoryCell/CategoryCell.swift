//
//  CategoryCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class CategoryCell: UICollectionViewCell {

    @IBOutlet weak var CategoryImageView: UIImageView!
    @IBOutlet weak var CategoryNameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        CategoryNameLabel.adjustsFontSizeToFitWidth = true
        CategoryNameLabel.minimumScaleFactor = 0.5
    }

    func config(categoryImageURL: String, categoryName: String) {
        if categoryImageURL != "" {
            self.CategoryImageView.image = #imageLiteral(resourceName: "HomeCategory")
            guard let url = URL(string: "https://dev.fv.academy/public/files/" + categoryImageURL) else { return }
            self.CategoryImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "customer"))
        } else {
            self.CategoryImageView.image = #imageLiteral(resourceName: "HomeCategory")
        }
        self.CategoryNameLabel.text = categoryName
    }
}
