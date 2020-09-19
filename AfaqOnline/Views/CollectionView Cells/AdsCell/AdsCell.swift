//
//  ImageCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Kingfisher

class AdsCell: UICollectionViewCell {

    @IBOutlet weak var ImageView: CustomView!
    @IBOutlet weak var AdImageView: UIImageView!
    var AdOpenActionClosure: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(imageTapped))
        AdImageView.isUserInteractionEnabled = true
        AdImageView.addGestureRecognizer(tapGestureRecognizer)
    }
    
    func config(Type: String, imageURL: String) {
        if Type == "Image" {
            if imageURL != "" {
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + imageURL) else { return }
                self.AdImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "pana1"))
            } else {
            self.AdImageView.image = #imageLiteral(resourceName: "pana1")
          }
        }
    }
    @objc func imageTapped()
    {
        // Your action
        AdOpenActionClosure?()
    }
}
