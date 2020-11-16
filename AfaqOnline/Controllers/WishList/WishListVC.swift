//
//  WishListVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class WishListVC: UIViewController {

    @IBOutlet weak var WishListTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emptyView : UIView!

    var wishlist = [WishlistData]() {
        didSet {
            DispatchQueue.main.async {
                self.wishlistVM.fetchCourses(data: self.wishlist)
            }
        }
    }
    
    var wishlistVM = WishlistViewModel()
    var disposeBag = DisposeBag()
    
    let cellIdentifier = "WishlistCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupWishlistTableView()
        if Helper.getAPIToken() ?? "" != "" {
            wishlistVM.showIndicator()
            self.getWishlist()
        } else {
            displayMessage(title: "", message: "Please Login First", status: .info, forController: self)
        }
        
    
    }
 
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension WishListVC {
    func getWishlist() {
        self.wishlistVM.getWishlist().subscribe(onNext: { (wishListModel) in
            if let data = wishListModel.data {
                self.wishlistVM.dismissIndicator()
                self.wishlist = data
                if self.wishlist.count > 0 {
                    self.emptyView.isHidden = true
                      }else{
                    self.emptyView.isHidden = false
                      }
            } else {
                displayMessage(title: "", message: "Something went Wrong", status: .info, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    
    func removeFromWishlist(wishlistID: Int) {
        self.wishlistVM.postRemoveFromWishList(wishlistID: wishlistID).subscribe(onNext: { (wishList) in
            if wishList.data ?? false {
                displayMessage(title: "", message: RemoveFromWishListMessage.localized, status: .info, forController: self)
                self.getWishlist()
            } else if wishList.errors != nil {
                displayMessage(title: "", message: wishList.errors ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }
    
}

extension WishListVC: UITableViewDelegate {
    
    func setupWishlistTableView() {
        WishListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        WishListTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.wishlistVM.Courses.bind(to: self.WishListTableView.rx.items(cellIdentifier: cellIdentifier, cellType: WishlistCell.self)) { index, element, cell in
            let courseData = self.wishlist[index].course
            cell.config(InstructorImageUrl: courseData?.mainImage ?? "" , CourseName: courseData?.name ?? "", CourseDescription: courseData?.details ?? "", CoursePrice: Double(courseData?.price ?? "") ?? 0.0, discountedPrice: ((Double(courseData?.price ?? "") ?? 0.0 ) - (Double(courseData?.discount ?? "") ?? 0.0)))
            cell.deleteClosure = {
                self.wishlistVM.showIndicator()
                self.removeFromWishlist(wishlistID : self.wishlist[index].id ?? 0 )
            }
            cell.goForDetails = {

            }
            
        }.disposed(by: disposeBag)
        self.WishListTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        
        self.WishListTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
}
