//
//  MyCartVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/5/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class MyCartVC: UIViewController {

    @IBOutlet weak var CartTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var CartTableViewHieht: NSLayoutConstraint!
    @IBOutlet weak var emptyView : UIView!

    
    var orderVM = OrdersViewModel()
    var disposeBag = DisposeBag()

    var items = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.orderVM.fetchCartItems(items: self.items)
                self.CartTableViewHieht.constant = CGFloat(self.items.count * 150)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCartTableView()
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.hideKeyboardWhenTappedAround()
       // self.getCart()
       // orderVM.showIndicator()
        
        if items.count > 0{
            emptyView.isHidden = true
        }else{
            emptyView.isHidden = false
        }
        
    }
 
 
        @IBAction func BackAction(_ sender: UIButton) {
             guard let window = UIApplication.shared.keyWindow else { return }
                   guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
                   window.rootViewController = main
                   UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
        }
    

    @IBAction func BrowseMoreAction(_ sender: CustomButtons) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
        main.setSelectIndex(from: 0, to: 0)
        window.rootViewController = main
        UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
    }
    @IBAction func ContinueToCheckoutAction(_ sender: CustomButtons) {
        guard let main = UIStoryboard(name: "PaymentMethod", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC else { return }
        main.price = "25 SAR"
        self.navigationController?.pushViewController(main, animated: true)
    }
}


extension MyCartVC: UITableViewDelegate {
    func setupCartTableView() {
       // self.items = ["7","6","4","2","1"]
        let cellIdentifier = "CartCell"
        self.CartTableView.rx.setDelegate(self).disposed(by: disposeBag)
       // self.CartTableView.rowHeight = UITableView.automaticDimension
        //self.CartTableView.estimatedRowHeight = UITableView.automaticDimension
        self.CartTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.orderVM.CartItems.bind(to: self.CartTableView.rx.items(cellIdentifier: cellIdentifier, cellType: CartCell.self)) { [weak self] index, element, cell in
          //  cell.config(courseName: self?.items[index].course?.name ?? "" , courseDesc: self?.items[index].course?.details ?? "" , coursePrice: (Double(self?.items[index].price ?? "") ?? 0.0))
//            cell.deleteClosure = {
//                self?.orderVM.showIndicator()
//                self?.removeFromWishlist(course_id :self?.items[index].id ?? 0 )
//            }
        }.disposed(by: disposeBag)
        
        self.CartTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.CartTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
        
        
    }
    
    
      func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
          return 150
      }
    
}

extension MyCartVC {
    func getCart() {
        self.orderVM.getMyCart().subscribe(onNext: { (myCartModel) in
            if let error = myCartModel.errors {
            self.orderVM.dismissIndicator()
            displayMessage(title: "", message: error, status: .error, forController: self)
            } else if let item = myCartModel.data {
            self.orderVM.dismissIndicator()
            //self.items = item
            }
        }, onError: { (error) in
            self.orderVM.dismissIndicator()
         displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
      }
    
    func removeFromWishlist(course_id: Int) {
        self.orderVM.postRemoveCart(course_id: course_id).subscribe(onNext: { (Cart) in
            if Cart.status ?? false {
                displayMessage(title: "", message: "done", status: .info, forController: self)
                self.getCart()
            } else if Cart.errors != nil {
                displayMessage(title: "", message: Cart.errors ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }
}
