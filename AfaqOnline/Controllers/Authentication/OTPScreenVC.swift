//
//  OTPScreenVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class OTPScreenVC: UIViewController {

    @IBOutlet weak var firstTF: CustomTextField!
    @IBOutlet weak var secondTF: CustomTextField!
    @IBOutlet weak var thirdTF: CustomTextField!
    @IBOutlet weak var fourthTF: CustomTextField!
    @IBOutlet weak var resendLabel: UILabel!
    @IBOutlet weak var mobileNumberStatusLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    let authVM = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var phone: String?
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.ResendTapAction(_:)))
        resendLabel.isUserInteractionEnabled = true
        resendLabel.addGestureRecognizer(gestureRecognizer)
        setupMultiColorResendLabel()
        
        self.firstTF.becomeFirstResponder()
        bindingData()
        mobileNumberStatusLabel.text = "Enter the 4-digit code sent to your phone number \(phone ?? "")"
    }
    
    @IBAction func ConfirmAction(_ sender: CustomButtons) {
        let alert = UIAlertController(title: "", message: "Invalid Code\nDo you want to resend it again?", preferredStyle: .alert)
        let yesAction = UIAlertAction(title: "YES", style: .default) { (action) in
            alert.dismiss(animated: true, completion: nil)
            //Your Action Of Yes Here
            self.GETCheckUserCode()
        }
        yesAction.setValue(#colorLiteral(red: 0.09019607843, green: 0.3176470588, blue: 0.4980392157, alpha: 1), forKey: "titleTextColor")
        alert.addAction(yesAction)
        let cancelAction = UIAlertAction(title: "NO", style: .cancel, handler: nil)
        cancelAction.setValue(#colorLiteral(red: 0.09019607843, green: 0.3176470588, blue: 0.4980392157, alpha: 1), forKey: "titleTextColor")
        alert.addAction(cancelAction)
        self.present(alert, animated: true, completion: nil)
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}
extension OTPScreenVC {
    func GETCheckUserCode() {
        let code = "\(self.firstTF.text ?? "")\(self.secondTF.text ?? "")\(self.thirdTF.text ?? "")\(self.fourthTF.text ?? "")"
        self.authVM.GETCheckUserCode(code: code).subscribe(onNext: { (passwordModel) in
            if passwordModel.data ?? false {
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "UpdatePasswordVC") as? UpdatePasswordVC else { return }
                main.phone = self.phone ?? ""
                main.modalPresentationStyle = .overFullScreen
                main.modalTransitionStyle = .crossDissolve
                self.present(main, animated: true, completion: nil)
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension OTPScreenVC {
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
            print("Resend Action")
    }
    func setupMultiColorResendLabel() {
        let main_string = "Didn't receive the code? Resend"
        let coloredString = "Resend"

        let Range = (main_string as NSString).range(of: coloredString)

        let attribute = NSMutableAttributedString.init(string: main_string)
        
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: #colorLiteral(red: 0.09019607843, green: 0.3176470588, blue: 0.4980392157, alpha: 1) , range: Range)
        resendLabel.attributedText = attribute
    }
    
    
}
