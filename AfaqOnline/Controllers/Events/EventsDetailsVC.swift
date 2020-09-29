//
//  EventsDetailsVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa




class EventsDetailsVC: UIViewController {

    @IBOutlet weak var ScrollViewContainer: UIScrollView!
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var videoPlayerView: UIView!
    @IBOutlet weak var EventNameLabel: UILabel!
    @IBOutlet weak var PlayButton: UIButton!
    @IBOutlet weak var EventTimeLabel: UILabel!
    @IBOutlet weak var ParticipantsCollectionView: UICollectionView!
    @IBOutlet weak var WishListButton: UIButton!
    @IBOutlet weak var ShareButton: UIButton!
    @IBOutlet weak var EventDetailsBeforeStartView: UIView!
    @IBOutlet weak var EventDetailsDuringLive: CustomView!
    @IBOutlet weak var CurrentInstructorImageView: CustomImageView!
    @IBOutlet weak var CurrentInstructorTitleLabel: UILabel!
    @IBOutlet weak var CurrentInstructorNameLabel: UILabel!
    @IBOutlet weak var EventTypeLabel: UILabel!
    @IBOutlet weak var ViewersLabel: UILabel!
    @IBOutlet weak var AboutTheEventSeperator: UIView!
    @IBOutlet weak var ContentSeperator: UIView!
    @IBOutlet weak var ChatSeperator: UIView!
    @IBOutlet weak var AboutTheEventView: UIView!
    @IBOutlet weak var EventContentView: UIView!
    @IBOutlet weak var EventChatView: UIView!
    @IBOutlet weak var EventChatButton: CustomButtons!
    @IBOutlet weak var ContentTableView: CustomTableView!
    @IBOutlet weak var ChatTableView: CustomTableView!
    @IBOutlet weak var MessageTF: UITextField!
    @IBOutlet weak var coursePriceLabel: UILabel!
    @IBOutlet weak var PricingView: CustomView!
    @IBOutlet weak var FullScreenButton: CustomButtons!
    @IBOutlet weak var FullScreenShareButton: CustomButtons!
    @IBOutlet weak var videoTimeLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var eventImageView: UIImageView!
    @IBOutlet weak var introductionLable : UILabel!
    @IBOutlet weak var  introductionTexView: UITextView!
    @IBOutlet weak var  goalsLabel: UILabel!
    @IBOutlet weak var  goalsTextView : UITextView!
    static var videoPlayer: AVPlayer? = nil
    var videoPlayerLayer: AVPlayerLayer? = nil
    var isVideoPlaying = false
    var videoURL = String()
    var event_id = Int()
    var EventsVM = EventDetailsViewModel()
    var purchasedFlag = false
    var disposeBag = DisposeBag()
    var comments = [Comment](){
         didSet {
        DispatchQueue.main.async {
            self.EventsVM.fetchComments(data: self.comments)
            }
            
        }
    }
    
    var content = [Content](){
         didSet {
           DispatchQueue.main.async {
            self.EventsVM.fetchEventContent(data: self.content)
         }
        }
       }
    
