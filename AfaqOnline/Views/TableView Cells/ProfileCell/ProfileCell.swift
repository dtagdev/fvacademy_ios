//
//  ProfileCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ProfileCell: UITableViewCell {

    @IBOutlet weak var currentViewBackGround: CustomView!
    @IBOutlet weak var NameLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    
    var nextPage:(() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if "lang".localized == "ar" {
            self.nextButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        } else {
            self.nextButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(Name: String, selected: Bool) {
        if selected {
            self.currentViewBackGround.backgroundColor = #colorLiteral(red: 0.5058823529, green: 0.5764705882, blue: 0.7254901961, alpha: 0.15)
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.NameLabel.textColor = #colorLiteral(red: 0.1333333333, green: 0.1411764706, blue: 0.3333333333, alpha: 1)
        } else {
            self.currentViewBackGround.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
            self.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
            self.NameLabel.textColor = #colorLiteral(red: 0.2431372549, green: 0.2470588235, blue: 0.4078431373, alpha: 1)
        }
        if Name == "Logout" {
            self.NameLabel.textColor = #colorLiteral(red: 0.337254902, green: 0.3882352941, blue: 1, alpha: 1)
        }
        self.NameLabel.text = Name
    }
    @IBAction func NextAction(_ sender: UIButton) {
        nextPage?()
    }
}
