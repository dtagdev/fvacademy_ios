//
//  CourseDetails.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import StepProgressBar
import RxSwift
import RxCocoa

class CourseDetailsVC: UIViewController {

    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var enrollerImageView1: CustomImageView!
    @IBOutlet weak var enrollerImageView2: CustomImageView!
    @IBOutlet weak var enrollerImageView3: CustomImageView!
    @IBOutlet weak var enrollerImageView4: CustomImageView!
    @IBOutlet weak var enrollersCounter: UILabel!
    @IBOutlet weak var price_discountLabel: UILabel!
    @IBOutlet weak var enrollView: CustomView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseTimeLabel: CustomLabel!
    @IBOutlet weak var courseDescriptionTextView: CustomTextView!
    @IBOutlet weak var courseInformationLabel: UILabel!
    @IBOutlet weak var currentStepNameLabel: UILabel!
    @IBOutlet weak var currentStepDateLabel: UILabel!
    @IBOutlet weak var currentStepTimeLabel: UILabel!
    @IBOutlet weak var courseContentDataLabel: UILabel!
    @IBOutlet weak var ContentTableView: CustomTableView!
    @IBOutlet weak var stepProgressBar: StepProgressBar!
    @IBOutlet weak var LessonsView: UIView!
    @IBOutlet weak var OverViewView: UIView!
    @IBOutlet weak var OverViewSeperator: UIView!
    @IBOutlet weak var LessonsSeperator: UIView!
    @IBOutlet weak var PurchasedStatusLabel: CustomLabel!
    @IBOutlet weak var EnrollNowOrContinueLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var RecommendationsCollectionView: UICollectionView!
    @IBOutlet weak var RecommendedLabel: UILabel!
    @IBOutlet weak var overViewRequirementsTV: UITextView!
    @IBOutlet weak var courseTypeLabel: CustomLabel!
    @IBOutlet weak var WishlistButton: UIButton!
    @IBOutlet weak var DescriptionTV: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    
    private var courseViewModel = CourseDetailsViewModel()
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    var disposeBag = DisposeBag()
    let RecommendedCoursesCellIdentifier = "RecommendationCoursesCell"
    let cellIdentifier = "CourseContentCell"
    let headerCellIdentifier = "ContentHeaderCell"
    var courseData = ["1- Introduction An introduction to the course", "2- the first topic in the Introduction An introduction to the course"]
//        [String]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.ContentTableView.reloadData()
//                self.ContentTableView.invalidateIntrinsicContentSize()
//                self.ContentTableView.layoutIfNeeded()
//            }
//        }
//    }
    var RecommendedCourses = [CoursesData]() {
        didSet {
            DispatchQueue.main.async {
                self.courseViewModel.fetchRecommendedCourses(data: self.RecommendedCourses)
            }
        }
    }
    var price = String()
    var course_id = Int()
    var purchasedFlag = Bool()
    var wishlistFlag = Bool()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.CourseInformationTapAction(_:)))
        courseInformationLabel.isUserInteractionEnabled = true
        courseInformationLabel.addGestureRecognizer(gestureRecognizer)
        setupMultiColorCourseInfoLabel()
        let enrollViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.EnrollAction))
        self.enrollView.addGestureRecognizer(enrollViewGesture)
        setupContentTableView()
        setupRecommendationsCollectionView()
        self.getCourseDetails(course_id: course_id)
        
        geCurrentView(page: "OverView")
    }
    @objc func EnrollAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("Enroll Action")
        guard let main = UIStoryboard(name: "PaymentMethod", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC else { return }
        main.courseName = self.courseNameLabel.text ?? ""
        main.price = self.price
        self.navigationController?.pushViewController(main, animated: true)
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func ratingAction(_ sender: UIButton) {
        guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "RatingVC") as? RatingVC else { return }
        main.courseName = self.courseNameLabel.text ?? ""
        main.courseDetails = self.courseDescriptionTextView.text
        main.price = self.price
        main.course_id = self.course_id
        self.navigationController?.pushViewController(main, animated: true)
    }
    @IBAction func CurrentViewPageAction(_ sender: CustomButtons) {
        if sender.tag == 1 {
            geCurrentView(page: "OverView")
        } else {
            geCurrentView(page: "Lessons")
        }
        
    }
    @IBAction func AddToWishlistAction(_ sender: UIButton) {
        sender.isEnabled = false
        if Helper.getUserID() ?? 0 != 0 {
            if self.wishlistFlag {
                self.removeFromWishlist(course_id: self.course_id)
            } else {
                self.addToWishList(course_id: self.course_id)
            }
            
        } else {
            displayMessage(title: "", message: "Please Login First", status: .info, forController: self)
        }
        
    }
    
    func geCurrentView(page: String) {
        if page == "OverView" {
            self.OverViewView.isHidden = false
            self.OverViewSeperator.isHidden = false
            self.LessonsView.isHidden = true
            self.LessonsSeperator.isHidden = true
        } else {
            self.OverViewView.isHidden = true
            self.OverViewSeperator.isHidden = true
            self.LessonsView.isHidden = false
            self.LessonsSeperator.isHidden = false
        }
    }
    
    //MARK:- Register Label Action Configurations
    @objc func CourseInformationTapAction(_ sender: UITapGestureRecognizer) {
            print("Register Action")
        NotificationCenter.default.post(name: Notification.Name("NavigateToRegister"), object: nil)
    }
    func setupMultiColorCourseInfoLabel() {
        let main_string = "Live Now Event time 9:30 am to 11:00 am"
        let coloredString = "Live Now"
        let secondColoredString = "9:30 am to 11:00 am"
        let Range = (main_string as NSString).range(of: coloredString)
        let Range2 = (main_string as NSString).range(of: secondColoredString)
        let attribute = NSMutableAttributedString.init(string: main_string)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 1, green: 0.5042124391, blue: 0.4857309461, alpha: 1) , range: Range)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 1, green: 0.5042124391, blue: 0.4857309461, alpha: 1) , range: Range2)
        courseInformationLabel.attributedText = attribute
    }
    @IBAction func AddToCartAction(_ sender: UIButton) {
        addToCartButton.isEnabled = false
        self.addToCart(course_id: self.course_id, price: self.price)
    }
}

