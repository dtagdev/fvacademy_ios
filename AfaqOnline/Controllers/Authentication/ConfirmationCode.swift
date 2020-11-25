//
//  ConfirmationCode.swift
//  AfaqOnline
//
//  Created by MAC on 11/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class ConfirmationCode  : UIViewController {

    @IBOutlet weak var firstTF: CustomTextField!
    @IBOutlet weak var secondTF: CustomTextField!
    @IBOutlet weak var thirdTF: CustomTextField!
    @IBOutlet weak var fourthTF: CustomTextField!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var mobileNumberStatusLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let authVM = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var email: String?
    var pageType = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ResendTapAction(_:)))
        resendLabel.isUserInteractionEnabled = true
        resendLabel.addGestureRecognizer(gestureRecognizer)
        setupMultiColorResendLabel()
        
        self.firstTF.becomeFirstResponder()
        bindingData()
        mobileNumberStatusLabel.text = "Please enter the code so you can proceed"
    }
    
    @IBAction func ConfirmAction(_ sender: CustomButtons) {
        self.GETCheckUserCode()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
             guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
             window.rootViewController = main
    }
}

extension ConfirmationCode {
    func GETCheckUserCode() {
        let code = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTF.text ?? "")\(self.fourthTF.text ?? "")"
        self.authVM.GETCheckForgetPasswordCode(code: code).subscribe(onNext: { (passwordModel) in
            if passwordModel.status ?? false {
            guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "UpdatePasswordVC") as? UpdatePasswordVC else { return }
                self.navigationController?.pushViewController(main, animated: true)

            }else{
           let alert = UIAlertController(title: "", message: "Invalid Code\nDo you want to resend it again?", preferredStyle: .alert)
                let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
                       alert.dismiss(animated: true, completion: nil)
                    self.POSTSendCode()
                }
                   yesAction.setValue(#colorLiteral(red: 0.09019607843, green: 0.3176470588, blue: 0.4980392157, alpha: 1), forKey: "titleTextColor")
                   alert.addAction(yesAction)
                   let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
                   cancelAction.setValue(#colorLiteral(red: 0.09019607843, green: 0.3176470588, blue: 0.4980392157, alpha: 1), forKey: "titleTextColor")
                   alert.addAction(cancelAction)
                   self.present(alert, animated: true, completion: nil)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    
    func POSTSendCode() {
        self.authVM.POSTSendCode(email : email ?? "").subscribe(onNext: { (passwordModel) in
            if passwordModel.status ?? false {
                 self.firstTF.text   = " "
                 self.secondTF.text  = " "
                 self.thirdTF.text   = " "
                 self.fourthTF.text = " "
                displayMessage(title: "", message: "code sent" , status: .success, forController: self)
            }else{
                displayMessage(title: "", message: passwordModel.errors ?? "", status: .error, forController: self)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension ConfirmationCode {
    func bindingData() {
        self.firstTF.rx.controlEvent([.editingDidBegin]).asObservable().subscribe { [unowned self] _ in
            self.firstTF.text = ""
            self.firstTF.borderColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            self.firstTF.borderWidth = 1
        }.disposed(by: disposeBag)
        self.firstTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            self.secondTF.text = ""
            self.firstTF.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.firstTF.borderWidth = 1
            self.secondTF.borderColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            self.secondTF.borderWidth = 1
            self.secondTF.becomeFirstResponder()
        }.disposed(by: disposeBag)
        self.secondTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            self.thirdTF.text = ""
            self.secondTF.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.secondTF.borderWidth = 1
            self.thirdTF.borderColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            self.thirdTF.borderWidth = 1
            self.thirdTF.becomeFirstResponder()
        }.disposed(by: disposeBag)
        self.thirdTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            self.fourthTF.text = ""
            self.thirdTF.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.thirdTF.borderWidth = 1
            self.fourthTF.borderColor = #colorLiteral(red: 1, green: 0.4117647059, blue: 0.4117647059, alpha: 1)
            self.fourthTF.borderWidth = 1
            self.fourthTF.becomeFirstResponder()
        }.disposed(by: disposeBag)
        self.fourthTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            self.fourthTF.borderColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            self.fourthTF.borderWidth = 1
            self.fourthTF.resignFirstResponder()
        }.disposed(by: disposeBag)
    }
    //MARK:- Register Label Action Configurations
  
    @objc func ResendTapAction(_ sender: UITapGestureRecognizer) {
        POSTSendCode()
    }
    
    func setupMultiColorResendLabel() {
        let main_string = "Send a new code"
        let coloredString = "code"
        let Range = (main_string as NSString).range(of: coloredString)
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.09019607843, green: 0.3176470588, blue: 0.4980392157, alpha: 1) , range: Range)
        resendLabel.attributedText = attribute
    }
    
    
}