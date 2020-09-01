//
//  RegistrationVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/17/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DLRadioButton

class RegistrationVC: UIViewController {

    @IBOutlet weak var firstStepView: UIView!
    @IBOutlet weak var nextStepButton: CustomButtons!
    @IBOutlet weak var TermsConditionsLabel: UILabel!
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var usernameTF: CustomTextField!
    @IBOutlet weak var passwordTF: CustomTextField!
    @IBOutlet weak var selectTitleDropDown: TextFieldDropDown!
    @IBOutlet weak var CreateAccountButton: CustomButtons!
    @IBOutlet weak var SecondStepView: UIView!
    @IBOutlet weak var SecondTermsConditionsLabel: UILabel!
    @IBOutlet weak var selectJobDropDown: TextFieldDropDown!
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var idNumberTF: CustomTextField!
    @IBOutlet weak var maleRadioButton: DLRadioButton!
    @IBOutlet weak var femaleRadioButton: DLRadioButton!
    @IBOutlet weak var medicalNumberTF: CustomTextField!
    @IBOutlet weak var phoneTF: CustomTextField!
    
    
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var titles = ["Dr", "Mr", "Miss", "Professor"]
    var jobs = ["Pharmacian", "Human Doctor"]
    var gender = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        SecondStepView.isHidden = true
        firstStepView.isHidden = false
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone5S, .iPhoneSE, .iPhoneSE2:
            self.nextStepButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.nextStepButton.bounds.width - 75), bottom: 0, right: 0)
            self.CreateAccountButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.CreateAccountButton.bounds.width - 75), bottom: 0, right: 0)
        default:
            self.nextStepButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.nextStepButton.bounds.width - 45), bottom: 0, right: 0)
            self.CreateAccountButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.CreateAccountButton.bounds.width - 45), bottom: 0, right: 0)
        }
        
        setupMultiColorTermsConditionsLabel()
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.TermsAndPrivacyPolicyTapAction(_:)))
        TermsConditionsLabel.isUserInteractionEnabled = true
        TermsConditionsLabel.addGestureRecognizer(gestureRecognizer)
        SecondTermsConditionsLabel.isUserInteractionEnabled = true
        SecondTermsConditionsLabel.addGestureRecognizer(gestureRecognizer)
        DataBinding()
        setupTitlesDropDown()
        setupJobsDropDown()
        getAllJobs()
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        self.clearAllTexts()
    }
    func setupTitlesDropDown() {
        selectTitleDropDown.optionArray = self.titles
        selectTitleDropDown.didSelect { (selectedText, index, id) in
            self.selectTitleDropDown.text = selectedText
        }
    }
    func setupJobsDropDown() {
        selectJobDropDown.optionArray = self.jobs
        selectJobDropDown.didSelect { (selectedText, index, id) in
            self.selectJobDropDown.text = selectedText
        }
    }
    @IBAction func backButton(_ sender: UIButton) {
        SecondStepView.isHidden = true
        firstStepView.isHidden = false
    }
    
    @IBAction func selectGenderAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            print("Male")
            self.gender = "Male"
        } else if sender.tag == 2 {
            print("Female")
            self.gender = "Female"
        }
    }
    @IBAction func NextStepAction(_ sender: CustomButtons) {
        SecondStepView.isHidden = false
        firstStepView.isHidden = true
    }
    @IBAction func CreateAccountAction(_ sender: CustomButtons) {
        sender.isEnabled = false
        self.postRegister(gender: self.gender, title: self.selectTitleDropDown.text ?? "", job: self.selectJobDropDown.text ?? "")
    }
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(true)
        
    }
}
extension RegistrationVC {
    func postRegister(gender: String, title: String, job: String) {
        AuthViewModel.attemptToRegister(gender: gender, title: title, job: job).subscribe(onNext: { (registerData) in
            if registerData.status ?? false {
                displayMessage(title: "", message: "You have Registered Successfully", status: .success, forController: self)
                self.SecondStepView.isHidden = true
                self.firstStepView.isHidden = false
                
                NotificationCenter.default.post(name: Notification.Name("NavigateToLogin"), object: nil)
                
            } else {
                let errors = registerData.errors ?? Errors()
                if let email = errors.email {
                    displayMessage(title: "", message: email[0], status: .error, forController: self)
                }
            }
            
            self.CreateAccountButton.isEnabled = true
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.CreateAccountButton.isEnabled = true
        }).disposed(by: disposeBag)
    }
    func getAllJobs() {
        AuthViewModel.getJobs().subscribe(onNext: { (jobsModel) in
            if jobsModel.status ?? false {
//                self.jobs = jobsModel.data ?? []
            }
        }, onError: { (error) in
            displayMessage(title: "", message: "Something went wrong in getting Jobs", status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension RegistrationVC {
    //MARK:- DataBinding
    func DataBinding() {
        _ = self.emailTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.email).disposed(by: disposeBag)
        _ = self.usernameTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.username).disposed(by: disposeBag)
        _ = self.passwordTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.password).disposed(by: disposeBag)
        _ = self.firstNameTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.first_name).disposed(by: disposeBag)
        _ = self.lastNameTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.last_name).disposed(by: disposeBag)
        _ = self.idNumberTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.id_number).disposed(by: disposeBag)
        _ = self.medicalNumberTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.medical_number).disposed(by: disposeBag)
        _ = self.phoneTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.phone).disposed(by: disposeBag)
        self.emailTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            if self.emailTF.text!.isValidEmail() {
                self.emailTF.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                self.emailTF.borderWidth = 1
            } else {
                self.emailTF.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                self.emailTF.borderWidth = 1
            }
        }.disposed(by: disposeBag)
        self.passwordTF.rx.controlEvent([.editingChanged]).asObservable().subscribe { [unowned self] _ in
            if self.passwordTF.text!.isPasswordValid() {
                self.passwordTF.borderColor = #colorLiteral(red: 0, green: 0.5628422499, blue: 0.3188166618, alpha: 1)
                self.passwordTF.borderWidth = 1
            } else {
                self.passwordTF.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                self.passwordTF.borderWidth = 1
            }
        }.disposed(by: disposeBag)
    }
    
    //MARK:- Terms of Service and Privacy Policy Action Configurations
    @objc func TermsAndPrivacyPolicyTapAction(_ sender: UITapGestureRecognizer) {
            print("Terms of Service and Privacy Policy Action")
    }
    func setupMultiColorTermsConditionsLabel() {
        let main_string = "By creating an account, you agree to our Terms of Service and Privacy Policy"
        let firstString = "Terms of Service"
        let secondString = "Privacy Policy"

        let firstRange = (main_string as NSString).range(of: firstString)
        let secondRange = (main_string as NSString).range(of: secondString)

        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: firstRange)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: secondRange)
        TermsConditionsLabel.attributedText = attribute
        SecondTermsConditionsLabel.attributedText = attribute
    }
}
