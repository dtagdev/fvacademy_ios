//
//  CoursesVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class CoursesVC: UIViewController {

    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var CoursesCollectionView: UICollectionView!
    @IBOutlet weak var CategoryTitleLabel: UILabel!
    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    //SortBy Drop Down
    let SortByDropDown = DropDown()
    var SortByNames = ["Default", "High To Low", "Low To High", "Rate"]
    var SortByIds = [0, 1, 2]
    var selectedSortById = Int()
    
    //Filter Drop Down
    let FilterDropDown = DropDown()
    var FilterNames = ["Filer","Test1", "Test2"]
    var FilterIds = [0, 1, 2]
    var selectedFilterId = Int()
    private let coursesViewModel = CoursesViewModel()
    var category_id = Int()
    var disposeBag = DisposeBag()
    var Ads = [String]() {
            didSet {
                DispatchQueue.main.async {
                    self.coursesViewModel.fetchAds(Ads: self.Ads)
                }
            }
        }
    var Courses = [CoursesData]() {
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
        setupAdsCollectionView()
        setupCoursesCollectionView()
        BindButtonActions()
        SetupSortByDropDown()
        SetupFilterDropDown()
        
        self.CategoryTitleLabel.text = categoryName + " Courses"
        if type == "home" {
            self.getAllCourses(page: self.currentPage)
        } else {
            getCourses(category_id: category_id)
        }
        self.hideKeyboardWhenTappedAround()
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
    

    func SetupSortByDropDown() {
        self.SortByDropDown.anchorView = self.sortByButton
        self.SortByDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        self.SortByDropDown.dataSource = self.SortByNames
        self.SortByDropDown.selectionAction = { [weak self] (index, item) in
            self?.sortByButton.setTitle(item, for: .normal)
            self?.selectedSortById = self?.SortByIds[index] ?? 0
        }
        self.SortByDropDown.direction = .bottom
        self.SortByDropDown.width = self.view.frame.width * 0.95
    }
    func SetupFilterDropDown() {
        self.FilterDropDown.anchorView = self.FilterButton
        self.FilterDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        self.FilterDropDown.dataSource = self.FilterNames
        self.FilterDropDown.selectionAction = { [weak self] (index, item) in
            self?.FilterButton.setTitle(item, for: .normal)
            self?.selectedFilterId = self?.FilterIds[index] ?? 0
        }
        self.FilterDropDown.direction = .bottom
        self.FilterDropDown.width = self.view.frame.width * 0.95
    }
}

extension CoursesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}

extension CoursesVC {
    //MARK:- GET Courses
    func getCourses(category_id: Int) {
        coursesViewModel.getCategoryCourses(category_id: category_id).subscribe(onNext: { (coursesModel) in
            if let data = coursesModel.data {
                self.Courses = data
            } else if coursesModel.errors ?? "" != "" {
                displayMessage(title: "", message: coursesModel.errors ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    func getNextPage() {
        self.getAllCourses(page: self.currentPage)
    }
    func getAllCourses(page: Int) {
        self.coursesViewModel.getAllCourses(page: page).subscribe(onNext: { (CoursesModelJSON) in
            if let data = CoursesModelJSON.data?.data {
                if !self.loadMore {
                    self.Courses = data
                    
                } else {
                    self.Courses.append(contentsOf: data)
                }
                
                let dataClass = CoursesModelJSON.data ?? CoursesDataClass()
                if dataClass.to != nil && data.count != 0 {
                    self.currentPage += 1
                    self.loadMore = true
                    if self.currentPage == 2 {
                        self.getNextPage()
                    }

                } else {
                    self.loadMore = false
                }
                
                self.loading = false
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension CoursesVC : UICollectionViewDelegate {
    func BindButtonActions() {
        self.sortByButton.rx.tap.bind {
            self.SortByDropDown.show()
        }.disposed(by: disposeBag)
        self.FilterButton.rx.tap.bind {
//            self.FilterDropDown.show()
            guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
            main.modalPresentationStyle = .overFullScreen
            main.modalTransitionStyle = .crossDissolve
            main.search_name = self.searchTF.text ?? ""
            self.present(main, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
    func setupAdsCollectionView() {
        self.Ads = ["ssd"]
        let cellIdentifier = "AdsCell"
        self.AdsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.AdsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.coursesViewModel.Ads.bind(to: self.AdsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AdsCell.self)) { index, element, cell in
            cell.config(Type: "Image", imageURL: "")
            cell.AdOpenActionClosure = {
                
            }
        }.disposed(by: disposeBag)
        self.AdsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupCoursesCollectionView() {
        let cellIdentifier = "CoursesCell"
        self.CoursesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CoursesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.coursesViewModel.Courses.bind(to: self.CoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CoursesCell.self)) { index, element, cell in
            cell.config(courseName: self.Courses[index].name ?? "", courseDesc: self.Courses[index].details ?? "", courseTime: self.Courses[index].time ?? "", courseType: self.Courses[index].type ?? "", rating: (self.Courses[index].rate ?? 0.0).rounded(toPlaces: 2), price: Int(self.Courses[index].price ?? "") ?? 0, discountPrice: ((Int(self.Courses[index].price ?? "") ?? 0) - (Int(self.Courses[index].discount ?? "") ?? 0) ), imageURL: self.Courses[index].mainImage ?? "", videoURL: self.Courses[index].courseURL ?? "")
            cell.openDetailsAction = {
                guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsVC") as? CourseDetailsVC else { return }
                main.course_id = self.Courses[index].id ?? 0
                self.navigationController?.pushViewController(main, animated: true)
            }
        }.disposed(by: disposeBag)
        self.CoursesCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsVC") as? CourseDetailsVC else { return }
            main.course_id = self.Courses[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
        self.CoursesCollectionView.rx.contentOffset.bind { (contentOffset) in
            if contentOffset.y + self.CoursesCollectionView.frame.size.height + 10 > self.CoursesCollectionView.contentSize.height && self.loadMore && !self.loading {
                print("searchProductsCollectionView Load More")
                
            }
        }.disposed(by: disposeBag)
    }
}

extension CoursesVC: UICollectionViewDelegateFlowLayout {
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
            return CGSize(width: size, height: (collectionView.frame.size.height + 20) / 2)
        }
    }
}
