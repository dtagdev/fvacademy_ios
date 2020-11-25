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
import FlagPhoneNumber


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
    @IBOutlet weak var phoneTF: FPNTextField!
    @IBOutlet weak var selectLanguageDropDown: TextFieldDropDown!
    @IBOutlet weak var selectCateDropDown: TextFieldDropDown!
    @IBOutlet weak var personalInfoTF : CustomTextField!
    @IBOutlet weak var LanguageView : CustomView!
    @IBOutlet weak var CateView : CustomView!
    @IBOutlet weak var personalInfoView  : CustomView!
    @IBOutlet weak var stackViewHeight: NSLayoutConstraint!
    let listController: FPNCountryListViewController = FPNCountryListViewController(style: .grouped)
      var dialCode = String()
    
    private let AuthViewModel = AuthenticationViewModel()

    var disposeBag = DisposeBag()
    var titles = ["Dr", "Mr", "Miss", "Professor"]
    var jobs = ["Pharmacian", "Human Doctor"]
    var gender = ["Male","Female"]
    var Language = ["Arabic","English"]
    var cats = [String]()
    var cat_id = Int()
    var lang = Int()

    var Categories = [Category]() {
        didSet {
            DispatchQueue.main.async {
                self.AuthViewModel.fetchCategories(Categories: self.Categories)
            }
        }
    }
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        setupCountryPHone()
        DataBinding()
        setupTitlesDropDown()
        setupJobsDropDown()
        getAllJobs()
        setupGenderDropDown()
        setupLanguageDropDown()
        self.hideKeyboardWhenTappedAround()
        
        if type == "Instructor"{
            self.AuthViewModel.showIndicator()
            getCategories(lth: 0,htl: 0,rate : 0)
            LanguageView.isHidden = false
            CateView.isHidden = false
            personalInfoView.isHidden = false
        }else{
             LanguageView.isHidden = true
             CateView.isHidden = true
             personalInfoView.isHidden = true
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
    }
    
    
    func setupCountryPHone() {
             self.phoneTF.delegate = self
             self.phoneTF.displayMode = .list // .picker by default
             self.phoneTF.setCountries(excluding: [.IL])
             self.phoneTF.setFlag(key: .SA)
             listController.setup(repository: self.phoneTF.countryRepository)
             listController.didSelect = { [weak self] country in
             self?.phoneTF.setFlag(countryCode: country.code)
             }
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
    
    func setupLanguageDropDown() {
        selectLanguageDropDown.optionArray = self.Language
        selectLanguageDropDown.didSelect { (selectedText, index, id) in
            self.selectLanguageDropDown.text = selectedText
            if index == 0{
                self.lang = 0
            }else {
                self.lang = 1
            }
        }
    }
    func setupCatDropDown() {
        selectCateDropDown.optionArray = self.cats
        selectCateDropDown.didSelect { (selectedText, index, id) in
            self.selectCateDropDown.text = selectedText
            self.cat_id = self.Categories[index].id ?? 0
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
        main.phone = "+966\(phoneTF.text ?? "")"
        main.details = self.personalInfoTF.text ?? ""
        main.lang = self.lang ?? 0
        main.cat_id = self.cat_id
        main.type = self.type
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
             guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
             window.rootViewController = main
        
    }
    
}

extension RegistrationVC {
    //MARK:- GET Categories
    func getCategories(lth: Int,htl: Int,rate : Int) {
        self.AuthViewModel.getCategories(lth: lth,htl: htl,rate : rate).subscribe(onNext: { (categoriesModel) in
            if let data = categoriesModel.data {
                self.AuthViewModel.dismissIndicator()
                self.Categories = data
                for cats in data{
                self.cats.append(cats.name ?? "")
                }
                self.setupCatDropDown()
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }
}

extension RegistrationVC {
    func validateInput() -> Bool {
        var valid = false
        AuthViewModel.validate(gender: selectGerderDropDown.text ?? "", job: selectJobDropDown.text ?? "", title: selectTitleDropDown.text ?? "",type : type,categiory : selectCateDropDown.text ?? "" , lang : selectLanguageDropDown.text ?? "").subscribe(onNext: { (result) in
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


extension RegistrationVC : FPNTextFieldDelegate {
    
    func fpnDisplayCountryList() {
        let navigationViewController = UINavigationController(rootViewController: listController)
        
        listController.title = "Countries"
        
        self.present(navigationViewController, animated: true, completion: nil)
    }
    
    
    /// The place to present/push the listController if you choosen displayMode = .list
    
    
    /// Lets you know when a country is selected
    func fpnDidSelectCountry(name: String, dialCode: String, code: String) {
        print(name, dialCode, code) // Output "France", "+33", "FR"
        self.dialCode = dialCode
    }
    
    /// Lets you know when the phone number is valid or not. Once a phone number is valid, you can get it in severals formats (E164, International, National, RFC3966)
    func fpnDidValidatePhoneNumber(textField: FPNTextField, isValid: Bool) {
        if isValid {
            displayMessage(title: "", message: "Number is Valid now", status: .info, forController: self)
            self.phoneTF.text = phoneTF.getRawPhoneNumber()
        } else {
            
            if textField.text!.count > 9 {
                displayMessage(title: "", message: "Number not valid", status: .error, forController: self)
            }
        }
    }
}

