////
////  AuthenticationPageVC.swift
////  AfaqOnline
////
////  Created by MGoKu on 5/17/20.
////  Copyright © 2020 Dtag. All rights reserved.
////
//
//import UIKit
//import Parchment
//
//class AuthenticationPageVC: UIViewController {
//
//    @IBOutlet weak var PagingView: UIView!
//    
//    let pagingViewController = PagingViewController()
//    var titles = [String]()
//    var currentPage = Int()
//    override func viewDidLoad() {
//        super.viewDidLoad()
//
//        // Do any additional setup after loading the view.
//        setupPagingVC()
//        NotificationCenter.default.addObserver(self, selector: #selector(NavigateToLogin), name: Notification.Name("NavigateToLogin"), object: nil)
//        NotificationCenter.default.addObserver(self, selector: #selector(NavigateToRegister), name: Notification.Name("NavigateToRegister"), object: nil)
//        
//    }
//    override func viewDidDisappear(_ animated: Bool) {
//        super.viewDidDisappear(true)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("NavigateToLogin"), object: nil)
//        NotificationCenter.default.removeObserver(self, name: Notification.Name("NavigateToRegister"), object: nil)
//    }
//    @objc func NavigateToLogin() {
//        pagingViewController.select(index: 1, animated: true)
//    }
//    @objc func NavigateToRegister() {
//        pagingViewController.select(index: 0, animated: true)
//    }
//    func setupPagingVC() {
//        pagingViewController.delegate = self
//        pagingViewController.dataSource = self
//        pagingViewController.sizeDelegate = self
//        pagingViewController.selectedTextColor = #colorLiteral(red: 0.05306091905, green: 0.3024232388, blue: 0.5038945079, alpha: 1)
//        pagingViewController.textColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
//        pagingViewController.font = UIFont.boldSystemFont(ofSize: 25)
//        pagingViewController.selectedFont = UIFont.boldSystemFont(ofSize: 30)
//        pagingViewController.backgroundColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 0)
//        pagingViewController.menuBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
//        pagingViewController.menuHorizontalAlignment = .center
//        pagingViewController.indicatorColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//        pagingViewController.indicatorOptions = .hidden
//        pagingViewController.menuBackgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0)
//        pagingViewController.borderOptions = .hidden
//        pagingViewController.menuItemSpacing = 20
////        pagingViewController.menuItemSize = .sizeToFit(minWidth: 150, height: 40)
//        pagingViewController.collectionView.layer.cornerRadius = 15
//        if "lang".localized == "ar" {
//            self.titles = ["التسجيل", "تسجيل الدخول", "نسيت كلمة المرور؟"]
//            pagingViewController.reloadMenu()
//        } else {
//            self.titles = ["Sign Up", "Log In", "Forget Password"]
//            pagingViewController.reloadMenu()
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            self.pagingViewController.select(index: self.currentPage, animated: true)
//        }
//        
//        addChild(pagingViewController)
//        PagingView.addSubview(pagingViewController.view)
//        PagingView.constrainToEdges(pagingViewController.view, Topconstant: 0)
//        pagingViewController.didMove(toParent: self)
//    }
//}
//
//extension AuthenticationPageVC: PagingViewControllerDataSource {
//    func numberOfViewControllers(in pagingViewController: PagingViewController) -> Int {
//        return titles.count
//    }
//    func pagingViewController(_: PagingViewController, viewControllerAt index: Int) -> UIViewController {
//        
//        switch index {
//        case 0:
//            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return UIViewController()}
//            return main
//        case 1:
//            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return UIViewController()}
//            return main
//        case 2:
//            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC else { return UIViewController()}
//            return main
//            
//        default:
//            print("Not Handled Yet")
//            return UIViewController()
//        }
//    }
//    
//    func pagingViewController(_: PagingViewController, pagingItemAt index: Int) -> PagingItem {
//        
//        return PagingIndexItem(index: index, title: self.titles[index])
//    }
//    
//}
//
//extension AuthenticationPageVC: PagingViewControllerDelegate, PagingViewControllerSizeDelegate {
//    func pagingViewController(_: PagingViewController, widthForPagingItem pagingItem: PagingItem, isSelected: Bool) -> CGFloat {
//        guard let item = pagingItem as? PagingIndexItem else { return 0}
////        let insets = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
////
////        let size = CGSize(width: pagingViewController.menuItemSize.width, height: pagingViewController.menuItemSize.height)
////        let attributes = [NSAttributedString.Key.font: pagingViewController.font]
//        
//        let titleWidth = item.title.size(withAttributes: [NSAttributedString.Key.font: pagingViewController.font])
//        let width = titleWidth.width //ceil(rect.width) + insets.left + insets.right
//        let SelectedtitleWidth = item.title.size(withAttributes: [NSAttributedString.Key.font: pagingViewController.selectedFont])
//        let selectedWidth = SelectedtitleWidth.width
//        if isSelected {
//            print(selectedWidth)
//            
//            return selectedWidth + 80
//            
//        } else {
//            print(width)
//            return width + 20
//            
//        }
//    }
//    
//    
//}
