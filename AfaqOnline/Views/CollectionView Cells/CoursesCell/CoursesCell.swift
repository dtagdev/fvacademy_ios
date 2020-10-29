//
//  CoursesCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import AVKit

class CoursesCell: CustomCollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var instractorName: UILabel!
    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CourseTimeLabel: CustomLabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var priceLabel: UILabel!
    
    static var videoPlayer: AVPlayer? = nil
    var videoPlayerLayer: AVPlayerLayer? = nil
    var isVideoPlaying = false
    var openDetailsAction: (() -> Void)? = nil
    var openFullScreenVideo: (() -> Void)? = nil
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: CoursesCell.videoPlayer?.currentItem)
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.priceLabel.minimumScaleFactor = 0.5
    }

    @objc func playerItemDidReachEnd(notification: NSNotification) {
        CoursesCell.videoPlayer?.seek(to: CMTime.zero)
        CoursesCell.videoPlayer?.play()
    }
    func config(courseName: String, courseInstractor: String, courseTime: String, courseType: String, rating: Double, price: Double, discountPrice: Double, imageURL: String, videoURL: String) {
        if imageURL != "" {
            self.CourseImageView.isHidden = false
            self.playButton.isHidden = true
            CoursesCell.videoPlayer?.pause()
           guard let url = URL(string: "https://dev.fv.academy/public/files/" + imageURL) else  { return }
            self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "coursePicture"))
        }
        if videoURL != "" {
            self.CourseImageView.isHidden = true
            self.playButton.isHidden = false
            guard let videoURL = URL(string: videoURL) else { return }
            CoursesCell.videoPlayer = AVPlayer(url: videoURL)
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.videoPlayerLayer = AVPlayerLayer(player: CoursesCell.videoPlayer)
                    self.videoPlayerLayer?.videoGravity = .resizeAspect
                    self.videoPlayerLayer?.cornerRadius = 5
                    self.videoPlayerLayer?.masksToBounds = true
                    self.videoPlayerLayer?.frame = self.videoPlayView.layer.bounds
                    self.videoPlayView.layer.addSublayer(self.videoPlayerLayer!)
                    CoursesCell.videoPlayer?.play()
                    CoursesCell.videoPlayer?.isMuted = true
                }
            }
            isVideoPlaying = true
        }
        self.CourseNameLabel.text = courseName
        self.instractorName.text = courseInstractor
        self.CourseTimeLabel.text = "\(courseTime)mins"
        //self.courseTypeLabel.text = courseType
        self.ratingLabel.text = "\(rating)"
        if discountPrice == 0.0 {
            self.priceLabel.text = "\(price) SAR"
        } else {
            self.priceLabel.attributedText = NSAttributedString(attributedString: "\(price)".strikeThrough()) + NSAttributedString(string: " \(discountPrice) SAR")
        }
        
    }//END of Config
    
    @IBAction func PlayAction(_ sender: UIButton) {
        openFullScreenVideo?()
    }
    @IBAction func GoForDetailsAction(_ sender: UIButton) {
        openDetailsAction?()
    }
    
}
