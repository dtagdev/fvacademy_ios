//
//  PasswordVC.swift
//  AfaqOnline
//
//  Created by MAC on 10/13/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa

class PasswordVC: UIViewController {
    
    @IBOutlet weak var new_passwordTF: CustomTextField!
    @IBOutlet weak var new_password_confirmationTF: CustomTextField!
    @IBOutlet weak var termsConditionsButton: CustomButtons!
    @IBOutlet weak var confirmButton: CustomButtons!
    @IBOutlet weak var termsLabel : UILabel!
    @IBOutlet weak var privcyLabel : UILabel!

    
    private let AuthViewModel = AuthenticationViewModel()
    var gender = String()
    var Title = String()
    var job = String()
    var  email  =  String()
    var  firstName =  String()
    var  lastName =  String()
    var idNumber =  String()
    var medicalNumber =  String()
    var phone =  String()
    var details = String()
    var lang = Int()
    var cat_id = Int()
    var type = String()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.TermsTapAction(_:)))
             termsLabel.isUserInteractionEnabled = true
             termsLabel.addGestureRecognizer(gestureRecognizer)
        let gestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(self.PrivecyTapAction(_:)))
        privcyLabel.isUserInteractionEnabled = true
        privcyLabel.addGestureRecognizer(gestureRecognizer2)
        
        
        
             setupMultiColorRegisterLabel()
             setupMultiColorRegisterLabel2()
        
            DataBinding()
        
    }
    
    
    @IBAction func BackAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
             guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
             window.rootViewController = main
    }
    
    
    var flag = true
    @IBAction func termsConditions(_ sender: UIButton) {
        if flag == true {
            self.termsConditionsButton.setImage(#imageLiteral(resourceName: "Group 37"), for: .normal)
            flag = false
        } else {
            self.termsConditionsButton.setImage(#imageLiteral(resourceName: "Rectangle 11"), for: .normal)
            flag = true
        }
        
    }
    
    
    @objc func PrivecyTapAction(_ sender: UITapGestureRecognizer) {
          guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "PrivecyVC") as? PrivecyVC else { return }
               main.appPageType = "Return"
               self.navigationController?.pushViewController(main, animated: true)
      }
    
     @objc func TermsTapAction(_ sender: UITapGestureRecognizer) {
            guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "PrivecyVC") as? PrivecyVC else { return }
               main.appPageType = "Terms"
                self.navigationController?.pushViewController(main, animated: true)
       }
    
  
    
    func setupMultiColorRegisterLabel() {
         let main_string = "I read and agree to the Terms & Conditions and"
         let coloredString = "Terms & Conditions"

         let Range = (main_string as NSString).range(of: coloredString)
         let attribute = NSMutableAttributedString.init(string: main_string)
         attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: Range)
         termsLabel.attributedText = attribute
     }
    
    
    func setupMultiColorRegisterLabel2() {
           let main_string = "Privacy Policy listed"
           let coloredString2 = "Privacy Policy"
          let Range2 = (main_string as NSString).range(of: coloredString2)
          let attribute2 = NSMutableAttributedString.init(string: main_string)
          attribute2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.black , range: Range2)
          privcyLabel.attributedText = attribute2
       }
    
}

//MARK:- Data Binding
extension PasswordVC {
    func validateInput() -> Bool {
        var valid = false
        AuthViewModel.validatePass().subscribe(onNext: { (result) in
            if result.isEmpty {
                valid = true
            } else {
                
                displayMessage(title: "Error", message: result, status: .error, forController: self)
                valid = false
            }
        }).disposed(by: disposeBag)
        
        if self.termsConditionsButton.currentImage == #imageLiteral(resourceName: "Rectangle 11") {
            if "lang".localized == "ar" {
                displayMessage(title: "", message: "يرجى الموافقة على الشروط و الأحكام أولاً", status: .error, forController: self)
            } else {
                displayMessage(title: "", message: "Please Accept Terms and Conditions First", status: .error, forController: self)
            }
            
            valid = false
        } else {
            valid = true
        }
        return valid
    }
    
    func DataBinding() {
        _ = new_passwordTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.password).disposed(by: disposeBag)
        _ = new_password_confirmationTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.confirm_password).disposed(by: disposeBag)
        confirmButton.rx.tap.bind {
            guard self.validateInput() else { return }
            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "UploadProfileVC") as? UploadProfileVC else { return }
            main.gender =  self.gender
            main.job =  self.job
            main.Title =  self.Title
            main.email  = self.email
            main.firstName = self.firstName
            main.lastName = self.lastName
            main.idNumber = self.idNumber
            main.medicalNumber = self.medicalNumber
            main.phone = self.phone
            main.Password = self.new_passwordTF.text ?? ""
            main.details = self.details
            main.lang = self.lang
            main.cat_id = self.cat_id
            main.type = self.type
            self.navigationController?.pushViewController(main, animated: true)
            
        }.disposed(by: disposeBag)
    }
}

