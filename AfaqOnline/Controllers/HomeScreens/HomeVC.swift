//
//  HomeVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class HomeVC: UIViewController {

    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var CoursesCollectionView: CustomCollectionView!
    @IBOutlet weak var CategoryCollectionView: CustomCollectionView!
    @IBOutlet weak var InstructorsCollectionView: CustomCollectionView!
    @IBOutlet weak var EventsCollectionView: CustomCollectionView!
    @IBOutlet weak var TrendingButton: UIButton!
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var InstructorButton: UIButton!
    @IBOutlet weak var EventsButton: UIButton!
    @IBOutlet weak var searchTF: UITextField!
    @IBOutlet weak var backButton: UIButton!
    
    private let homeViewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    var Ads = ["Test"]
//        [String]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.homeViewModel.fetchAds(Ads: self.Ads)
//            }
//        }
//    }
    var Courses = [CoursesData]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchCourses(Courses: self.Courses)
            }
        }
    }
    var Events = [String]()
    {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchEvents(Events: self.Events)
            }
        }
    }
    var Categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchCategories(Categories: self.Categories)
            }
        }
    }
    var Instructors = [Instructore]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchInstructors(Instructors: self.Instructors)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupAdsCollectionView()
        setupCoursesCollectionView()
        setupCategoryCollectionView()
        setupEventsCollectionView()
        setupInstructorCollectionView()
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.getHomeData()
        self.searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }
    @IBAction func SeeAllActions(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            print("Trending Action")
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CoursesVC") as? CoursesVC else { return }
            main.categoryName = "Trending"
            main.Courses = self.Courses
            main.type = "home"
            self.navigationController?.pushViewController(main, animated: true)
        case 2:
            print("Events Action")
            guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsVC") as? EventsVC else { return }
            main.previousScreen = "home"
            self.navigationController?.pushViewController(main, animated: true)
        case 3:
            print("Category Action")
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "CategoriesVC") as? CategoriesVC else { return }
            main.previousScreen = "home"
            self.navigationController?.pushViewController(main, animated: true)
        case 4:
            print("Instuctor Action")
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstructorsVC") as? InstructorsVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        default:
            break
        }
    }
    @IBAction func FiltrationAction(_ sender: UIButton) {
        if self.searchTF.isHidden {
            Constants.shared.searchingEnabled = true
            self.searchTF.isHidden = false
        } else {
            Constants.shared.searchingEnabled = false
            self.searchTF.isHidden = true
        }
    }
    @IBAction func BackAction(_ sender: UIButton) {
        let alert = UIAlertController(title: "Logout", message: "Are you sure you want to Log out?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            Helper.LogOut()
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "AuthenticationPageVC") as? AuthenticationPageVC else { return }
            main.currentPage = 1
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
        }
        
        yesAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        cancelAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
        alert.addAction(yesAction)
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    
    @IBAction func SearchDidEndEditing(_ sender: CustomTextField) {
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
    
    
}
//MARK:- Retrieving Backend Data
extension HomeVC {
    func getHomeData() {
        self.homeViewModel.getHomeData().subscribe(onNext: { (homeData) in
            if homeData.status ?? false {
                if let data = homeData.data {
                    self.Courses = data.trendCourses ?? []
                    self.Categories = data.categories ?? []
                    self.Instructors = data.instructores ?? []
                    self.TrendingButton.setTitle("See All ( \(self.Courses.count) )", for: .normal)
                    self.CategoryButton.setTitle("See All ( \(self.Categories.count) )", for: .normal)
                    self.InstructorButton.setTitle("See All ( \(self.Instructors.count) )", for: .normal)
                    self.homeViewModel.fetchAds(Ads: self.Ads)
                }
                
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension HomeVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
//MARK:- Data Binding
extension HomeVC: UICollectionViewDelegate {
    func setupAdsCollectionView() {
        let cellIdentifier = "AdsCell"
        self.AdsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.AdsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Ads.bind(to: self.AdsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AdsCell.self)) { index, element, cell in
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
        self.homeViewModel.Courses.bind(to: self.CoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CoursesCell.self)) { index, element, cell in
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
    }
    
    func setupEventsCollectionView() {
        self.Events = ["8th Pediatric MCQ Event","8th Pediatric MCQ Event2"]
        self.EventsButton.setTitle("See all ( \(self.Events.count) )", for: .normal)
        let cellIdentifier = "EventsCell"
        self.EventsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.EventsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Events.bind(to: self.EventsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: EventsCell.self)) { index, element, cell in
            cell.config(eventName: self.Events[index], eventDesc: "", eventStartTime: "16 July 2020", eventEndTime: "31 July 2020", eventType: "", rating: 4.5, price: 300, discountPrice: 200, imageURL: "", videoURL: "", userImages: [""])
            cell.openDetailsAction = {
                guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            }
        }.disposed(by: disposeBag)
        self.EventsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func setupCategoryCollectionView() {
        let cellIdentifier = "HomeCategoryCell"
        self.CategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CategoryCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Categories.bind(to: self.CategoryCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeCategoryCell.self)) { index, element, cell in
            cell.config(categoryImageURL: "", categoryName: self.Categories[index].name ?? "")
        }.disposed(by: disposeBag)
        self.CategoryCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CoursesVC") as? CoursesVC else { return }
            main.category_id = self.Categories[indexPath.row].id ?? 0
            main.categoryName = self.Categories[indexPath.row].name ?? ""
            main.type = "category"
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
    func setupInstructorCollectionView() {
        let cellIdentifier = "HomeInstructorCell"
        self.InstructorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.InstructorsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Instructors.bind(to: self.InstructorsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeInstructorCell.self)) { index, element, cell in
            let instructorData = self.Instructors[index].userData ?? UserData()
            cell.config(InstructorImageURL: "", InstructorName: "\(instructorData.firstName ?? "") \(instructorData.lastName ?? "")")
        }.disposed(by: disposeBag)
        self.InstructorsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstructorsVC") as? InstructorsVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
}


extension HomeVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == AdsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else if collectionView == CoursesCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.01
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else if collectionView == EventsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.01
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else if collectionView == CategoryCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
//            let size:CGFloat = (collectionView.frame.size.width - space) / 6
            return CGSize(width: 90, height: 90)
        }
    }
}
