//
//  CourseContentVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import AVKit
import RxSwift
import RxCocoa

class CourseContentVC: UIViewController {

    @IBOutlet weak var CommentsContainerView: UIView!
    @IBOutlet weak var CommentsSeperator: UIView!
    @IBOutlet weak var ReviewsView: UIView!
    @IBOutlet weak var ReviewsSeperator: UIView!
    @IBOutlet weak var sendMessageButton: CustomButtons!
    @IBOutlet weak var TakeExamButton: CustomButtons!
    @IBOutlet weak var CertificationButton: CustomButtons!
    @IBOutlet weak var newReviewButton: CustomButtons!
    @IBOutlet weak var CommentView: UIView!
    @IBOutlet weak var videoPlayView: UIView!
    @IBOutlet weak var submitCommentButton: CustomButtons!
    @IBOutlet weak var CommentsTableView: CustomTableView!
    @IBOutlet weak var ReviewsTableView: CustomTableView!
    @IBOutlet weak var messageTV: CustomTextView!
    @IBOutlet weak var Certification_ExamsView: UIStackView!
    @IBOutlet weak var progressNameLabel: UILabel!
    @IBOutlet weak var progressDescTV: CustomTextView!
    @IBOutlet weak var backButton: UIButton!
    var progressName = String()
    var progressDescription = String()
    static var videoPlayer: AVPlayer? = nil
    var videoPlayerLayer: AVPlayerLayer? = nil
    var isVideoPlaying = false
    var videoURL = String()
    var CourseContentVM = CourseContentViewModel()
    var Reviews = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.CourseContentVM.fetchReviews(data: self.Reviews)
            }
        }
    }
    var Comments = [CommentData]() {
        didSet {
            DispatchQueue.main.async {
                self.CourseContentVM.fetchComments(data: self.Comments)
            }
        }
    }
    var course_id = Int()
    var disposeBag = DisposeBag()
    var choiceType = String()
    private let ReviewsCellIdentifier = "ReviewsCell"
    override func viewDidLoad() {
        super.viewDidLoad()
        NotificationCenter.default.addObserver(self,selector: #selector(playerItemDidReachEnd(notification:)), name: NSNotification.Name.AVPlayerItemDidPlayToEndTime, object: CourseContentVC.videoPlayer?.currentItem)
        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.progressNameLabel.text = progressName
        self.progressNameLabel.adjustsFontSizeToFitWidth = true
        self.progressNameLabel.minimumScaleFactor = 0.5
        self.progressDescTV.text = progressDescription
        setupButtonUIEdges()
        if videoURL != "" {
//            self.playButton.isHidden = false
            guard let videoURL = URL(string: "https://dev.fv.academy/public/lessons/" + videoURL) else { return }
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
        setupReviewsTableView()
        setupCommentsTableView()
        self.getCurrentView(page: "Comments")
        self.getCourseComments(course_id: course_id)
        self.CommentView.isHidden = true

    }
    @objc func playerItemDidReachEnd(notification: NSNotification) {
        CourseContentVC.videoPlayer?.seek(to: CMTime.zero)
        CourseContentVC.videoPlayer?.play()
    }
    @IBAction func submitComment_MessageAction(_ sender: CustomButtons) {
        self.CommentView.isHidden = true
        
        if choiceType == "comment" {
            guard !self.messageTV.text.isEmpty else {
                displayMessage(title: "", message: EmptyComment.localized, status: .info, forController: self)
            return }
            self.addComment(course_id: self.course_id, comment: self.messageTV.text)
        }
    }

    @IBAction func ChoicesAction(_ sender: CustomButtons) {
        switch sender.tag {
        case 1:
            print("Add New Review")
           guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "RatingVC") as? RatingVC else { return }
           //main.courseName = self.courseNameLabel.text ?? ""
           //main.courseDetails = self.courseDescriptionTextView.text
           //main.price = self.price
           main.course_id = self.course_id
           self.navigationController?.pushViewController(main, animated: true)
            
        case 2, 3:
            print("Send Comment")
            self.choiceType = "comment"
            if self.CommentView.isHidden {
                self.CommentView.isHidden = true
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    if self.CommentView.isHidden {
                        self.CommentView.isHidden = false
                    } else {
                        self.CommentView.isHidden = true
                    }
                }
            } else {
                self.CommentView.isHidden = false
                displayMessage(title: "", message: "Write your comment now", status: .info, forController: self)
            }
            
        case 3:
            print("Take Exams")
            break
        case 4:
            print("Certificate")
            break
        default:
            break
            
        }
        
    }
    @IBAction func CurrentViewAction(_ sender: CustomButtons) {
        switch sender.tag {
        case 1:
            getCurrentView(page: "Comments")
        case 2:
            getCurrentView(page: "Reviews")
        default:
            break
        }
    }
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}


