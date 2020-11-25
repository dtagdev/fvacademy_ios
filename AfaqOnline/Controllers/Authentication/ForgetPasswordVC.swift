//
//  ForgetPasswordVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ForgetPasswordVC: UIViewController {

    @IBOutlet weak var phoneTF: CustomTextField!
    @IBOutlet weak var sendEmailButton: CustomButtons!
    
    private let AuthViewModel = AuthenticationViewModel()
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
extension ForgetPasswordVC {
    func POSTGetForgetPassword() {
    
        self.sendEmailButton.isEnabled = false
        self.AuthViewModel.POSTForgetPassword().subscribe(onNext: { (passwordModel) in
            if passwordModel.status ?? false {
            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "ConfirmationCode") as? ConfirmationCode else { return }
            main.email = self.phoneTF.text ?? ""
            self.navigationController?.pushViewController(main, animated: true)
            }else{
                displayMessage(title: "", message: passwordModel.errors ?? "", status: .error, forController: self)
            }
            self.sendEmailButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.sendEmailButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
}

//MARK:- Data Binding
extension ForgetPasswordVC {
    func DataBinding() {
        _ = phoneTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.phone).disposed(by: disposeBag)
        sendEmailButton.rx.tap.bind {
            guard self.phoneTF.text!.isValidEmail() else {
                if "lang".localized == "ar" {
                    displayMessage(title: "", message: "يرجى إدخال رقم بريد الكتروني صحيح اولاً", status: .info, forController: self)
                } else {
                    displayMessage(title: "", message: "Please Enter a valid email first", status: .info, forController: self)
                }
                return
            }
            self.POSTGetForgetPassword()
        }.disposed(by: disposeBag)
    }
}
