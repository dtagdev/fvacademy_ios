//
//  FiltrationVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/9/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Cosmos

class FiltrationVC: UIViewController {

    @IBOutlet weak var maximumSliderLabel: UILabel!
    @IBOutlet weak var minimumSliderLabel: UILabel!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var filtrationSlider: UISlider!
    @IBOutlet weak var CategoriesCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    private let cellIdentifier = "FiltrationCell"
    var categories = [CategoryData]() {
        didSet {
            DispatchQueue.main.async {
                self.categoriesVM.fetchCategories(Categories: self.categories)
            }
        }
    }
    private let categoriesVM = CategoriesViewModel()
    
    var disposeBag = DisposeBag()
    var selectedCategory = String()
    var currentRating = Double()
    var search_name = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupCategoriesCollectionView()
        self.getCategories()
        filtrationSlider.setThumbImage(#imageLiteral(resourceName: "LocationThumb"), for: .normal)

        self.ratingView.didTouchCosmos = { (rating) in
            self.currentRating = rating
            }
        self.hideKeyboardWhenTappedAround()
    }
    @IBAction func SliderCurrentChange(_ sender: CustomSlider) {
        let trackRect =  self.filtrationSlider.trackRect(forBounds: self.filtrationSlider.bounds)

        self.filtrationSlider.thumbRect(forBounds: CGRect(x: self.filtrationSlider.center.x, y: -30, width: 75, height: 75), trackRect: trackRect, value: self.filtrationSlider.value)
    }
    @IBAction func dismissAction(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func SearchAction(_ sender: CustomButtons) {
        guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "SearchResultsVC") as? SearchResultsVC else { return }
//        self.navigationController?.pushViewController(main, animated: true)
        main.modalPresentationStyle = .overFullScreen
        main.modalTransitionStyle = .crossDissolve
        main.search_name = self.search_name
        self.present(main, animated: true, completion: nil)
    }
}

extension FiltrationVC {
    //MARK:- GET Categories
    func getCategories() {
        self.categoriesVM.getCategories().subscribe(onNext: { (categoriesModel) in
            if let data = categoriesModel.data {
                self.categories = data
                self.categories.append(CategoryData(id: nil, name: "Test3", img: nil, createdAt: nil, updatedAt: nil, selected: false))
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension FiltrationVC: UICollectionViewDelegate {
    func setupCategoriesCollectionView() {
        self.CategoriesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CategoriesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.categoriesVM.Categories.bind(to: self.CategoriesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: FiltrationCell.self)) { index, element, cell in
            cell.config(CategoryName: self.categories[index].name ?? "", selected: self.categories[index].selected ?? false)
        }.disposed(by: disposeBag)
        self.CategoriesCollectionView.rx.itemSelected.bind { (indexPath) in
            for i in 0..<self.categories.count {
                if i == indexPath.row {
                    self.categories[i].selected = true
                } else {
                    self.categories[i].selected = false
                }
            }
            self.selectedCategory = self.categories[indexPath.row].name ?? ""
        }.disposed(by: disposeBag)
        self.CategoriesCollectionView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
}


extension FiltrationVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
        return CGSize(width: size, height: 50)
    }
}
