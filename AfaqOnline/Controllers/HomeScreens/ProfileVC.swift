//
//  ProfileVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ProfileVC: UIViewController {

//    @IBOutlet weak var ProfileImageView: CustomImageView!
//    @IBOutlet weak var UserNameLabel: UILabel!
//    @IBOutlet weak var EmailLabel: UILabel!
//    @IBOutlet weak var ProfileTableView: UITableView!
//    @IBOutlet weak var searchTF: CustomTextField!
//    @IBOutlet weak var backButton: UIButton!
//    let token = Helper.getAPIToken() ?? ""
//    private let cellIdentifier = "ProfileCell"
//    @IBOutlet weak var profileViewHeight: NSLayoutConstraint!
//
//    private var ProfileVM = ProfileViewModel()
//
//    var disposeBag = DisposeBag()
//    var Items = [SideMenuModel]() {
//        didSet {
//            DispatchQueue.main.async {
//                self.ProfileVM.fetchItems(data: self.Items)
//            }
//        }
//    }
//
    override func viewDidLoad() {
        super.viewDidLoad()

//        // Do any additional setup after loading the view.
//        setupProfileTableView()
//        if "lang".localized == "ar" {
//            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
//        } else {
//            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
//        }
//        searchTF.delegate = self
//        self.hideKeyboardWhenTappedAround()
    }
//    override func viewWillAppear(_ animated: Bool) {
//        super.viewWillAppear(true)
//        searchTF.isHidden = true
//        searchTF.text = ""
//        if token != "" {
//            self.getProfile()
//            self.profileViewHeight.constant = 170
//        } else {
//            self.profileViewHeight.constant = 0
//        }
//
//    }
//    @IBAction func BackAction(_ sender: UIButton) {
//        guard let window = UIApplication.shared.keyWindow else { return }
//        guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
////        main.setSelectIndex(from: 0, to: 1)
//        window.rootViewController = main
//        UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
//    }
    
