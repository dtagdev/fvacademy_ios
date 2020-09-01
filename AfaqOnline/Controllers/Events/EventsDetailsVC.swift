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
    
    static var videoPlayer: AVPlayer? = nil
    var videoPlayerLayer: AVPlayerLayer? = nil
    var isVideoPlaying = false
    var videoURL = String()
    var EventsVM = EventDetailsViewModel()
    var purchasedFlag = false
    var disposeBag = DisposeBag()
    var room_id = 1
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
    var EventContent = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.EventsVM.fetchEventContent(data: self.EventContent)
            }
        }
    }
    var EventChat = [ChatModel]() {
        didSet {
            DispatchQueue.main.async {
                self.EventsVM.fetchChat(data: self.EventChat)
            }
        }
    }
    fileprivate func attemptToAssembleGroupedMessages() {
        print("attempt to group our messages together based on Date proprety")
        
//        let groupedMessages = Dictionary(grouping: EventChat) { (element) -> String in
//
//            return element.date
//        }
//        EventChat = Array(groupedMessages.values)
        print(self.EventChat)
        self.EventChat.sort { (m1, m2) -> Bool in
            
            guard let msg1 = m1.start_date else { return false }
            guard let msg2 = m2.start_date else { return false}
            return msg1.currentTimeMillis() < msg2.currentTimeMillis()
        }
        print(self.EventChat)
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
            
            isVideoPlaying = true
        }
        getChatList(room_id: self.room_id)
    }
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        EventsDetailsVC.videoPlayer?.seek(to: CMTime.zero)
        EventsDetailsVC.videoPlayer?.play()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.searchTF.text = ""
        self.searchTF.isHidden = true
        PusherManager.shared.ListenToChannel(ChannelId: self.room_id) { (event) in
            if let message = event.data {
                print(message)
                let data = message.convertStringToJSON()
                print(data)
                let current_user_id = Helper.getUserID()
                let created_at = data?["date"] as? String ?? ""
                let messageDate = created_at.toDate() ?? Date()
                let message_date_to_String = messageDate.getCurrentDate()
                if current_user_id == data?["sender_id"] as? Int {
                    self.EventChat.append(ChatModel(senderImage: "", senderName: Helper.getUserName() ?? "", message: data?["message"] as? String ?? "", readAt: "", ReceiverFlag: false, start_date: messageDate))
                } else {
                    self.EventChat.append(ChatModel(senderImage: "", senderName: "Other User", message: data?["message"] as? String ?? "", readAt: "", ReceiverFlag: true, start_date: messageDate))
                }
//                self.attemptToAssembleGroupedMessages()
            }
        }
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
            //                self.navigationController?.pushViewController(main, animated: true)
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
            self.EventChatButton.isHidden = true
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
            self.EventChatView.isHidden = true
        } else {
            self.EventChatButton.isHidden = false
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
            self.sendMessage(message: self.MessageTF.text!, room_id: self.room_id, user_id: Helper.getUserID() ?? 0)
        } else {
            displayMessage(title: "", message: "Please write your comment first", status: .info, forController: self)
        }
        
    }
    @IBAction func SendAction(_ sender: CustomButtons) {
        self.MessageTF.resignFirstResponder()
    }
    @IBAction func EnrollNowAction(_ sender: UIButton) {
    }
    
}

