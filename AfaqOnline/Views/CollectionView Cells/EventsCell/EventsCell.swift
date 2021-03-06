//
//  EventsCell.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import AVKit

class EventsCell: CustomCollectionViewCell {

    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var EventTypeLabel: CustomLabel!
    @IBOutlet weak var EventImageView: UIImageView!
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var EventTimeLabel: CustomLabel!
    @IBOutlet weak var CourseDescriptionTextView: UITextView!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var firstImageView: CustomImageView!
    @IBOutlet weak var secondImageView: CustomImageView!
    @IBOutlet weak var thirdImageView: CustomImageView!
    @IBOutlet weak var fourthImageView: CustomImageView!
    @IBOutlet weak var priceLabel: UILabel!
    
    static var videoPlayer: AVPlayer? = nil
    var videoPlayerLayer: AVPlayerLayer? = nil
    var isVideoPlaying = false
    var openDetailsAction: (() -> Void)? = nil
    var openFullScreenVideo: (() -> Void)? = nil
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: EventsCell.videoPlayer?.currentItem)
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.priceLabel.minimumScaleFactor = 0.5
    }
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        EventsCell.videoPlayer?.seek(to: CMTime.zero)
        EventsCell.videoPlayer?.play()
    }
    func config(eventName: String, eventDesc: String, eventStartTime: String, eventEndTime: String, eventType: String, rating: Double, price: Int, discountPrice: Int, imageURL: String, videoURL: String, userImages: [String]) {
            if imageURL != "" {
                self.EventImageView.isHidden = false
                self.playButton.isHidden = true
                EventsCell.videoPlayer?.pause()
                self.EventImageView.image = #imageLiteral(resourceName: "coursePicture")
    //            guard let url = URL(string: imageURL) else  { return }
    //
    //            self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "coursePicture"))
            }
            if videoURL != "" {
                self.EventImageView.isHidden = true
                self.playButton.isHidden = false
                guard let videoURL = URL(string: videoURL) else { return }
                EventsCell.videoPlayer = AVPlayer(url: videoURL)
                DispatchQueue.global(qos: .background).async {
                    DispatchQueue.main.async {
                        self.videoPlayerLayer = AVPlayerLayer(player: CoursesCell.videoPlayer)
                        self.videoPlayerLayer?.videoGravity = .resizeAspect
                        self.videoPlayerLayer?.cornerRadius = 5
                        self.videoPlayerLayer?.masksToBounds = true
                        self.videoPlayerLayer?.frame = self.videoPlayView.layer.bounds
                        self.videoPlayView.layer.addSublayer(self.videoPlayerLayer!)
                        EventsCell.videoPlayer?.play()
                        EventsCell.videoPlayer?.isMuted = true
                    }
                    
                }
                
                isVideoPlaying = true
            }
            self.EventNameLabel.text = eventName
//            self.CourseDescriptionTextView.text = eventDesc
            self.EventTimeLabel.text = "\(eventEndTime) - \(eventEndTime)"
            self.EventTypeLabel.text = eventType
            self.ratingLabel.text = "\(rating)"
            if discountPrice == 0 {
                self.priceLabel.text = "\(price) SAR"
            } else {
                self.priceLabel.attributedText = NSAttributedString(attributedString: "\(price)".strikeThrough()) + NSAttributedString(string: " \(discountPrice) SAR")
            }
            
        }//END of Config
        
        @IBAction func PlayAction(_ sender: UIButton) {
            openFullScreenVideo?()
        }
//        @IBAction func GoForDetailsAction(_ sender: UIButton) {
//            openDetailsAction?()
//        }
}