    var Ads = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.EventsVM.fetchAds(Ads: self.Ads)
            }
        }
    }
    
    var participants = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.EventsVM.fetchParticipants(data: self.participants)
            }
        }
    }
    fileprivate func attemptToAssembleGroupedMessages() {
        print("attempt to group our messages together based on Date proprety")
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        searchTF.delegate = self
        MessageTF.delegate = self
        self.hideKeyboardWhenTappedAround()
        setupAdsCollectionView()
        setupParticipantsCollectionView()
        setupContentTableView()
        setupChatTableView()
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: EventsDetailsVC.videoPlayer?.currentItem)
        if videoURL != "" {
            //            self.playButton.isHidden = false
            guard let videoURL = URL(string: videoURL) else { return }
            CoursesCell.videoPlayer = AVPlayer(url: videoURL)
            DispatchQueue.global(qos: .background).async {
                DispatchQueue.main.async {
                    self.videoPlayerLayer = AVPlayerLayer(player: CoursesCell.videoPlayer)
                    self.videoPlayerLayer?.videoGravity = .resizeAspect
                    self.videoPlayerLayer?.cornerRadius = 5
                    self.videoPlayerLayer?.masksToBounds = true
                    self.videoPlayerLayer?.frame = self.videoPlayerView.layer.bounds
                    self.videoPlayerView.layer.addSublayer(self.videoPlayerLayer!)
                    CoursesCell.videoPlayer?.play()
                    CoursesCell.videoPlayer?.isMuted = true
                }
                
            }
            eventImageView.isHidden = true
            self.FullScreenButton.isHidden = false
            self.FullScreenShareButton.isHidden = false
            self.videoTimeLabel.isHidden = false
            self.PlayButton.isHidden = false
            self.isVideoPlaying = true
            self.videoPlayerView.isHidden = false
            self.EventTimeLabel.isHidden = false

        }else{
            eventImageView.isHidden = false
            self.FullScreenButton.isHidden = true
            self.FullScreenShareButton.isHidden = true
            self.videoTimeLabel.isHidden = true
            self.PlayButton.isHidden = true
            self.videoPlayerView.isHidden = true
            self.EventTimeLabel.isHidden = true

        }
        self.EventsVM.showIndicator()
        self.getEventDetails(event_id: event_id)
    }
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        EventsDetailsVC.videoPlayer?.seek(to: CMTime.zero)
        EventsDetailsVC.videoPlayer?.play()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchTF.text = ""
        self.searchTF.isHidden = true
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func SearchAction(_ sender: UIButton) {
        if self.searchTF.isHidden {
            Constants.shared.searchingEnabled = true
            self.searchTF.isHidden = false
        } else {
            Constants.shared.searchingEnabled = false
            self.searchTF.isHidden = true
        }
    }
    @IBAction func searchDidEndEditing(_ sender: CustomTextField) {
        if Constants.shared.searchingEnabled {
            guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
            main.modalPresentationStyle = .overFullScreen
            main.modalTransitionStyle = .crossDissolve
            main.search_name = self.searchTF.text ?? ""
            self.searchTF.text = ""
            self.searchTF.isHidden = true
            self.present(main, animated: true, completion: nil)
        }
    }
    @IBAction func WishlistAction(_ sender: UIButton) {
    }
    
    @IBAction func ShareAction(_ sender: UIButton) {
    }
    
    @IBAction func MultiSelectionAction(_ sender: CustomButtons) {
        switch sender.tag {
        case 1:
            self.AboutTheEventView.isHidden = false
            self.AboutTheEventSeperator.isHidden = false
            self.EventContentView.isHidden = true
            self.ContentSeperator.isHidden = true
            self.EventChatView.isHidden = true
            self.ChatSeperator.isHidden = true
        case 2:
            self.AboutTheEventView.isHidden = true
            self.AboutTheEventSeperator.isHidden = true
            self.EventContentView.isHidden = false
            self.ContentSeperator.isHidden = false
            self.EventChatView.isHidden = true
            self.ChatSeperator.isHidden = true
        case 3:
            self.AboutTheEventView.isHidden = true
            self.AboutTheEventSeperator.isHidden = true
            self.EventContentView.isHidden = true
            self.ContentSeperator.isHidden = true
            self.EventChatView.isHidden = false
            self.ChatSeperator.isHidden = false
        default:
            break
        }
    }
    @IBAction func PlayAction(_ sender: CustomButtons) {
        if purchasedFlag {
            self.FullScreenButton.isHidden = true
            self.FullScreenShareButton.isHidden = true
            self.videoTimeLabel.isHidden = true
            self.PricingView.isHidden = false
            self.EventDetailsDuringLive.isHidden = true
            self.EventDetailsBeforeStartView.isHidden = false
            self.PlayButton.setImage(#imageLiteral(resourceName: "Play"), for: .normal)
            self.ChatSeperator.isHidden = true
            self.AboutTheEventView.isHidden = false
            self.AboutTheEventSeperator.isHidden = false
        } else {
            self.FullScreenButton.isHidden = false
            self.FullScreenShareButton.isHidden = false
            self.videoTimeLabel.isHidden = false
            self.PricingView.isHidden = true
            self.EventDetailsDuringLive.isHidden = false
            self.EventDetailsBeforeStartView.isHidden = true
            self.PlayButton.setImage(#imageLiteral(resourceName: "pause"), for: .normal)
        }
        self.purchasedFlag = !self.purchasedFlag
    }
    
    
    @IBAction func MessageDidEndEditing(_ sender: UITextField) {
        if !self.MessageTF.text!.isEmpty {
            self.EventsVM.showIndicator()
            self.addComment(id: event_id, comment: self.MessageTF.text!)
        } else {
            displayMessage(title: "", message: "Please write your comment first", status: .info, forController: self)
        }
        
    }
    @IBAction func SendAction(_ sender: CustomButtons) {
        self.MessageTF.resignFirstResponder()
        self.MessageTF.text  = "" 
    }
    @IBAction func EnrollNowAction(_ sender: UIButton) {
    }
    
}

extension EventsDetailsVC {
    
    func addComment(id: Int, comment: String) {
        self.EventsVM.postAddComment(id: id,comment: comment).subscribe(onNext: { (commentModel) in
            if let _ = commentModel.data {
                self.getEventDetails(event_id: self.event_id)
                displayMessage(title: "", message: CommentRecorded.localized, status: .info, forController: self)
            } else if let errors = commentModel.errors {
             if "lang".localized == "ar" {
            displayMessage(title: "", message: "حدث خطأ ما اثناء إرسال الرسالة الخاصة بك، يرجى المحاولة في وقت لاحق", status: .error, forController: self)
            } else {
            displayMessage(title: "", message: "Something went wrong while sending your message, Please try again later", status: .error, forController: self)
            }
            }
        }, onError: { (error) in
            if "lang".localized == "ar" {
            displayMessage(title: "", message: "حدث خطأ ما اثناء إرسال الرسالة الخاصة بك، يرجى المحاولة في وقت لاحق", status: .error, forController: self)
            } else {
             displayMessage(title: "", message: "Something went wrong while sending your message, Please try again later", status: .error, forController: self)
                      }
        }).disposed(by: disposeBag)
    }
     
    func getEventDetails(event_id: Int) {
        self.EventsVM.getEventDetails(Event_id:event_id).subscribe(onNext: { (eventModel) in
                if let data = eventModel.data {
                self.EventsVM.dismissIndicator()
                self.videoURL = data.eventURL ?? ""
                self.EventNameLabel.text = data.name ?? ""
                self.introductionTexView.text = data.details ?? ""
                self.goalsTextView.text = data.eventDescription ?? ""
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + (data.mainImage ?? "") ) else { return }
                self.eventImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "DetailsImage"))
                self.coursePriceLabel.attributedText = NSAttributedString(attributedString: (data.price ?? "").strikeThrough()) + NSAttributedString(string: "\n\((Double(data.price ?? "") ?? 0.0) - (Double(data.discount ?? "") ?? 0.0)) SAR")
                    self.comments = data.comments ?? []
                    self.content = data.contents ?? []
            }
            }, onError: { (error) in
                if "lang".localized == "ar" {
                    displayMessage(title: "", message: "حدث خطأ ما، يرجى المحاولة في وقت لاحق", status: .error, forController: self)
                } else {
                    displayMessage(title: "", message: "Something went wrong , Please try again later", status: .error, forController: self)
                }
                }).disposed(by: disposeBag)
        }
    

}
extension EventsDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField == searchTF {
            self.searchTF.resignFirstResponder()
        } else {
            self.MessageTF.resignFirstResponder()
        }
        
        return true
    }
}
extension EventsDetailsVC : UICollectionViewDelegate {
    