extension EventsDetailsVC {
    func sendMessage(message: String, room_id: Int, user_id: Int) {
        self.EventsVM.postSendMessage(message: message, room_id: room_id, user_id: user_id).subscribe(onNext: { (messageModel) in
            if let messageData = messageModel.data {
//                self.EventChat.append(ChatModel(senderImage: "", senderName: Helper.getUserName() ?? "", message: messageData.body ?? "", readAt: messageData.readedAt ?? "", ReceiverFlag: false))
                self.MessageTF.text = ""
//
                let bottomOffset = CGPoint(x: 0, y: self.ScrollViewContainer.contentSize.height - self.ScrollViewContainer.bounds.size.height + 50)
                self.ScrollViewContainer.setContentOffset(bottomOffset, animated: true)
            }
        }, onError: { (error) in
            if "lang".localized == "ar" {
                displayMessage(title: "", message: "حدث خطأ ما اثناء إرسال الرسالة الخاصة بك، يرجى المحاولة في وقت لاحق", status: .error, forController: self)
            } else {
                displayMessage(title: "", message: "Something went wrong while sending your message, Please try again later", status: .error, forController: self)
            }
            }).disposed(by: disposeBag)
    }
    func getChatList(room_id: Int) {
        self.EventsVM.getRoomChat(room_id: room_id).subscribe(onNext: { (chatModel) in
            if let data = chatModel.data {
                var retrievedChat = [ChatModel]()
                let current_user_id = Helper.getUserID() ?? 0
                for message in data {
                    let created_at = message.createdAt ?? ""
                    let messageDate = created_at.toDate() ?? Date()
                    let message_date_to_String = messageDate.getCurrentDate()
                    print("Date of Message: \(message_date_to_String) Created_at: \(created_at) MessageData: \(messageDate)")
                    if message.senderID ?? 0 == current_user_id {
                        retrievedChat.append(ChatModel(senderImage: "", senderName: "You", message: message.body ?? "", readAt: message.readedAt ?? "", ReceiverFlag: false, start_date: messageDate))
                    } else {
                        retrievedChat.append(ChatModel(senderImage: "", senderName: "Other User", message: message.body ?? "", readAt: message.readedAt ?? "", ReceiverFlag: true, start_date: messageDate))
                    }
                }
                self.EventChat = retrievedChat.reversed()
                self.ChatTableView.scrollToBottomRow()
                retrievedChat.removeAll()
//                self.attemptToAssembleGroupedMessages()
//                self.ChatTableView.reloadData()
                self.ChatTableView.scrollToBottomRow()
            }
        }, onError: { (error) in
            if "lang".localized == "ar" {
                displayMessage(title: "", message: "حدث خطأ ما في إستقبال محادثات الحدث، سيتم حل المشكلة في أسرع وقت", status: .error, forController: self)
            } else {
                displayMessage(title: "", message: "Something went wrong while getting event chat, Don't Panic we are going to solve it ASAP", status: .error, forController: self)
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
        self.EventContent = ["Test", "Test2", "Test3"]
        let cellIdentifier = "EventContentCell"
        self.ContentTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ContentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.ContentTableView.rowHeight = UITableView.automaticDimension
        self.ContentTableView.estimatedRowHeight = UITableView.automaticDimension
        self.EventsVM.EventContent.bind(to: self.ContentTableView.rx.items(cellIdentifier: cellIdentifier, cellType: EventContentCell.self)) { index, element, cell in
            if index == 0 {
                cell.config(InstructorName: self.EventContent[index], InstructorJob: "Rheumatology", StartTime: "16 July 2020 08:00 PM", EndTime: "09:30 PM", ContentType: "Live", selected: true)
            } else {
                cell.config(InstructorName: self.EventContent[index], InstructorJob: "Rheumatology", StartTime: "16 July 2020 08:00 PM", EndTime: "09:30 PM", ContentType: "Live", selected: false)
            }
            
        }.disposed(by: disposeBag)
        
        self.ContentTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.ContentTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupChatTableView() {
//        self.EventChat = [ChatModel(senderImage: "", senderName: "Mohammed Test", message: "Heya Awesome EventHeya Awesome EventHeya Awesome EventHeya Awesome EventHeya Awesome Event", ReceiverFlag: true), ChatModel(senderImage: "", senderName: "Mohammed Test", message: "Yes I'm Agree with youYes I'm Agree with youYes I'm Agree with youYes I'm Agree with youYes I'm Agree with you", ReceiverFlag: false)]
        let cellIdentifier = "EventChatCell"
        self.ChatTableView.rowHeight = UITableView.automaticDimension
        self.ChatTableView.estimatedRowHeight = UITableView.automaticDimension
        self.ChatTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ChatTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.EventsVM.ChatArr.bind(to: self.ChatTableView.rx.items(cellIdentifier: cellIdentifier, cellType: EventChatCell.self)) { index, element, cell in
            cell.config(ImageUrl: element.senderImage ?? "", UserName: element.senderName ?? "", Message: element.message ?? "" , ReceiverFlag: element.ReceiverFlag ?? false)
        }.disposed(by: disposeBag)
        self.ChatTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
}
