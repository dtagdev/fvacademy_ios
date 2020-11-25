//
//  UpdatePasswordVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/16/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
class UpdatePasswordVC: UIViewController {
    
    @IBOutlet weak var new_passwordTF: CustomTextField!
    @IBOutlet weak var new_password_confirmationTF: CustomTextField!
    @IBOutlet weak var confirmButton: CustomButtons!
    

    private let AuthViewModel = AuthenticationViewModel()
    var email = String()
    var code = String()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        DataBinding()
    }
  
    @IBAction func BackAction(_ sender: UIButton) {
         guard let window = UIApplication.shared.keyWindow else { return }
         guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
         window.rootViewController = main
     }
    
    
}
//MARK:- View Model Functions
extension UpdatePasswordVC {
    func POSTUpdateForgetPassword(code:String) {
        self.confirmButton.isEnabled = false
        self.AuthViewModel.POSTUpdatePassowrd(code:code).subscribe(onNext: { (passwordModel) in
            if passwordModel.status ?? false {
                guard let window = UIApplication.shared.keyWindow else { return }
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
                window.rootViewController = main
            }
            self.confirmButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.confirmButton.isEnabled = true
        }).disposed(by: disposeBag)
    }
}
//MARK:- Data Binding
extension UpdatePasswordVC {
    func DataBinding() {
        self.AuthViewModel.phone.onNext(self.email)
        _ = new_passwordTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.password).disposed(by: disposeBag)
        self.new_passwordTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            if self.new_passwordTF.text!.isPasswordValid() {
                self.new_passwordTF.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                self.new_passwordTF.borderWidth = 1
            } else {
                self.new_passwordTF.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                self.new_passwordTF.borderWidth = 1
            }
        }.disposed(by: disposeBag)
        self.new_password_confirmationTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            if self.new_password_confirmationTF.text!.isPasswordValid() {
                self.new_password_confirmationTF.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                self.new_password_confirmationTF.borderWidth = 1
            } else {
                self.new_password_confirmationTF.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                self.new_password_confirmationTF.borderWidth = 1
            }
        }.disposed(by: disposeBag)
        confirmButton.rx.tap.bind {
            guard !self.new_passwordTF.text!.isEmpty else {
                if "lang".localized == "ar" {
                    displayMessage(title: "", message: "يرجى إدخال كلمة المرور الجديدة", status: .info, forController: self)
                } else {
                    displayMessage(title: "", message: "Please Enter your new password", status: .info, forController: self)
                }
                return
            }
            guard self.new_passwordTF.text!.isPasswordValid() else {
                if "lang".localized == "ar" {
                displayMessage(title: "", message: "كلمة المرور الحديثة غير صالحة  ", status: .info, forController: self)
                } else {
           displayMessage(title: "", message: "Your new password isn't correct", status: .info, forController: self)
                }
                
                return
            }
            guard self.new_password_confirmationTF.text! == self.new_passwordTF.text! else {
                if "lang".localized == "ar" {
                    displayMessage(title: "", message: "كلمة المرور الحديثة ليست متطابقة مع تأكيد كلمة المرور", status: .info, forController: self)
                } else {
                    displayMessage(title: "", message: "Your new password isn't matched", status: .info, forController: self)
                }
                return
            }
            self.POSTUpdateForgetPassword(code: self.code)
        }.disposed(by: disposeBag)
    }
}

