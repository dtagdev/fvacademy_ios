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
  
    @IBOutlet weak var price_discountLabel: UILabel!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseTimeLabel: CustomLabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var RecommendationsCollectionView: UICollectionView!
    @IBOutlet weak var CoursesCollectionView: CustomCollectionView!
    @IBOutlet weak var courseTypeLabel: CustomLabel!
    @IBOutlet weak var WishlistButton: UIButton!
    @IBOutlet weak var DescriptionTV: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
 
    @IBOutlet weak var requermentTableView: UITableView!
    @IBOutlet weak var whatLearnTableView: UITableView!
    @IBOutlet weak var ContentTableView: UITableView!
    @IBOutlet weak var feedBackTableView: UITableView!

    

    private var courseViewModel = CourseDetailsViewModel()
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    var disposeBag = DisposeBag()
    let cellIdentifier = "CourseContentCell"
    let headerCellIdentifier = "ContentHeaderCell"
    let requermentIdentifier = "RequirementsCell"
    let feedBackIdentifier = "ReviewsCell"
    
    var courseData : TrendCourse?{
        didSet {
            DispatchQueue.main.async {
                self.ContentTableView.reloadData()
                self.ContentTableView.invalidateIntrinsicContentSize()
                self.ContentTableView.layoutIfNeeded()
            }
        }
    }
    var RecommendedCourses = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.courseViewModel.fetchRecommendedCourses(data: self.RecommendedCourses)
            }
        }
    }
    var price = String()
    var discount = String()
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

        setupContentTableView()
        setupRecommendationsCollectionView()
      //  self.getCourseDetails(course_id: course_id)
        setupCoursesCollectionView()
    }
 
    @IBAction func AddToWishlistAction(_ sender: UIButton) {
        sender.isEnabled = false
        if Helper.getUserID() ?? 0 != 0 {
          self.addToWishList(course_id: self.course_id)
        }else {
            displayMessage(title: "", message: "Please Login First", status: .info, forController: self)
         }
        }
        
    

    @IBAction func AddToCartAction(_ sender: UIButton) {
        addToCartButton.isEnabled = false
        self.addToCart(course_id: self.course_id, price: self.price, discount: self.discount)
    }
    
    @IBAction func SeeAllActions(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "NewCoursesVC") as? NewCoursesVC else { return }
            main.type = "Course"
            self.navigationController?.pushViewController(main, animated: true)
        case 2:
           guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "NewCoursesVC") as? NewCoursesVC else { return }
           main.type = "Event"
           self.navigationController?.pushViewController(main, animated: true)
        default:
            break
            }
        }
    
    @IBAction func backAction(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }

    
    @IBAction func instractorAction(_ sender: UIButton) {
        guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstractorProfileVc") as? InstractorProfileVc else { return }
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    
    
}

