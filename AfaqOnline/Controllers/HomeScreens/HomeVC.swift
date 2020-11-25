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
    @IBOutlet weak var articalCollectionView: CustomCollectionView!
    @IBOutlet weak var TrendingButton: UIButton!
    @IBOutlet weak var CategoryButton: UIButton!
    @IBOutlet weak var InstructorButton: UIButton!
    @IBOutlet weak var EventsButton: UIButton!
    @IBOutlet weak var articalButton: UIButton!
    @IBOutlet weak var logoImage : UIImageView!
    @IBOutlet weak var smalllogoImage : UIImageView!

    

    
    private let homeViewModel = HomeViewModel()
    private var courseViewModel = CourseDetailsViewModel()

    var disposeBag = DisposeBag()
    var Ads = ["Test"]{
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchAds(Ads: self.Ads)
          }
     }
    }
    
    var Courses = [TrendCourse]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchCourses(Courses: self.Courses)
            }
        }
    }
    var Events = [Event]()
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
    var Instructors = [Instructor]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchInstructors(Instructors: self.Instructors)
            }
        }
    }
    
    var Articals = [Article]() {
           didSet {
               DispatchQueue.main.async {
                   self.homeViewModel.fetchArtical(Artical: self.Articals)
               }
           }
       }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if "lang".localized == "ar" {
            logoImage.image = #imageLiteral(resourceName: "Mask Group 19-1")
            smalllogoImage.isHidden = true
             }else {
            logoImage.image = #imageLiteral(resourceName: "Mask Group20")
            smalllogoImage.isHidden = false

            }
        
        // Do any additional setup after loading the view.
        setupAdsCollectionView()
        setupCoursesCollectionView()
        setupCategoryCollectionView()
        setupEventsCollectionView()
        setupInstructorCollectionView()
         setupArticalCollectionView()
        self.getHomeData()
        self.hideKeyboardWhenTappedAround()
        self.homeViewModel.showIndicator()
        
        if Helper.getUserID() ?? 0 == 0{
        let endEditting = UITapGestureRecognizer(target: self, action:#selector(HomeVC.endEditting(sender:)))
        view.addGestureRecognizer(endEditting)
        }
     }
    
    @objc func endEditting(sender: UITapGestureRecognizer) {
        displayMessage(title: "", message: "Please Login First", status: .info, forController: self)
    guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
    self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    @IBAction func SeeAllActions(_ sender: UIButton) {
        if Helper.getUserID() ?? 0 == 0 {
        displayMessage(title: "", message: "Please Login First", status: .info, forController: self)
        }else{
        switch sender.tag {
        case 1:
            print("Trending Action")
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CoursesVC") as? CoursesVC else { return }
            main.categoryName = "Trending"
            main.Courses = self.Courses
            main.type = "home"
            self.navigationController?.pushViewController(main, animated: true)
        case 2:
            guard let main = UIStoryboard(name: "Live", bundle: nil).instantiateViewController(withIdentifier: "LiveVC") as? LiveVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        case 3:
            print("Category Action")
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "CategoriesVC") as? CategoriesVC else { return }
            main.previousScreen = "home"
            self.navigationController?.pushViewController(main, animated: true)
        case 4:
            guard let main = UIStoryboard(name: "Articles", bundle: nil).instantiateViewController(withIdentifier: "ArticalesVC") as? ArticalesVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        case 5:
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstructorsVC") as? InstructorsVC else { return }
           self.navigationController?.pushViewController(main, animated: true)
            
        default:
            break
            }
        }
    }
    
    @IBAction func instractorAction(_ sender: UIButton) {
        guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
           main.type = "Instructor"
           self.navigationController?.pushViewController(main, animated: true)
         }
    
    
   @IBAction func startTodayAction(_ sender: UIButton) {
      guard let main = UIStoryboard(name: "Search", bundle: nil).instantiateViewController(withIdentifier: "SearchVC") as? SearchVC else { return }
         self.navigationController?.pushViewController(main, animated: true)
     }
    
    
    @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
        self.setupSideMenu()
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
           // self.addToCartButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
          //  self.addToCartButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
    
}
//MARK:- Retrieving Backend Data
extension HomeVC {
    func getHomeData() {
        self.homeViewModel.getHomeData().subscribe(onNext: { (homeData) in
            if homeData.status ?? false {
                if let data = homeData.data {
                    self.homeViewModel.dismissIndicator()
                    self.Courses = data.courses ?? []
                    self.Categories = data.categories ?? []
                    self.Instructors = data.instructors ?? []
                    self.Articals = data.articles ?? []
                    self.Events = data.events ?? []
                    self.EventsButton.setTitle("See All ( \(self.Courses.count) )", for: .normal)
                    self.TrendingButton.setTitle("See All ( \(self.Courses.count) )", for: .normal)
                    self.CategoryButton.setTitle("See All ( \(self.Categories.count) )", for: .normal)
                    self.InstructorButton.setTitle("See All ( \(self.Instructors.count) )", for: .normal)
                    self.EventsButton.setTitle("See All ( \(self.Events.count) )", for: .normal)
                    self.articalButton.setTitle("See All ( \(self.Articals.count) )", for: .normal)
                    self.homeViewModel.fetchAds(Ads: self.Ads)
                }
                
            }
        }, onError: { (error) in
            self.homeViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
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
            
            cell.config(courseName: self.Courses[index].name ?? "", courseInstractor: "\(self.Courses[index].instructor?.user?.firstName ?? "") \(self.Courses[index].instructor?.user?.lastName ??  "")", courseTime: self.Courses[index].time ?? "", courseType: self.Courses[index].type ?? "", rating: ((self.Courses[index].rate?.rounded(toPlaces: 1) ?? 0)), price: Double(self.Courses[index].price ?? "0") ?? 0.0, discountPrice: ((Double(self.Courses[index].price ?? "") ?? 0.0) - (Double(self.Courses[index].discount ?? "") ?? 0.0)), imageURL: self.Courses[index].mainImage ?? "", videoURL: self.Courses[index].courseURL ?? "")
            cell.addToCart = {
                self.addToCart(course_id: self.Courses[index].id ?? 0 , price: self.Courses[index].price ?? "0",discount : self.Courses[index].discount ?? "")
            }
            cell.openDetailsAction = {
                guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsVC") as? CourseDetailsVC else { return }
                main.course_id = self.Courses[index].id ?? 0
                self.navigationController?.pushViewController(main, animated: true)
            }
        }.disposed(by: disposeBag)
        self.CoursesCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsVC") as? CourseDetailsVC else { return }
              DispatchQueue.main.async {
                main.course_id = self.Courses[indexPath.row].id ?? 0
                    }
            
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func setupEventsCollectionView() {
        let cellIdentifier = "LiveCell"
        self.EventsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.EventsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Events.bind(to: self.EventsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: LiveCell.self)) { index, element, cell in
          
            let dis =   (Double(self.Events[index].discount ?? "") ?? 0.0)
            let price = (Double(self.Events[index].price ?? "") ?? 0.0)
            let result = price - dis
            
            cell.config(eventName: self.Events[index].name ?? "", eventDesc: self.Events[index].eventDescription ?? "", eventStartTime: self.Events[index].startDate ?? "", eventEndTime: self.Events[index].endDate ?? "", eventType: "", rating: ((self.Events[index].rate?.rounded(toPlaces: 1) ?? 0)) , price: Double(self.Events[index].price ?? "") ?? 0.0, discountPrice: result, imageURL: self.Events[index].mainImage ?? "" , videoURL: self.Events[index].eventURL ?? "" , userImages: [""])
            cell.openDetailsAction = {
                guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            }
        }.disposed(by: disposeBag)
        self.EventsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC else { return }
            main.event_id = self.Events[indexPath.row].id ?? 0 
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
    
    func setupCategoryCollectionView() {
        let cellIdentifier = "HomeCategoryCell"
        self.CategoryCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CategoryCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Categories.bind(to: self.CategoryCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeCategoryCell.self)) { index, element, cell in
            cell.config(categoryImageURL: self.Categories[index].image ?? "", categoryName: self.Categories[index].name ?? "")
        }.disposed(by: disposeBag)
        self.CategoryCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "CategoriesDetailsVC") as? CategoriesDetailsVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
    func setupArticalCollectionView(){
        let cellIdentifier = "HomeArticalsCell"
        self.articalCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.articalCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Articals.bind(to: self.articalCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeArticalsCell.self)) { index, element, cell in
            cell.config(articalName: self.Articals[index].title ?? "", articalDesc: self.Articals[index].details ?? "", rating: ((self.Events[index].rate?.rounded(toPlaces: 1) ?? 0)), imageURL: self.Articals[index].mainImage ?? "")
        }.disposed(by: disposeBag)
        self.articalCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Articles", bundle: nil).instantiateViewController(withIdentifier: "ArticalesDetailsVC") as? ArticalesDetailsVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    
    }
    
    func setupInstructorCollectionView() {
        
        let cellIdentifier = "HomeInstructorCell"
        self.InstructorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.InstructorsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Instructors.bind(to: self.InstructorsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeInstructorCell.self)) { index, element, cell in
            let instructorData = self.Instructors[index].user
            cell.config(InstructorImageURL: self.Instructors[index].image ?? "", InstructorName: "\(instructorData?.firstName ?? "") \(instructorData?.lastName ??  "")",rating:((self.Instructors[index].rate?.rounded(toPlaces: 1) ?? 0)))
        }.disposed(by: disposeBag)
        self.InstructorsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstractorProfileVc") as? InstractorProfileVc else { return }
            main.id = self.Instructors[indexPath.row].id ?? 0
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
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
            
        }else if collectionView == articalCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else if collectionView == EventsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
            
        } else if collectionView == CategoryCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 4
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
                return CGSize(width: 140, height: 140)
        }
    }
}