extension CourseContentVC {
    func bindedData() {
        
    }
    func getCurrentView(page: String) {
        if page == "Comments" {
            self.CommentsContainerView.isHidden = false
            self.CommentsSeperator.isHidden = false
            self.ReviewsView.isHidden = true
            self.ReviewsSeperator.isHidden = true
        } else {
            self.CommentsContainerView.isHidden = true
            self.CommentsSeperator.isHidden = true
            self.ReviewsView.isHidden = false
            self.ReviewsSeperator.isHidden = false
        }
    }
    func setupButtonUIEdges() {
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone5S, .iPhoneSE, .iPhoneSE2:
            self.sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.sendMessageButton.frame.width ) - 45, bottom: 0, right: 0)
            self.sendMessageButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            self.sendMessageButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.sendMessageButton.titleLabel?.minimumScaleFactor = 0.5
            self.newReviewButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.newReviewButton.frame.width ) - 45, bottom: 0, right: 0)
            self.newReviewButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            self.newReviewButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.newReviewButton.titleLabel?.minimumScaleFactor = 0.5
            self.CertificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.CertificationButton.frame.width ) - 45, bottom: 0, right: 0)
            self.CertificationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
            self.CertificationButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.CertificationButton.titleLabel?.minimumScaleFactor = 0.5
            self.TakeExamButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.TakeExamButton.frame.width ) - 45, bottom: 0, right: 0)
            self.TakeExamButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
            self.TakeExamButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.TakeExamButton.titleLabel?.minimumScaleFactor = 0.5
            self.submitCommentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.submitCommentButton.frame.width ) - 30, bottom: 0, right: 0)
            self.submitCommentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        default:
            self.sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.sendMessageButton.frame.width ) - 30, bottom: 0, right: 0)
            self.sendMessageButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            self.sendMessageButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.sendMessageButton.titleLabel?.minimumScaleFactor = 0.5
            self.newReviewButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.newReviewButton.frame.width ) - 30, bottom: 0, right: 0)
            self.newReviewButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            self.newReviewButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.newReviewButton.titleLabel?.minimumScaleFactor = 0.5
            self.CertificationButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.CertificationButton.frame.width ) - 30, bottom: 0, right: 0)
            self.CertificationButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
            self.CertificationButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.CertificationButton.titleLabel?.minimumScaleFactor = 0.5
            self.TakeExamButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.TakeExamButton.frame.width ) - 30, bottom: 0, right: 0)
            self.TakeExamButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 50)
            self.TakeExamButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.TakeExamButton.titleLabel?.minimumScaleFactor = 0.5
            self.submitCommentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.submitCommentButton.frame.width ) - 30, bottom: 0, right: 0)
            self.submitCommentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        }
        
    }
    
    func getCourseComments(course_id: Int) {
        self.CourseContentVM.getCourseComments(course_id: course_id).subscribe(onNext: { (commentModel) in
            if let comments = commentModel.data {
                self.Comments = comments
            } else if let error = commentModel.errors {
                if let courseId = error.courseID {
                    displayMessage(title: "", message: courseId[0], status: .error, forController: self)
                }
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    func addComment(course_id: Int, comment: String) {
        self.CourseContentVM.postAddComment(course_id: self.course_id, comment: self.messageTV.text).subscribe(onNext: { (commentModel) in
            if let _ = commentModel.data {
                displayMessage(title: "", message: CommentRecorded.localized, status: .info, forController: self)
            } else if let errors = commentModel.errors {
                if errors.comment != [] {
                    displayMessage(title: "", message: errors.comment?[0] ?? "", status: .error, forController: self)
                } else if errors.courseID != [] {
                    displayMessage(title: "", message: errors.courseID?[0] ?? "", status: .error, forController: self)
                }
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension CourseContentVC: UITableViewDelegate {
    func setupReviewsTableView() {
        self.Reviews = ["Test1", "Test2", "Test3"]
        self.ReviewsTableView.register(UINib(nibName: self.ReviewsCellIdentifier, bundle: nil), forCellReuseIdentifier: self.ReviewsCellIdentifier)
        self.ReviewsTableView.rowHeight = UITableView.automaticDimension
        self.ReviewsTableView.estimatedRowHeight = UITableView.automaticDimension
        self.ReviewsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CourseContentVM.Reviews.bind(to: self.ReviewsTableView.rx.items(cellIdentifier: self.ReviewsCellIdentifier, cellType: ReviewsCell.self)) { index, element, cell in
            cell.config(UserImageURL: "", UserName: self.Reviews[index], UserRating: 3.5, UserComment: "Test123456798Test123456798Test123456798Test123456798Test123456798")
        }.disposed(by: disposeBag)
        self.ReviewsTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.ReviewsTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    func setupCommentsTableView() {
        self.CommentsTableView.register(UINib(nibName: self.ReviewsCellIdentifier, bundle: nil), forCellReuseIdentifier: self.ReviewsCellIdentifier)
        self.CommentsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CommentsTableView.rowHeight = UITableView.automaticDimension
        self.CommentsTableView.estimatedRowHeight = UITableView.automaticDimension
        self.CourseContentVM.Comments.bind(to: self.CommentsTableView.rx.items(cellIdentifier: self.ReviewsCellIdentifier, cellType: ReviewsCell.self)) { index, element, cell in
            cell.config(UserImageURL: "", UserName: "No Data in API", UserRating: 3.5, UserComment: self.Comments[index].comment ?? "")
        }.disposed(by: disposeBag)
        self.CommentsTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.CommentsTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
    
}


