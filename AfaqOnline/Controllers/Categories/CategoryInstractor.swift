//
//  CategoryInstractor.swift
//  AfaqOnline
//
//  Created by MAC on 11/5/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import DropDown

class CategoryInstractorVC : UIViewController {

    @IBOutlet weak var CoursesCollectionView: UICollectionView!
    @IBOutlet weak var CategoryTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    private let coursesViewModel = CoursesViewModel()

    var disposeBag = DisposeBag()
    var Courses = [TrendCourse]() {
        didSet {
            DispatchQueue.main.async {
                self.coursesViewModel.fetchCourses(Courses: self.Courses)
            }
        }
    }
    var categoryName = String()
    var currentPage = 1
    var loading = false
    var loadMore = false
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupCoursesCollectionView()
        self.getAllCourses(lth: 0,htl: 0,rate : 0)
        self.hideKeyboardWhenTappedAround()
        self.coursesViewModel.showIndicator()
        
        
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }

}


extension CategoryInstractorVC {
    //MARK:- GET Courses
    func getCourses(category_id: Int) {
        coursesViewModel.getCategoryCourses(category_id: category_id).subscribe(onNext: { (coursesModel) in
            if let data = coursesModel.data {
                self.coursesViewModel.dismissIndicator()
                self.Courses = data
            } else if coursesModel.errors ?? "" != "" {
                displayMessage(title: "", message: coursesModel.errors ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    func getNextPage() {
        self.getAllCourses(lth: 0,htl: 0,rate : 0)
    }
    
    func getAllCourses(lth: Int,htl: Int,rate: Int) {
        self.coursesViewModel.getAllCourses(lth: lth,htl: htl,rate: rate).subscribe(onNext: { (CoursesModelJSON) in
            if let data = CoursesModelJSON.data?.courses {
                self.coursesViewModel.dismissIndicator()
                if !self.loadMore {
                    self.Courses = data
                    
                } else {
                    self.Courses.append(contentsOf: data)
                }
                
//                let dataClass = CoursesModelJSON.data
//                if dataClass.to != nil && data.count != 0 {
//                    self.currentPage += 1
//                    self.loadMore = true
//                    if self.currentPage == 2 {
//                        self.getNextPage()
//                    }
//
//                } else {
//                    self.loadMore = false
//                }
                
                self.loading = false
            }
        }, onError: { (error) in
            self.coursesViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension CategoryInstractorVC : UICollectionViewDelegate {
    
    func setupCoursesCollectionView() {
        let cellIdentifier = "CategoryInstractorCell"
        self.CoursesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CoursesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.coursesViewModel.Courses.bind(to: self.CoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CategoryInstractorCell.self)) { index, element, cell in
            cell.openDetailsAction = {
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstractorProfileVc") as? InstractorProfileVc else { return }
            main.id = 4 //courseData?.instructor?.id ?? 0
            self.navigationController?.pushViewController(main, animated: true)
            }
            // cell.config(courseName: self.Courses[index].name ?? "", courseInstractor: "\(self.Courses[index].instructor?.user?.firstName ?? "") \(self.Courses[index].instructor?.user?.lastName ??  "")", courseTime: self.Courses[index].time ?? "", courseType: self.Courses[index].type ?? "", rating: ((self.Courses[index].rate?.rounded(toPlaces: 1) ?? 0)), price: Double(self.Courses[index].price ?? "") ?? 0.0, discountPrice:((Double(self.Courses[index].price ?? "") ?? 0.0) - (Double(self.Courses[index].discount ?? "") ?? 0.0)), imageURL: self.Courses[index].mainImage ?? "", videoURL: self.Courses[index].courseURL ?? "")
     
        }.disposed(by: disposeBag)
        
        self.CoursesCollectionView.rx.itemSelected.bind { (indexPath) in
                 guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstractorProfileVc") as? InstractorProfileVc else { return }
              self.navigationController?.pushViewController(main, animated: true)
             }.disposed(by: disposeBag)
        
    }
}

extension CategoryInstractorVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            let size:CGFloat = (collectionView.frame.size.width - space) / 1
            return CGSize(width: size, height: 200)
        }
}