    func setupAdsCollectionView() {
        self.Ads = ["ssd"]
        let cellIdentifier = "AdsCell"
        self.AdsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.AdsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.EventsVM.Ads.bind(to: self.AdsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AdsCell.self)) { index, element, cell in
            cell.config(Type: "Image", imageURL: "")
            cell.AdOpenActionClosure = {
                
            }
        }.disposed(by: disposeBag)
        self.AdsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupParticipantsCollectionView() {
        self.participants = ["Test", "test2"]
        let cellIdentifier = "ParticipantsCell"
        self.ParticipantsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ParticipantsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.EventsVM.Participants.bind(to: self.ParticipantsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: ParticipantsCell.self)) { index, element, cell in
            cell.config(ImageUrl: "")
        }.disposed(by: disposeBag)
        self.ParticipantsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    
}
extension EventsDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == AdsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1
            return CGSize(width: 30, height: 30)
        }
    }
}
extension EventsDetailsVC: UITableViewDelegate {
    func setupContentTableView() {
        let cellIdentifier = "EventContentCell"
        self.ContentTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ContentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.ContentTableView.rowHeight = UITableView.automaticDimension
        self.ContentTableView.estimatedRowHeight = UITableView.automaticDimension
        self.EventsVM.EventContent.bind(to: self.ContentTableView.rx.items(cellIdentifier: cellIdentifier, cellType: EventContentCell.self)) { index, element, cell in
                cell.config(InstructorName: self.content[index].instructor?.user?.firstName ?? "", InstructorJob: self.content[index].instructor?.user?.job ?? "", StartTime: self.content[index].startTime ?? "", EndTime: self.content[index].endTime ?? "", ContentType: "Live", live: self.content[index].live ?? 0)
        }.disposed(by: disposeBag)
        
        self.ContentTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.ContentTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupChatTableView() {
        let ReviewsCellIdentifier = "ReviewsCell"
        self.ChatTableView.register(UINib(nibName: ReviewsCellIdentifier, bundle: nil), forCellReuseIdentifier: ReviewsCellIdentifier)
        self.ChatTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ChatTableView.rowHeight = UITableView.automaticDimension
        self.ChatTableView.estimatedRowHeight = UITableView.automaticDimension
        self.EventsVM.EventComments.bind(to: self.ChatTableView.rx.items(cellIdentifier: ReviewsCellIdentifier, cellType: ReviewsCell.self)) { index, element, cell in
            cell.config(UserImageURL: "", UserName: "hazem", UserRating: 0, UserComment: self.comments[index].comment ?? "")
           cell.rateView.isHidden = true

        
        }.disposed(by: disposeBag)
        self.ChatTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.ChatTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
}
