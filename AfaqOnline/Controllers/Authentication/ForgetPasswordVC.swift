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

        // Do any additional setup after loading the view.
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone5S, .iPhoneSE, .iPhoneSE2:
            self.sendEmailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.sendEmailButton.frame.width - 75), bottom: 0, right: 0)
        default:
            self.sendEmailButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.sendEmailButton.frame.width - 75), bottom: 0, right: 0)
        }
        
        DataBinding()
    }
 
}
//MARK:- View Model Functions
extension ForgetPasswordVC {
    func POSTGetForgetPassword() {
        self.sendEmailButton.isEnabled = false
        self.AuthViewModel.POSTForgetPassword().subscribe(onNext: { (passwordModel) in
            if passwordModel.status ?? false {
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "OTPScreenVC") as? OTPScreenVC else { return }
                main.email = self.phoneTF.text ?? ""
                main.pageType = "pass"
                main.modalPresentationStyle = .overFullScreen
                main.modalTransitionStyle = .crossDissolve
                self.present(main, animated: true, completion: nil)
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
