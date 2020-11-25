//
//  HelpCell.swift
//  AfaqOnline
//
//  Created by MAC on 11/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class HelpCell: UITableViewCell {

    @IBOutlet weak var answerLabel : UILabel!
   
    var showAnswert: (() -> Void)? = nil
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.translatesAutoresizingMaskIntoConstraints = false
    
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
    
    
    @IBAction func showAnswerAction(_ sender: UIButton) {
          showAnswert?()
       }
    
}
