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
    
    @IBOutlet weak var searchTF: CustomTextField!
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
            self.getWishlist()
        } else {
            displayMessage(title: "", message: "Please Login First", status: .info, forController: self)
        }
        
        searchTF.delegate = self
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
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
            //self.navigationController?.pushViewController(main, animated: true)
        }
    }
    
}

extension WishListVC {
    func getWishlist() {
        self.wishlistVM.getWishlist().subscribe(onNext: { (wishListModel) in
            if let data = wishListModel.data {
                self.wishlist = data
            } else {
                displayMessage(title: "", message: "Something went Wrong", status: .info, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension WishListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}

extension WishListVC: UITableViewDelegate {
    
    func setupWishlistTableView() {

        WishListTableView.rx.setDelegate(self).disposed(by: disposeBag)
        WishListTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.wishlistVM.Courses.bind(to: self.WishListTableView.rx.items(cellIdentifier: cellIdentifier, cellType: WishlistCell.self)) { index, element, cell in
            let courseData = self.wishlist[index].courseData ?? CourseData()
            cell.config(InstructorImageUrl: "", CourseName: courseData.name ?? "", CourseDescription: courseData.details ?? "", CoursePrice: Int(courseData.price ?? "") ?? 0, discountedPrice: 0, EnrolledUserImageURLs: [])
            cell.PriceView.isHidden = false
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