extension CourseDetailsVC {
    func getCourseDetails(course_id: Int) {
        self.courseViewModel.getCourseDetails(course_id: course_id).subscribe(onNext: { (courseDetails) in
            if let data =  courseDetails.data {
                self.courseData = data

                self.courseNameLabel.text = data.name ?? ""
                    // self.price_discountLabel.attributedText = NSAttributedString(attributedString: (data.price ?? "").strikeThrough()) + NSAttributedString(string: "\n\((Double(data.price ?? "") ?? 0.0) - (Double(data.discount ?? "") ?? 0.0)) SAR")
//                self.price = "\((Double(data.price ?? "") ?? 0.0))"
//                self.discount = "\(Double(data.discount ?? "") ?? 0.0)"
//                self.ratingLabel.text = "\((data.rate ?? 0))"
//                self.DescriptionTV.text = data.courseDescription
                
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + (data.mainImage ?? "") ) else { return }
                 self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "DetailsImage"))
//                if data.isWishlist == true {
//                    self.wishlistFlag = true
//                    self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkSelected"), for: .normal)
//                    self.WishlistButton.isEnabled = false
//                } else {
//                    self.wishlistFlag = false
//                    self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkUnSelected"), for: .normal)
//                }
                
                self.courseTimeLabel.text = "\(data.time ?? "") mins"
                self.getRelatedCourses(cat_id: data.category?.id ?? 0)
                self.courseTypeLabel.text = data.type ?? ""
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    
    func getRelatedCourses(cat_id: Int) {
        self.courseViewModel.getRelatedCourses(course_id: cat_id).subscribe(onNext: { (relatedCourses) in
            if let data = relatedCourses.data {
                //   self.RecommendedCourses = data
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    
    func addToWishList(course_id: Int) {
        self.courseViewModel.postAddToWishList(course_id: course_id).subscribe(onNext: { (addWishListModel) in
            if addWishListModel.data == true  {
                displayMessage(title: "", message: AddToWishListMessage.localized, status: .success, forController: self)
                self.WishlistButton.setImage(#imageLiteral(resourceName: "bookmarkSelected"), for: .normal)
                self.WishlistButton.isEnabled = false
            }else{
            self.WishlistButton.isEnabled = true
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.WishlistButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
    func addToCart(course_id: Int, price: String,discount : String) {
        self.courseViewModel.postAddToCart(course_id: course_id, price: price, discount: discount).subscribe(onNext: { (cartModel) in
            if cartModel.status ?? false {
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

extension CourseDetailsVC: UICollectionViewDelegate {
    func setupRecommendationsCollectionView() {
        self.RecommendedCourses = ["1","2","3","4"]
        let cellIdentifier = "CoursesCell"
        self.RecommendationsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.RecommendationsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.courseViewModel.RecommendedCourses.bind(to: self.RecommendationsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CoursesCell.self)) { index, element, cell in
           // cell.config(imageURL: self.RecommendedCourses[index].mainImage ?? "" , CourseName: self.RecommendedCourses[index].name ?? "")
        }.disposed(by: disposeBag)
        self.RecommendationsCollectionView.rx.itemSelected.bind { (indexPath) in
        }.disposed(by: disposeBag)
    }
    
    func setupCoursesCollectionView() {
        self.RecommendedCourses = ["1","2","3","4"]
        let cellIdentifier = "CoursesCell"
        self.CoursesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CoursesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.courseViewModel.RecommendedCourses.bind(to: self.CoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CoursesCell.self)) { index, element, cell in
            
            // cell.config(courseName: self.Courses[index].name ?? "", courseInstractor: "\(self.Courses[index].instructor?.user?.firstName ?? "") \(self.Courses[index].instructor?.user?.lastName ??  "")", courseTime: self.Courses[index].time ?? "", courseType: self.Courses[index].type ?? "", rating: ((self.Courses[index].rate?.rounded(toPlaces: 1) ?? 0)), price: Double(self.Courses[index].price ?? "0") ?? 0.0, discountPrice: ((Double(self.Courses[index].price ?? "") ?? 0.0) - (Double(self.Courses[index].discount ?? "") ?? 0.0)), imageURL: self.Courses[index].mainImage ?? "", videoURL: self.Courses[index].courseURL ?? "")
            
        }.disposed(by: disposeBag)
    }
    
}

extension CourseDetailsVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if collectionView == CoursesCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
            
        } else{
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
            
        }
    }
}

extension CourseDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func setupContentTableView() {
        self.ContentTableView.delegate = self
        self.ContentTableView.dataSource = self
        self.requermentTableView.delegate = self
        self.requermentTableView.dataSource = self
        self.whatLearnTableView.delegate = self
        self.whatLearnTableView.dataSource = self
        self.feedBackTableView.delegate = self
        self.feedBackTableView.dataSource = self
        
        self.ContentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.requermentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: requermentIdentifier)
        self.whatLearnTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: requermentIdentifier)
        self.feedBackTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: feedBackIdentifier)
        self.ContentTableView.register(UINib(nibName: headerCellIdentifier, bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        
        self.ContentTableView.rowHeight = UITableView.automaticDimension
        self.ContentTableView.estimatedRowHeight = UITableView.automaticDimension
        self.ContentTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.ContentTableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.ContentTableView.invalidateIntrinsicContentSize()
        self.ContentTableView.layoutIfNeeded()
        
        self.feedBackTableView.rowHeight = UITableView.automaticDimension
        self.feedBackTableView.estimatedRowHeight = UITableView.automaticDimension
        self.feedBackTableView.invalidateIntrinsicContentSize()
        self.feedBackTableView.layoutIfNeeded()
        
        self.requermentTableView.rowHeight = UITableView.automaticDimension
        self.requermentTableView.estimatedRowHeight = UITableView.automaticDimension
        self.requermentTableView.invalidateIntrinsicContentSize()
        self.requermentTableView.layoutIfNeeded()
         
        self.whatLearnTableView.rowHeight = UITableView.automaticDimension
        self.whatLearnTableView.estimatedRowHeight = UITableView.automaticDimension
        self.whatLearnTableView.invalidateIntrinsicContentSize()
        self.whatLearnTableView.layoutIfNeeded()
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == ContentTableView {
        return  4 //courseData?.chapters?.count ?? 0
        }else{
        return  0
        }
    }
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? ContentHeaderCell else { return UITableViewCell()}
        if tableView == ContentTableView {
        cell.config(StepHeaderContent:  "asd asda ssd d f d d  ")
        }
        return cell
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // return courseData?.chapters?[section].lessons?.count ?? 0
        
        if tableView == ContentTableView {
           return  3
        }else if tableView == whatLearnTableView {
           return  6
        }else if tableView == requermentTableView {
            return  6
        }else if tableView == feedBackTableView {
            return  2
        }else{
           return  0
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ContentTableView {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseContentCell else { return UITableViewCell()}
              // let lessons = self.courseData?.chapters?[indexPath.section].lessons
               cell.config(StepContent: "asd dff g  gg  gg g ", stepDuration: "5:20 mins")
        return cell
        }else if tableView == requermentTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: requermentIdentifier) as? RequirementsCell else { return UITableViewCell()}
            cell.config(StepHeader : "String")
            return cell
        }else if tableView == whatLearnTableView {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: requermentIdentifier) as? RequirementsCell else { return UITableViewCell()}
            cell.config(StepHeader : "String")
            return cell
        }else  {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: feedBackIdentifier) as? ReviewsCell else { return UITableViewCell()}
            cell.config(UserImageURL: "" ,UserName : "hazem",UserRating : 0.0,UserComment : "hi sweety" )
            return cell
        }
    }
}
