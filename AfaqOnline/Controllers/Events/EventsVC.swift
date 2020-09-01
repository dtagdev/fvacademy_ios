//
//  EventsVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class EventsVC: UIViewController {
    
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var EventsCollectionView: UICollectionView!
    @IBOutlet weak var CategoryTitleLabel: UILabel!
    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var searchTF: CustomTextField!
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
    private let eventViewModel = EventsViewModel()
    var category_id = Int()
    var disposeBag = DisposeBag()
    var Ads = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.eventViewModel.fetchAds(Ads: self.Ads)
            }
        }
    }
    var Events = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.eventViewModel.fetchEvents(Events: self.Events)
            }
        }
    }
    var categoryName = String()
    var currentPage = 1
    var loading = false
    var loadMore = false
    var type = String()
    var previousScreen = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupAdsCollectionView()
        setupEventsCollectionView()
        BindButtonActions()
        SetupSortByDropDown()
        SetupFilterDropDown()
        if categoryName != "" {
            self.CategoryTitleLabel.text = categoryName + " Event"
        }
        
//        if type == "home" {
//            self.getAllCourses(page: self.currentPage)
//        } else {
//            getCourses(category_id: category_id)
//        }
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func backAction(_ sender: UIButton) {
        if previousScreen == "home" {
            self.navigationController?.popViewController(animated: true)
        } else {
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

extension EventsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}

extension EventsVC {
    
//    func getNextPage() {
//        self.getAllCourses(page: self.currentPage)
//    }
//    func getAllCourses(page: Int) {
//        self.coursesViewModel.getAllCourses(page: page).subscribe(onNext: { (CoursesModelJSON) in
//            if let data = CoursesModelJSON.data?.data {
//                if !self.loadMore {
//                    self.Events = data
//
//                } else {
//                    self.Events.append(contentsOf: data)
//                }
//
//                let dataClass = CoursesModelJSON.data ?? CoursesDataClass()
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
//
//                self.loading = false
//            }
//        }, onError: { (error) in
//            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
//        }).disposed(by: disposeBag)
//    }
}
extension EventsVC : UICollectionViewDelegate {
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
        self.eventViewModel.Ads.bind(to: self.AdsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AdsCell.self)) { index, element, cell in
            cell.config(Type: "Image", imageURL: "")
            cell.AdOpenActionClosure = {
                
            }
        }.disposed(by: disposeBag)
        self.AdsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    
    func setupEventsCollectionView() {
        self.Events = ["Test", "Test2"]
        let cellIdentifier = "EventsCell"
        self.EventsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.EventsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.eventViewModel.Events.bind(to: self.EventsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: EventsCell.self)) { index, element, cell in
            cell.config(eventName: self.Events[index], eventDesc: "", eventStartTime: "16 July 2020", eventEndTime: "31 July 2020", eventType: "", rating: 4.5, price: 300, discountPrice: 200, imageURL: "", videoURL: "", userImages: [""])
            cell.openDetailsAction = {
                
            }
        }.disposed(by: disposeBag)
        self.EventsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
        self.EventsCollectionView.rx.contentOffset.bind { (contentOffset) in
            if contentOffset.y + self.EventsCollectionView.frame.size.height + 10 > self.EventsCollectionView.contentSize.height && self.loadMore && !self.loading {
                print("searchProductsCollectionView Load More")
                
            }
        }.disposed(by: disposeBag)
    }
}

extension EventsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == AdsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: 200)
        }
    }
}
