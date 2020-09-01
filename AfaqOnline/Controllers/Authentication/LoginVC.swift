//
//  LoginVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class LoginVC: UIViewController {

    @IBOutlet weak var emailUserNameTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var loginButton: CustomButtons!
    @IBOutlet weak var registerLabel: UILabel!
    @IBOutlet weak var skipButton: UIButton!
    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone5S, .iPhoneSE, .iPhoneSE2:
            self.loginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.loginButton.frame.width - 75), bottom: 0, right: 0)
        default:
            self.loginButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.loginButton.frame.width - 45), bottom: 0, right: 0)
        }
        
        self.hideKeyboardWhenTappedAround()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.RegisterTapAction(_:)))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(gestureRecognizer)
        setupMultiColorRegisterLabel()
        DataBinding()
    }
    

    @IBAction func LoginAction(_ sender: CustomButtons) {
        sender.isEnabled = false
        self.AttemptToLogin()
    }
    
}
//MARK:- AuthenticationViewModel Functions
extension LoginVC {
    func AttemptToLogin() {
        self.AuthViewModel.attemptToLogin().subscribe(onNext: { (loginData) in
            if loginData.status ?? false {
                displayMessage(title: "", message: "You Have LOGGED IN Successfully", status: .success, forController: self)
            } else {
//                let errors = loginData.errors ?? Errors()
                displayMessage(title: "", message: loginData.errors ?? "", status: .error, forController: self)
//                if let email = errors.email {
//                    displayMessage(title: "", message: loginData.errors ?? "", status: .error, forController: self)
//                }
                
            }
            self.loginButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.loginButton.isEnabled = true
            }).disposed(by: disposeBag)
    }
}
//MARK:- Data Binding
extension LoginVC {
    
    func DataBinding() {
        _ = emailUserNameTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.email).disposed(by: disposeBag)
        _ = passwordTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.password).disposed(by: disposeBag)
        self.addUnderLineToButtonText(text: "Skip", button: self.skipButton)
        self.skipButton.rx.tap.bind { (_) in
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
            //        main.setSelectIndex(from: 0, to: 1)
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
        }.disposed(by: disposeBag)
    }
    
    //MARK:- Register Label Action Configurations
    @objc func RegisterTapAction(_ sender: UITapGestureRecognizer) {
            print("Register Action")
        NotificationCenter.default.post(name: Notification.Name("NavigateToRegister"), object: nil)
    }
    func setupMultiColorRegisterLabel() {
        let main_string = "Don't have an account? Swipe right to create a new account"
        let coloredString = "create a new account"

        let Range = (main_string as NSString).range(of: coloredString)

        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: Range)
        registerLabel.attributedText = attribute
    }
    func addUnderLineToButtonText(text: String, button: UIButton) {
        let yourAttributes: [NSAttributedString.Key: Any] = [
        .font: UIFont.systemFont(ofSize: 14),
        .foregroundColor: button.titleLabel!.textColor,
        .underlineStyle: NSUnderlineStyle.single.rawValue]
        let attributeString = NSMutableAttributedString(string: text,
                                                        attributes: yourAttributes)
        button.setAttributedTitle(attributeString, for: .normal)
    }
}
