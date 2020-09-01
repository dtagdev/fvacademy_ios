//
//  CategoriesVCViewController.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class CategoriesVC: UIViewController {

    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var FilterButton: UIButton!
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
    private let categoryViewModel = CategoriesViewModel()
    var disposeBag = DisposeBag()
    var Ads = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.categoryViewModel.fetchAds(Ads: self.Ads)
            }
        }
    }
    var Categories = [CategoryData]() {
        didSet {
            DispatchQueue.main.async {
                self.categoryViewModel.fetchCategories(Categories: self.Categories)
            }
        }
    }
    var previousScreen = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.navigationController?.isNavigationBarHidden = true
        setupAdsCollectionView()
        setupCategoriesCollectionView()
        BindButtonActions()
        SetupSortByDropDown()
        SetupFilterDropDown()
        getCategories()
        self.searchTF.delegate = self
        
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
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
}
extension CategoriesVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}

extension CategoriesVC {
    //MARK:- GET Categories
    func getCategories() {
        self.categoryViewModel.getCategories().subscribe(onNext: { (categoriesModel) in
            if let data = categoriesModel.data {
                self.Categories = data

            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension CategoriesVC: UICollectionViewDelegate {
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
        self.categoryViewModel.Ads.bind(to: self.AdsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AdsCell.self)) { index, element, cell in
            cell.config(Type: "Image", imageURL: "")
            cell.AdOpenActionClosure = {
                
            }
        }.disposed(by: disposeBag)
        self.AdsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
    func setupCategoriesCollectionView() {
        let cellIdentifier = "CategoryCell"
        self.CategoriesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CategoriesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.categoryViewModel.Categories.bind(to: self.CategoriesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CategoryCell.self)) { index, element, cell in
            cell.config(categoryImageURL: "", categoryName: self.Categories[index].name ?? "")
        }.disposed(by: disposeBag)
        self.CategoriesCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CoursesVC") as? CoursesVC else { return }
            main.category_id = self.Categories[indexPath.row].id ?? 0
            main.categoryName = self.Categories[indexPath.row].name ?? ""
            main.type = "category"
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension CategoriesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == AdsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
            return CGSize(width: size, height: size)
        }
    }
}
