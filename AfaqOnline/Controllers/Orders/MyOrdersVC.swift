//
//  CartVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class MyOrdersVC: UIViewController {

    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var OrdersTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var Orders = [MyCoursesData]() {
        didSet {
            DispatchQueue.main.async {
                self.ordersVM.fetchOrders(data: self.Orders)
            }
        }
    }
    var ordersVM = OrdersViewModel()
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
        setupOrdersTableView()
        searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.ordersVM.showIndicator()
        getMyCourses()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }
    
    @IBAction func FiltrationAction(_ sender: UIButton) {
        if self.searchTF.isHidden {
            Constants.shared.searchingEnabled = true
            self.searchTF.isHidden = false
        } else {
            Constants.shared.searchingEnabled = false
            self.searchTF.isHidden = true
        }
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
        window.rootViewController = main
        UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
    }
    @IBAction func SearchDidEndEditing(_ sender: CustomTextField) {
           if Constants.shared.searchingEnabled {
               guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
               main.modalPresentationStyle = .overFullScreen
               main.modalTransitionStyle = .crossDissolve
               main.search_name = self.searchTF.text ?? ""
            self.searchTF.text = ""
            self.searchTF.isHidden = true
               self.present(main, animated: true, completion: nil)
           }
       }
}
extension MyOrdersVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
extension MyOrdersVC: UITableViewDelegate {
    
    func setupOrdersTableView() {
        OrdersTableView.rx.setDelegate(self).disposed(by: disposeBag)
        OrdersTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.ordersVM.Orders.bind(to: self.OrdersTableView.rx.items(cellIdentifier: cellIdentifier, cellType: WishlistCell.self)) { index, element, cell in

            cell.config(InstructorImageUrl: self.Orders[index].mainImage ?? "" , CourseName: self.Orders[index].name ?? "", CourseDescription: self.Orders[index].details ?? "", CoursePrice: Double(self.Orders[index].price ?? "") ?? 0.0, discountedPrice: ((Double(self.Orders[index].price ?? "") ?? 0.0 ) - (Double(self.Orders[index].discount ?? "") ?? 0.0)), EnrolledUserImageURLs: [])
            cell.PriceView.isHidden = true
        }.disposed(by: disposeBag)
        self.OrdersTableView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Courses", bundle: nil).instantiateViewController(withIdentifier: "CourseDetailsVC") as? CourseDetailsVC else { return }
            main.course_id = self.Orders[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
        
        self.OrdersTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 130
    }
}
extension MyOrdersVC {
    func getMyCourses() {
        self.ordersVM.getMyCourses().subscribe(onNext: { (myCoursesModel) in
            if let error = myCoursesModel.errors {
                displayMessage(title: "", message: error, status: .error, forController: self)
            } else if let myCourses = myCoursesModel.data {
                self.ordersVM.dismissIndicator()
                self.Orders = myCourses
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
