//
//  EditProfileVC.swift
//  AfaqOnline
//
//  Created by MAC on 10/1/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DLRadioButton

class EditProfileVC: UIViewController {

    @IBOutlet weak var firstStepView: UIView!
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
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var ProfileImageView: CustomImageView!

    
    
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
        DataBinding()
        setupTitlesDropDown()
        setupJobsDropDown()
        getAllJobs()
        self.hideKeyboardWhenTappedAround()
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
    
    
    
    @IBAction func selectGenderAction(_ sender: DLRadioButton) {
        if sender.tag == 1 {
            print("Male")
            self.gender = "Male"
        } else if sender.tag == 2 {
            print("Female")
            self.gender = "Female"
        }
    }

    @IBAction func CreateAccountAction(_ sender: CustomButtons) {
        sender.isEnabled = false
        self.postRegister(gender: self.gender, title: self.selectTitleDropDown.text ?? "", job: self.selectJobDropDown.text ?? "")
    }

 
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
           searchTF.isHidden = true
           searchTF.text = ""
       }
       
       @IBAction func FiltrationAction(_ sender: UIButton) {
           if self.searchTF.isHidden {
               Constants.shared.searchingEnabled = true
               self.searchTF.isHidden = false
           } else {
               Constants.shared.searchingEnabled = false
               self.searchTF.isHidden = true
           }
       }
       
       @IBAction func BackAction(_ sender: UIButton) {
           guard let window = UIApplication.shared.keyWindow else { return }
           guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
           window.rootViewController = main
           UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
       }
    
       @IBAction func SearchDidEndEditing(_ sender: CustomTextField) {
              if Constants.shared.searchingEnabled {
                  guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
                  main.modalPresentationStyle = .overFullScreen
                  main.modalTransitionStyle = .crossDissolve
                  main.search_name = self.searchTF.text ?? ""
               self.searchTF.text = ""
               self.searchTF.isHidden = true
               self.present(main, animated: true, completion: nil)
              }
          }
    
}

extension EditProfileVC {
    func postRegister(gender: String, title: String, job: String) {
        AuthViewModel.attemptToRegister(gender: gender, title: title, job: job).subscribe(onNext: { (registerData) in
            if registerData.status ?? false {
            // displayMessage(title: "", message: "You have Registered Successfully", status: .success, forController: self)
                self.SecondStepView.isHidden = true
                self.firstStepView.isHidden = false
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "OTPScreenVC") as? OTPScreenVC else { return }
                main.pageType = "homePage"
                main.email = self.emailTF.text
                main.modalPresentationStyle = .overFullScreen
                main.modalTransitionStyle = .crossDissolve
                self.present(main, animated: true, completion: nil)
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
extension EditProfileVC {
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

    }
    
 
}
