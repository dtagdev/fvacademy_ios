//
//  SearchHeader.swift
//  AfaqOnline
//
//  Created by MAC on 11/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//



import UIKit

class SearchHeader : UITableViewCell {

    @IBOutlet weak var letterLabel: UILabel!
  
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    func config(letter: String) {
        
        self.letterLabel.text = letter
    
    }
}
