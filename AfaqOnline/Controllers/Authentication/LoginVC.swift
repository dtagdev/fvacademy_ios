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
    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        self.hideKeyboardWhenTappedAround()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.RegisterTapAction(_:)))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(gestureRecognizer)
        setupMultiColorRegisterLabel()
        DataBinding()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.navigationBar.isHidden = true
    }
    
    
    @IBAction func LoginAction(_ sender: CustomButtons) {
        sender.isEnabled = false
        self.AttemptToLogin()
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
        window.rootViewController = main
    }
    
    @IBAction func forgeAction(_ sender: UIButton) {
       guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "ForgetPasswordVC") as? ForgetPasswordVC else { return }
       self.navigationController?.pushViewController(main, animated: true)
     }
    
    
    @IBAction func becomeInstractor (_ sender: UIButton) {
    guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
        main.type = "Instructor"
        self.navigationController?.pushViewController(main, animated: true)
      }

    
}
//MARK:- AuthenticationViewModel Functions
extension LoginVC {
    func AttemptToLogin() {
        self.AuthViewModel.attemptToLogin().subscribe(onNext: { (loginData) in
            if loginData.status ?? false {
                displayMessage(title: "", message: "You Have LOGGED IN Successfully", status: .success, forController: self)
            } else {
                displayMessage(title: "", message: "someting wrong", status: .error, forController: self)
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
    }
    
    //MARK:- Register Label Action Configurations
    @objc func RegisterTapAction(_ sender: UITapGestureRecognizer) {
        guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    
    func setupMultiColorRegisterLabel() {
        let main_string = "Don’t have an account? Sign Up"
        let coloredString = "Sign Up"
        
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
