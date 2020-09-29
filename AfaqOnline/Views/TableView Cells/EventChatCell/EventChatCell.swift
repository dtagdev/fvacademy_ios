//
//  EventChatCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class EventChatCell: UITableViewCell {

    @IBOutlet weak var MessageContentView: CustomView!
    @IBOutlet weak var UserImageView: CustomImageView!
    @IBOutlet weak var UserNameLabel: CustomLabel!
    @IBOutlet weak var MessageContentTV: CustomTextView!
    @IBOutlet weak var UserContentView: UIStackView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        MessageContentTV.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        MessageContentTV.isScrollEnabled = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func config(ImageUrl: String, UserName: String, Message: String, ReceiverFlag: Bool) {
        if ReceiverFlag {
            self.MessageContentView.semanticContentAttribute = .forceLeftToRight
            self.UserContentView.alignment = .leading
            MessageContentTV.textAlignment = .left
            self.UserNameLabel.text = UserName
            self.UserNameLabel.backgroundColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            self.UserNameLabel.textColor = .white
        } else {
            self.MessageContentView.semanticContentAttribute = .forceRightToLeft
            self.UserContentView.alignment = .trailing
            MessageContentTV.textAlignment = .right
            self.UserNameLabel.text = "You"
            self.UserNameLabel.backgroundColor = .clear
            self.UserNameLabel.textColor = .black
        }
        
        self.UserNameLabel.frame.size.width = self.UserNameLabel.intrinsicContentSize.width + 20
        self.MessageContentTV.text = Message
        self.MessageContentTV.sizeToFit()
        self.MessageContentTV.layoutIfNeeded()
        if ImageUrl != "" {
            guard let url = URL(string: ImageUrl) else { return }
            self.UserImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "userProfile"))
        } else {
            self.UserImageView.image = #imageLiteral(resourceName: "userProfile")
        }
        
    }
}
