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

    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    private let categoryViewModel = CategoriesViewModel()
    var disposeBag = DisposeBag()

    var Categories = [Category]() {
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
        setupCategoriesCollectionView()
        self.categoryViewModel.showIndicator()
        getCategories(lth: 0,htl: 0,rate : 0)
        
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
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
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
}

extension CategoriesVC {
    //MARK:- GET Categories
    func getCategories(lth: Int,htl: Int,rate : Int) {
         self.categoryViewModel.getCategories(lth: lth,htl: htl,rate : rate).subscribe(onNext: { (categoriesModel) in
             if let data = categoriesModel.data {
                 self.categoryViewModel.dismissIndicator()
                 self.Categories = data
             }
         }, onError: { (error) in
             self.categoryViewModel.dismissIndicator()
             displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
             }).disposed(by: disposeBag)
     }
}

extension CategoriesVC: UICollectionViewDelegate {
    func setupCategoriesCollectionView() {
        let cellIdentifier = "CategoryCell"
        self.CategoriesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CategoriesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.categoryViewModel.Categories.bind(to: self.CategoriesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CategoryCell.self)) { index, element, cell in
            cell.config(categoryImageURL:self.Categories[index].image ?? "", categoryName: self.Categories[index].name ?? "")
        }.disposed(by: disposeBag)
        self.CategoriesCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "CategoriesDetailsVC") as? CategoriesDetailsVC else { return }
         self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension CategoriesVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
            return CGSize(width: size, height: size)
        
    }
}
