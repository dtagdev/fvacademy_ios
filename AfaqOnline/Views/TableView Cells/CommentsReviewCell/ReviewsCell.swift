//
//  TableViewCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class ReviewsCell: UITableViewCell {

    @IBOutlet weak var UserImageView: CustomImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var UserRatingLabel: UILabel!
    @IBOutlet weak var CommentTV: CustomTextView!
    @IBOutlet weak var rateView: UIView!

    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.UserNameLabel.adjustsFontSizeToFitWidth = true
        self.UserNameLabel.minimumScaleFactor = 0.5
        self.UserRatingLabel.adjustsFontSizeToFitWidth = true
        self.UserRatingLabel.minimumScaleFactor = 0.5
        self.CommentTV.isScrollEnabled = false
        self.CommentTV.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.translatesAutoresizingMaskIntoConstraints = false
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func config(UserImageURL: String, UserName: String, UserRating: Double, UserComment: String) {
//        if UserImageURL != "" {
//            guard let url = URL(string: UserImageURL) else { return }
//
//            self.UserImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "HomeCategory"))
//        } else {
//            self.UserImageView.image = #imageLiteral(resourceName: "HomeCategory")
//        }
        self.UserImageView.image = #imageLiteral(resourceName: "HomeCategory")
        self.UserNameLabel.text = UserName
        self.UserRatingLabel.text = "\(UserRating)"
        self.CommentTV.text = UserComment
    }
}
