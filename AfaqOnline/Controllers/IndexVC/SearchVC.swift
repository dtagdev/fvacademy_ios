//
//  SearchVCcc.swift
//  AfaqOnline
//
//  Created by MAC on 11/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import StepProgressBar
import RxSwift
import RxCocoa
import Cosmos

class SearchVC : UIViewController {

 
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addToCartButton: UIButton!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var ContentTableView: UITableView!
 

 
    private var courseViewModel = CourseDetailsViewModel()
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    var disposeBag = DisposeBag()
    let cellIdentifier = "WishlistCell"
    let headerCellIdentifier = "SearchHeader"
    let arr = ["A","B","C","D","E","F","G","H","I","J","K","L","M","N","O","P","Q","R","S","T","U","V","W","X","Y","Z","#"]

    var courseData : TrendCourse?{
        didSet {
            DispatchQueue.main.async {
                self.ContentTableView.reloadData()
                self.ContentTableView.invalidateIntrinsicContentSize()
                self.ContentTableView.layoutIfNeeded()
            }
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }

        setupContentTableView()
    }
 

    

    @IBAction func AddToCartAction(_ sender: UIButton) {
        addToCartButton.isEnabled = false
        self.addToCart(course_id: 0, price: "", discount: "")
    }
    

    
    @IBAction func backAction(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }
    
 
}

extension SearchVC {
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
            self.addToCartButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.addToCartButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
}



extension SearchVC : UITableViewDelegate, UITableViewDataSource {

    func setupContentTableView() {
        self.ContentTableView.delegate = self
        self.ContentTableView.dataSource = self
        self.searchTableView.delegate = self
        self.searchTableView.dataSource = self

        self.ContentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
       
        self.ContentTableView.register(UINib(nibName: headerCellIdentifier, bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        
        self.searchTableView.register(UINib(nibName: headerCellIdentifier, bundle: nil), forCellReuseIdentifier: headerCellIdentifier)
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        if tableView == ContentTableView {
        return arr.count
        }else{
        return 1
        }
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? SearchHeader else { return UITableViewCell()}
        if tableView == ContentTableView {
        cell.config(letter : arr[section])
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if tableView == ContentTableView {
          return 150
        }else{
            return 18
        }
      }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
       return 30
   }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if tableView == ContentTableView {
           return  1
        }else {
            return arr.count
        }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if tableView == ContentTableView {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? WishlistCell else { return UITableViewCell()}

            return cell
        }else {
            guard let cell = tableView.dequeueReusableCell(withIdentifier: headerCellIdentifier) as? SearchHeader else { return UITableViewCell()}
            cell.config(letter : arr[indexPath.row])
            return cell
        }
    }
}