extension CourseDetailsVC {
    func getCourseDetails(course_id: Int) {
        self.courseViewModel.getCourseDetails(course_id: course_id).subscribe(onNext: { (courseDetails) in
            if let data =  courseDetails.data {
//                self.course_id = data.id ?? 0
                self.courseNameLabel.text = data.name ?? ""
                self.courseDescriptionTextView.text = data.details ?? ""
                self.price_discountLabel.attributedText = NSAttributedString(attributedString: (data.price ?? "").strikeThrough()) + NSAttributedString(string: "\n\((Int(data.price ?? "") ?? 0) - (Int(data.discount ?? "") ?? 0)) SAR")
                self.price = "\((Int(data.price ?? "") ?? 0) - (Int(data.discount ?? "") ?? 0))"
                self.ratingLabel.text = "\((data.rate ?? 0.0).rounded(toPlaces: 2))"
                if data.isPurchased == 1 {
                    self.purchasedFlag = true
                    self.PurchasedStatusLabel.isHidden = false
                    self.RecommendedLabel.text = "Related Courses"
                } else {
                    self.purchasedFlag = false
                    self.PurchasedStatusLabel.isHidden = true
                    self.RecommendedLabel.text = "Recommended"
                }
                if data.isWishlist == 1 {
                    self.wishlistFlag = true
                    self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkSelected"), for: .normal)
                } else {
                    self.wishlistFlag = false
                    self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkUnSelected"), for: .normal)
                }
                self.courseTimeLabel.text = "\(data.time ?? "") mins"
                self.getRelatedCourses(course_id: course_id)
                self.overViewRequirementsTV.text = ""
                self.courseTypeLabel.text = data.type ?? ""
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    
    func getRelatedCourses(course_id: Int) {
        self.courseViewModel.getRelatedCourses(course_id: course_id).subscribe(onNext: { (relatedCourses) in
            if let data = relatedCourses.data {
                self.RecommendedCourses = data
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    func removeFromWishlist(course_id: Int) {
        self.courseViewModel.postRemoveFromWishList(course_id: course_id).subscribe(onNext: { (wishList) in
            if wishList.data ?? false {
                displayMessage(title: "", message: RemoveFromWishListMessage.localized, status: .info, forController: self)
                self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkUnSelected"), for: .normal)
                
            } else if wishList.errors != nil {
                displayMessage(title: "", message: wishList.errors ?? "", status: .error, forController: self)
            }
            self.WishlistButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.WishlistButton.isEnabled = true
        }).disposed(by: disposeBag)
    }
    func addToWishList(course_id: Int) {
        self.courseViewModel.postAddToWishList(course_id: course_id).subscribe(onNext: { (addWishListModel) in
            if let data = addWishListModel.data {
                displayMessage(title: "", message: AddToWishListMessage.localized, status: .success, forController: self)
                self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkSelected"), for: .normal)
            }
            self.WishlistButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.WishlistButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
    func addToCart(course_id: Int, price: String) {
        self.courseViewModel.postAddToCart(course_id: course_id, price: price).subscribe(onNext: { (cartModel) in
            if cartModel.data ?? false {
                displayMessage(title: "", message: AddToCartMessage.localized, status: .success, forController: self)
            } else if let errors = cartModel.errors {
                if errors.courseID != [] {
                    displayMessage(title: "", message: errors.courseID?[0] ?? "", status: .error, forController: self)
                } else if errors.price != [] {
                    displayMessage(title: "", message: errors.price?[0] ?? "", status: .error, forController: self)
                }
            }
            self.addToCartButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.addToCartButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
}
extension CourseDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func setupContentTableView() {
        self.ContentTableView.delegate = self
        self.ContentTableView.dataSource = self
        self.ContentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.ContentTableView.register(UINib(nibName: headerCellIdentifier, bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        self.ContentTableView.rowHeight = UITableView.automaticDimension
        self.ContentTableView.estimatedRowHeight = UITableView.automaticDimension
        self.ContentTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.ContentTableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.ContentTableView.invalidateIntrinsicContentSize()
        self.ContentTableView.layoutIfNeeded()
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? ContentHeaderCell else { return UITableViewCell()}
        if section == 0 {
            cell.config(StepHeaderContent: "1- The first part will discuss the following topics:")
        } else {
            cell.config(StepHeaderContent: "2- The second part will discuss the following topics:")
        }
        
        return cell
    }
//    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
//        return 45
//    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseContentCell else { return UITableViewCell()}
        cell.config(StepContent: self.courseData[indexPath.row], stepDuration: "5:20 mins")
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CourseContentVC") as? CourseContentVC else { return }
        main.progressName = self.courseData[indexPath.row]
        main.course_id = 1
        main.progressDescription = "No Description Added yet"
        self.navigationController?.pushViewController(main, animated: true)
    }
}

extension CourseDetailsVC: UICollectionViewDelegate {
    func setupRecommendationsCollectionView() {
        self.RecommendationsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.RecommendationsCollectionView.register(UINib(nibName: RecommendedCoursesCellIdentifier, bundle: nil), forCellWithReuseIdentifier: RecommendedCoursesCellIdentifier)
        self.courseViewModel.RecommendedCourses.bind(to: self.RecommendationsCollectionView.rx.items(cellIdentifier: RecommendedCoursesCellIdentifier, cellType: RecommendationCoursesCell.self)) { index, element, cell in
            cell.config(imageURL: "", CourseName: self.RecommendedCourses[index].name ?? "")
        }.disposed(by: disposeBag)
        
        self.RecommendationsCollectionView.rx.itemSelected.bind { (indexPath) in
            self.getCourseDetails(course_id: self.RecommendedCourses[indexPath.row].id ?? 0)
        }.disposed(by: disposeBag)
    }
}
extension CourseDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 3
        return CGSize(width: size, height: collectionView.frame.size.height - 10)
    }
}