//    @IBAction func EditProfileAction(_ sender: CustomButtons) {
//    guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC else { return }
//        self.navigationController?.pushViewController(main, animated: true)
//    }
//    func selectionAction(index: Int) {
//        for i in 0..<self.Items.count {
//            if i == index {
//                self.Items[i].Selected = true
//            } else {
//                self.Items[i].Selected = false
//            }
//        }
//        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
//            switch self.Items[index].Id ?? "" {
//            case "Notification":
//                print("")
//            case "Order":
//                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC else { return }
//                self.navigationController?.pushViewController(main, animated: true)
//            case "Wishlist":
//                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "WishListVC") as? WishListVC else { return }
//                self.navigationController?.pushViewController(main, animated: true)
//            case "Password":
//                print("")
//            case "Lang":
//                guard let window = UIApplication.shared.keyWindow else { return }
//                guard let main = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LanguageScreenVC") as? LanguageScreenVC else { return }
//                main.type = "home"
//                window.rootViewController = main
//                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
//            case "About":
//                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "AboutAppVC") as? AboutAppVC else { return }
//                main.appPageType = "About"
//                self.navigationController?.pushViewController(main, animated: true)
//            case "Privacy":
//                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "AboutAppVC") as? AboutAppVC else { return }
//                main.appPageType = "Return"
//                self.navigationController?.pushViewController(main, animated: true)
//            case "Terms":
//              guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "AboutAppVC") as? AboutAppVC else { return }
//              main.appPageType = "Terms"
//                self.navigationController?.pushViewController(main, animated: true)
//            case "News":
//                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "ArticalListVC") as? ArticalListVC else { return }
//                self.navigationController?.pushViewController(main, animated: true)
//            case "ContactUs":
//                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else { return }
//                self.navigationController?.pushViewController(main, animated: true)
//            case "Logout":
//                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to Log out?", preferredStyle: .alert)
//                let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
//                    alert.dismiss(animated: true, completion: nil)
//                    Helper.LogOut()
//                    guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
//                    self.navigationController?.pushViewController(main, animated: true)
//
//                }
//                yesAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
//                let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
//                cancelAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
//                alert.addAction(yesAction)
//                alert.addAction(cancelAction)
//                self.present(alert, animated: true, completion: nil)
//            case "Login":
//                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
//                self.navigationController?.pushViewController(main, animated: true)
//
//            default:
//                break
//            }
//        }
//
//    }
//    @IBAction func SearchAction(_ sender: UIButton) {
//        if self.searchTF.isHidden {
//            Constants.shared.searchingEnabled = true
//            self.searchTF.isHidden = false
//        } else {
//            Constants.shared.searchingEnabled = false
//            self.searchTF.isHidden = true
//        }
//    }
//    @IBAction func searchDidEndEditing(_ sender: CustomTextField) {
//        if Constants.shared.searchingEnabled {
//            guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
//            main.modalPresentationStyle = .overFullScreen
//            main.modalTransitionStyle = .crossDissolve
//            main.search_name = self.searchTF.text ?? ""
//            self.searchTF.text = ""
//            self.searchTF.isHidden = true
//            self.present(main, animated: true, completion: nil)
//            //self.navigationController?.pushViewController(main, animated: true)
//        }
//
//
//    }
}
//extension ProfileVC: UITextFieldDelegate {
//    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
//        self.searchTF.resignFirstResponder()
//        return true
//    }
//}
//MARK:- Getting Data From Observable
//extension ProfileVC {
//    func getProfile() {
//        self.ProfileVM.getProfile().subscribe(onNext: { (ProfileModel) in
//            if let profile = ProfileModel.data {
//                self.EmailLabel.text = profile.email ?? ""
//                self.UserNameLabel.text = "\(profile.firstName ??  "") \(profile.lastName ??  "")"
//                if profile.avatar ?? "" != "" {
//                    guard let url = URL(string: "https://dev.fv.academy/public/files/" + (profile.avatar ?? "")) else { return }
//                    self.ProfileImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
//                }
//            }
//        }, onError: { (error) in
//            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
//            }).disposed(by: disposeBag)
//    }
//}
//extension ProfileVC: UITableViewDelegate {
//
//    func setupProfileTableView() {
//
//        if token != "" {
//            self.Items = [
//                SideMenuModel(Name: "Notifications", Id: "Notification", Selected: false),
//                SideMenuModel(Name: "My Orders", Id: "Order", Selected: false),
//                SideMenuModel(Name: "My Wishlist", Id: "Wishlist", Selected: false),
//                SideMenuModel(Name: "Change Password", Id: "Password", Selected: false),
//                SideMenuModel(Name: "Change Language", Id: "Lang", Selected: false),
//                SideMenuModel(Name: "About the Academy", Id: "About", Selected: false),
//                SideMenuModel(Name: "Privacy Policy", Id: "Privacy", Selected: false),
//                SideMenuModel(Name: "Terms & Conditions", Id: "Terms", Selected: false),
//                SideMenuModel(Name: "News & Forums", Id: "News", Selected: false),
//                SideMenuModel(Name: "Contact Us", Id: "ContactUs", Selected: false),
//
//            ]
//            self.Items.append(SideMenuModel(Name: "Logout", Id: "Logout", Selected: false))
//        } else {
//            self.Items = [
//                SideMenuModel(Name: "Change Language", Id: "Lang", Selected: false),
//                SideMenuModel(Name: "About the Academy", Id: "About", Selected: false),
//                SideMenuModel(Name: "Privacy Policy", Id: "Privacy", Selected: false),
//                SideMenuModel(Name: "Terms & Conditions", Id: "Terms", Selected: false),
//            ]
//            self.Items.append(SideMenuModel(Name: "Login", Id: "Login", Selected: false))
//        }
//        self.ProfileTableView.rx.setDelegate(self).disposed(by: disposeBag)
//        self.ProfileTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
//        self.ProfileVM.Items.bind(to: self.ProfileTableView.rx.items(cellIdentifier: cellIdentifier, cellType: ProfileCell.self)) { index, element , cell in
//
//            cell.config(Name: element.Name ?? "", selected: element.Selected ?? false)
//
//            cell.nextPage = {
//                self.selectionAction(index: index)
//            }
//        }.disposed(by: disposeBag)
//
//        self.ProfileTableView.rx.itemSelected.bind { (indexPath) in
////            guard let cell = self.ProfileTableView.cellForRow(at: indexPath) as? ProfileCell else { return }
////            cell.config(Name: self.Items[indexPath.row].Name ?? "", selected: true)
////
//            self.selectionAction(index: indexPath.row)
//        }.disposed(by: disposeBag)
//
//
//    }
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 50
//    }
//
//}
