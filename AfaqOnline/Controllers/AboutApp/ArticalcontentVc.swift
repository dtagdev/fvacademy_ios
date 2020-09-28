//
//  ArticalcontentVc.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import AVKit
import RxSwift
import RxCocoa

class ArticalcontentVc: UIViewController {

    @IBOutlet weak var CommentsContainerView: UIView!
    @IBOutlet weak var sendMessageButton: CustomButtons!
    @IBOutlet weak var CommentView: UIView!
    @IBOutlet weak var submitCommentButton: CustomButtons!
    @IBOutlet weak var CommentsTableView: CustomTableView!
    @IBOutlet weak var messageTV: CustomTextView!
    @IBOutlet weak var progressNameLabel: UILabel!
    @IBOutlet weak var progressDescTV: CustomTextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var articalImageView: UIImageView!
    var progressName = String()
    var progressDescription = String()
    var ArticalcontentVM = ArticalViewModel()
    var comments = [Comment](){
        didSet {
            DispatchQueue.main.async {
                self.ArticalcontentVM.fetchComments(data: self.comments)
            }
        }
    }
    var id = Int()
    var disposeBag = DisposeBag()
    private let ReviewsCellIdentifier = "ReviewsCell"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        setupCommentsTableView()
        self.CommentsContainerView.isHidden = false
        self.CommentView.isHidden = true
        ArticalcontentVM.showIndicator()
        self.getarticalDetails(id: id)

    }
  
    
    @IBAction func submitComment_MessageAction(_ sender: CustomButtons) {
             sendMessageButton.setTitle("add Comment", for: .normal)
             comment = true
            ArticalcontentVM.showIndicator()
            self.CommentView.isHidden = true
            self.CommentsContainerView.isHidden = false
            guard !self.messageTV.text.isEmpty else {
                displayMessage(title: "", message: EmptyComment.localized, status: .info, forController: self)
            return }
            self.addComment(id: self.id, comment: self.messageTV.text)
            self.getarticalDetails(id : self.id)
        
    }
     var comment = true
    @IBAction func ChoicesAction(_ sender: CustomButtons) {
        if comment == true {
        sendMessageButton.setTitle("cancel", for: .normal)
        self.CommentView.isHidden = false
        self.CommentsContainerView.isHidden = true
        comment = false
        }else{
         self.CommentView.isHidden = true
        self.CommentsContainerView.isHidden = false
        sendMessageButton.setTitle("add Comment", for: .normal)
        comment = true
        }
        
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension ArticalcontentVc {
    func setupButtonUIEdges() {
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone5S, .iPhoneSE, .iPhoneSE2:
            self.sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.sendMessageButton.frame.width ) - 30, bottom: 0, right: 0)
            self.sendMessageButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            self.sendMessageButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.sendMessageButton.titleLabel?.minimumScaleFactor = 0.5
         
            self.submitCommentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.submitCommentButton.frame.width ) - 30, bottom: 0, right: 0)
            self.submitCommentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        default:
            self.sendMessageButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.sendMessageButton.frame.width ) - 30, bottom: 0, right: 0)
            self.sendMessageButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
            self.sendMessageButton.titleLabel?.adjustsFontSizeToFitWidth = true
            self.sendMessageButton.titleLabel?.minimumScaleFactor = 0.5
           
            self.submitCommentButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.submitCommentButton.frame.width ) - 30, bottom: 0, right: 0)
            self.submitCommentButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 30)
        }
        
    }
    
    func getarticalDetails(id: Int) {
        self.ArticalcontentVM.getArticalDetails(id: id).subscribe(onNext: { (artical) in
            if let comments = artical.data {
                self.ArticalcontentVM.dismissIndicator()
                self.comments = comments.comments ?? []
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + (comments.mainImage ?? "") ) else { return }
                self.articalImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "DetailsImage"))
                
            } else if let error = artical.errors {
            displayMessage(title: "", message: error, status: .error, forController: self)

            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    func addComment(id: Int, comment: String) {
        self.ArticalcontentVM.postAddComment(id: id,comment: comment).subscribe(onNext: { (commentModel) in
            if let _ = commentModel.data {
                displayMessage(title: "", message: CommentRecorded.localized, status: .info, forController: self)
            } else if let errors = commentModel.errors {
                if errors.comment != [] {
                    displayMessage(title: "", message: errors.comment?[0] ?? "", status: .error, forController: self)
                }
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension ArticalcontentVc: UITableViewDelegate {
    func setupCommentsTableView() {
        self.CommentsTableView.register(UINib(nibName: self.ReviewsCellIdentifier, bundle: nil), forCellReuseIdentifier: self.ReviewsCellIdentifier)
        self.CommentsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CommentsTableView.rowHeight = UITableView.automaticDimension
        self.CommentsTableView.estimatedRowHeight = UITableView.automaticDimension
        self.ArticalcontentVM.Comments.bind(to: self.CommentsTableView.rx.items(cellIdentifier: self.ReviewsCellIdentifier, cellType: ReviewsCell.self)) { index, element, cell in
            cell.config(UserImageURL: "", UserName: "hazem", UserRating: 0, UserComment: self.comments[index].comment ?? "")
            cell.rateView.isHidden = true
        }.disposed(by: disposeBag)
        self.CommentsTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.CommentsTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
}


