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
    
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var usernameTF: CustomTextField!
    @IBOutlet weak var selectTitleDropDown: TextFieldDropDown!
    @IBOutlet weak var CreateAccountButton: CustomButtons!
    @IBOutlet weak var selectGerderDropDown: TextFieldDropDown!
    @IBOutlet weak var selectJobDropDown: TextFieldDropDown!
    @IBOutlet weak var firstNameTF: CustomTextField!
    @IBOutlet weak var lastNameTF: CustomTextField!
    @IBOutlet weak var idNumberTF: CustomTextField!
    @IBOutlet weak var medicalNumberTF: CustomTextField!
    @IBOutlet weak var phoneTF: CustomTextField!
    
    private let AuthViewModel = AuthenticationViewModel()
    
    var disposeBag = DisposeBag()
    var titles = ["Dr", "Mr", "Miss", "Professor"]
    var jobs = ["Pharmacian", "Human Doctor"]
    var gender = ["Male","Female"]
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        DataBinding()
        setupTitlesDropDown()
        setupJobsDropDown()
        getAllJobs()
        setupGenderDropDown()
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
    
    func setupGenderDropDown() {
        selectGerderDropDown.optionArray = self.gender
        selectGerderDropDown.didSelect { (selectedText, index, id) in
            self.selectGerderDropDown.text = selectedText
        }
    }
    
    @IBAction func CreateAccountAction(_ sender: CustomButtons) {
    guard self.validateInput() else { return }
        guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "PasswordVC") as? PasswordVC else { return }
        main.gender =  self.selectGerderDropDown.text ?? ""
        main.job =  self.selectJobDropDown.text ?? ""
        main.Title =  self.selectTitleDropDown.text ?? ""
        main.email  = emailTF.text ?? ""
        main.firstName = firstNameTF.text ?? ""
        main.lastName = lastNameTF.text ?? ""
        main.idNumber = idNumberTF.text ?? ""
        main.medicalNumber = medicalNumberTF.text ?? ""
        main.phone = phoneTF.text ?? ""
        
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
}
extension RegistrationVC {
    func validateInput() -> Bool {
        var valid = false
        AuthViewModel.validate(gender: selectGerderDropDown.text ?? "", job: selectJobDropDown.text ?? "", title: selectTitleDropDown.text ?? "").subscribe(onNext: { (result) in
            if result.isEmpty {
                valid = true
            } else {
                displayMessage(title: "Error", message: result, status: .error, forController: self)
                valid = false
            }
        }).disposed(by: disposeBag)
        return valid
    }
    
    
    func getAllJobs() {
        AuthViewModel.getJobs().subscribe(onNext: { (jobsModel) in
            if jobsModel.status ?? false {
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
        _ = self.firstNameTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.first_name).disposed(by: disposeBag)
        _ = self.lastNameTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.last_name).disposed(by: disposeBag)
        _ = self.idNumberTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.id_number).disposed(by: disposeBag)
        _ = self.medicalNumberTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.medical_number).disposed(by: disposeBag)
        _ = self.phoneTF.rx.text.map({$0 ?? ""}).bind(to: AuthViewModel.phone).disposed(by: disposeBag)
    }
}
