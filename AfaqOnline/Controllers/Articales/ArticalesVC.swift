//
//  ArticalesVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
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

class ArticalesVC: UIViewController {

    @IBOutlet weak var CoursesCollectionView: UICollectionView!
    @IBOutlet weak var CategoryTitleLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    

    var disposeBag = DisposeBag()
    var Articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.ArticleVM.fetchArtical(data: self.Articles)
            }
        }
    }
    var ArticleVM = ArticalViewModel()
    
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
        self.hideKeyboardWhenTappedAround()
        self.ArticleVM.showIndicator()
        getMyArticals()
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension ArticalesVC : UICollectionViewDelegate {
    
    func setupCoursesCollectionView() {
        let cellIdentifier = "AllArticalesCell"
        self.CoursesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CoursesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.ArticleVM.Article.bind(to: self.CoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AllArticalesCell.self)) { index, element, cell in
            
            cell.config(articalName: self.Articles[index].title ?? "" , articalInstractor:  "\(self.Articles[index].instructor?.user? .firstName ?? "") \(self.Articles[index].instructor?.user?.lastName ??  "")" , rating: 2.3, imageURL: self.Articles[index].mainImage ?? "")
            
                cell.openDetailsAction = {
                guard let main = UIStoryboard(name: "Articles", bundle: nil).instantiateViewController(withIdentifier: "ArticalesDetailsVC") as? ArticalesDetailsVC else { return }
                    main.Articles = self.Articles[index]
                self.navigationController?.pushViewController(main, animated: true)
            }
        }.disposed(by: disposeBag)
        self.CoursesCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Articles", bundle: nil).instantiateViewController(withIdentifier: "ArticalesDetailsVC") as? ArticalesDetailsVC else { return }
            main.Articles = self.Articles[indexPath.row]
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    
    }
}

extension ArticalesVC : UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1
        
            return CGSize(width: size, height: 140)
        }
}
extension ArticalesVC  {
    func getMyArticals() {
        self.ArticleVM.getMyArtical().subscribe(onNext: { (myArticalModel) in
            if let error = myArticalModel.errors {
                displayMessage(title: "", message: error, status: .error, forController: self)
            } else if let myArticle = myArticalModel.data?.articles {
                self.ArticleVM.dismissIndicator()
                self.Articles = myArticle
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
