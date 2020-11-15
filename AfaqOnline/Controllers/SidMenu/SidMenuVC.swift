//
//  File.swift
//  AfaqOnline
//
//  Created by MAC on 11/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
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

class SideMenuVC : UIViewController {

    @IBOutlet weak var ProfileImageView: CustomImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var EmailLabel: UILabel!
    @IBOutlet weak var ProfileTableView: UITableView!
    @IBOutlet weak var iconImageView: UIImageView!
    @IBOutlet weak var tableViewHeight: NSLayoutConstraint!
    
    @IBOutlet weak var loginView: UIView!

    

    let token = Helper.getAPIToken() ?? ""
    private let cellIdentifier = "ProfileCell"
    @IBOutlet weak var profileViewHeight: NSLayoutConstraint!

    private var ProfileVM = ProfileViewModel()
    
    var disposeBag = DisposeBag()
    var Items = [SideMenuModel]() {
        didSet {
            DispatchQueue.main.async {
                self.ProfileVM.fetchItems(data: self.Items)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupProfileTableView()
        getProfile()
        self.hideKeyboardWhenTappedAround()
        
        if token != "" {
         iconImageView.isHidden = true
         ProfileImageView.isHidden = false
         UserNameLabel.isHidden = false
         EmailLabel.isHidden = false
         tableViewHeight.constant = 600
        loginView.isHidden = true
        }else{
            iconImageView.isHidden = false
            ProfileImageView.isHidden = true
            UserNameLabel.isHidden = true
            EmailLabel.isHidden = true
            tableViewHeight.constant = 500
            loginView.isHidden = false
        }
    }
    
    @IBAction func EditProfileAction(_ sender: CustomButtons) {
    guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "EditProfileVC") as? EditProfileVC else { return }
        self.navigationController?.pushViewController(main, animated: true)
    }
    func selectionAction(index: Int) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            switch self.Items[index].Id ?? "" {
            case "Notification":
                print("")
            case "Order":
                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "MyOrdersVC") as? MyOrdersVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            case "Wishlist":
                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "WishListVC") as? WishListVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            case "Password":
                print("")
            case "Setting":
                guard let window = UIApplication.shared.keyWindow else { return }
                guard let main = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LanguageScreenVC") as? LanguageScreenVC else { return }
                main.type = "home"
                window.rootViewController = main
                UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromLeft, animations: nil, completion: nil)
            case "About":
                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "AboutAppVC") as? AboutAppVC else { return }
                main.appPageType = "About"
                self.navigationController?.pushViewController(main, animated: true)
            case "Privacy":
                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "AboutAppVC") as? AboutAppVC else { return }
                main.appPageType = "Return"
                self.navigationController?.pushViewController(main, animated: true)
            case "Terms":
              guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "AboutAppVC") as? AboutAppVC else { return }
              main.appPageType = "Terms"
                self.navigationController?.pushViewController(main, animated: true)
            case "News":
                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "ArticalListVC") as? ArticalListVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            case "ContactUs":
                guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "ContactUsVC") as? ContactUsVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            case "Logout":
                let alert = UIAlertController(title: "Logout", message: "Are you sure you want to Log out?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
                    alert.dismiss(animated: true, completion: nil)
                    Helper.LogOut()
                    guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                    self.navigationController?.pushViewController(main, animated: true)
                    
                }
                yesAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
                let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
                cancelAction.setValue(#colorLiteral(red: 0.3104775548, green: 0.3218831122, blue: 0.4838557839, alpha: 1), forKey: "titleTextColor")
                alert.addAction(yesAction)
                alert.addAction(cancelAction)
                self.present(alert, animated: true, completion: nil)
            case "Login":
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
                
            default:
                break
            }
        }
        
    }
    
    @IBAction func instractorAction(_ sender: CustomButtons) {
          guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
             main.type = "Instructor"
             self.navigationController?.pushViewController(main, animated: true)

           }
    
    @IBAction func loginAction(_ sender: CustomButtons) {
        guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
                              
    }
    
    
}


//MARK:- Getting Data From Observable
extension SideMenuVC {
    func getProfile() {
        self.ProfileVM.getProfile().subscribe(onNext: { (ProfileModel) in
            if let profile = ProfileModel.data {
                self.EmailLabel.text = profile.email ?? ""
                self.UserNameLabel.text = "\(profile.firstName ??  "") \(profile.lastName ??  "")"
                if profile.avatar ?? "" != "" {
                    guard let url = URL(string: "https://dev.fv.academy/public/files/" + (profile.avatar ?? "")) else { return }
                    self.ProfileImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
                }
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension SideMenuVC: UITableViewDelegate {
    
    func setupProfileTableView() {
        
        if token != "" {
            self.Items = [
                SideMenuModel(Name: "My courses", Id: "courses", image: #imageLiteral(resourceName: "reading-book")),
                 SideMenuModel(Name: "My Wishlist", Id: "Wishlist", image: #imageLiteral(resourceName: "favorite-black-48dp")),
                SideMenuModel(Name: "My Certifcates", Id: "Certifcates", image: #imageLiteral(resourceName: "graduation-hat")),
                SideMenuModel(Name: "Inbox", Id: "Inbox", image: #imageLiteral(resourceName: "inbox")),
                SideMenuModel(Name: "Notifications", Id: "Notification", image: #imageLiteral(resourceName: "notifications-black-48dp")),
                SideMenuModel(Name: "About", Id: "About", image: #imageLiteral(resourceName: "info-black-48dp")),
                SideMenuModel(Name: "Setting", Id: "Setting", image: #imageLiteral(resourceName: "settings-black-48dp")),
                SideMenuModel(Name: "Help", Id: "Help", image: #imageLiteral(resourceName: "help-black-48dp")),

                
            ]
            self.Items.append(SideMenuModel(Name: "Log out", Id: "Logout",image: #imageLiteral(resourceName: "Group 175")))
        } else {
            self.Items = [
                SideMenuModel(Name: "Notifications", Id: "Notification", image: #imageLiteral(resourceName: "notifications-black-48dp")),
                SideMenuModel(Name: "About", Id: "About", image: #imageLiteral(resourceName: "info-black-48dp")),
                SideMenuModel(Name: "Setting", Id: "Setting",image: #imageLiteral(resourceName: "settings-black-48dp")),
                SideMenuModel(Name: "help", Id: "help", image: #imageLiteral(resourceName: "help-black-48dp")),
            ]
            self.Items.append(SideMenuModel(Name: "Sign Up", Id: "SignUp",image: #imageLiteral(resourceName: "Group 175")))
        }
        self.ProfileTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ProfileTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.ProfileVM.Items.bind(to: self.ProfileTableView.rx.items(cellIdentifier: cellIdentifier, cellType: ProfileCell.self)) { index, element , cell in
    
            cell.config(Name: element.Name , image: element.image)
            
        }.disposed(by: disposeBag)
        
        self.ProfileTableView.rx.itemSelected.bind { (indexPath) in
//            guard let cell = self.ProfileTableView.cellForRow(at: indexPath) as? ProfileCell else { return }
//            cell.config(Name: self.Items[indexPath.row].Name ?? "", selected: true)
//
            self.selectionAction(index: indexPath.row)
        }.disposed(by: disposeBag)
        
        
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
}
