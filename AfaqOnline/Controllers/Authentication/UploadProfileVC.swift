//
//  UploadProfileVC.swift
//  AfaqOnline
//
//  Created by MAC on 10/13/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import RxSwift
import RxCocoa
import DLRadioButton

class UploadProfileVC : UIViewController {
    
    @IBOutlet weak var ProfileImageView: CustomImageView!
    private let AuthViewModel = AuthenticationViewModel()
    var disposeBag = DisposeBag()
    var profliePic : UIImage?
    var gender = String()
    var Title = String()
    var job = String()
    var email  =  String()
    var firstName =  String()
    var lastName =  String()
    var idNumber =  String()
    var medicalNumber =  String()
    var phone =  String()
    var Password =  String()
    var details = String()
    var lang = Int()
    var cat_id = Int()
    var type = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func CreateAccountAction(_ sender: CustomButtons) {
           AuthViewModel.showIndicator()
           if type == "Instructor"{
               self.postInstractorRegister()
           }else{
            self.postRegister()
           }
    }
    
    @IBAction func skipAction(_ sender: CustomButtons) {
        AuthViewModel.showIndicator()
        if type == "Instructor"{
            self.postInstractorRegister()
        }else{
         self.postRegister()
        }
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
             guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
             window.rootViewController = main
        
    }
}

extension UploadProfileVC {
    func postRegister(){
        AuthViewModel.attemptToRegister(image : profliePic ?? #imageLiteral(resourceName: "Group 243"), gender: gender, job: job, title: Title, bindedEmail: email, bindedPassword: Password, bindedFirstName: firstName, bindedLastName: lastName, bindedIdNumber: idNumber, bindedMedicalNumber: medicalNumber, bindedPhone: phone).subscribe(onNext: { (registerData) in
            if registerData.status ?? false {
                self.AuthViewModel.dismissIndicator()
                displayMessage(title: "", message: "You have Registered Successfully", status: .success, forController: self)
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "OTPScreenVC") as? OTPScreenVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            } else {
                let errors = registerData.errors ?? Errors()
                self.AuthViewModel.dismissIndicator()
                if let email = errors.email {
                  displayMessage(title: "", message: email[0], status: .error, forController: self)
                }
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }
    
    func postInstractorRegister(){
        AuthViewModel.attemptToRegisterInstrcutor(image : profliePic ?? #imageLiteral(resourceName: "Group 243"), gender: gender, job: job, title: Title, bindedEmail: email, bindedPassword: Password, bindedFirstName: firstName, bindedLastName: lastName, bindedIdNumber: idNumber, bindedMedicalNumber: medicalNumber, bindedPhone: phone, bindedLang: lang, bindedDetails: details, bindedCat: cat_id).subscribe(onNext: { (registerData) in
            if registerData.status ?? false {
                self.AuthViewModel.dismissIndicator()
                displayMessage(title: "", message: "You have Registered Successfully", status: .success, forController: self)
                guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "OTPScreenVC") as? OTPScreenVC else { return }
                self.navigationController?.pushViewController(main, animated: true)
            } else {
                let errors = registerData.errors ?? Errors()
                self.AuthViewModel.dismissIndicator()
                if let email = errors.email {
                  displayMessage(title: "", message: email[0], status: .error, forController: self)
                }
            }
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }
    
}

extension UploadProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBAction func choosePicGallery(_ sender: CustomButtons) {
        self.showImagePicker(sourceType: .photoLibrary)
    }
    
    @IBAction func choosePicCamera(_ sender: CustomButtons) {
        self.showImagePicker(sourceType: .camera)
    }
    
    func showImagePicker(sourceType: UIImagePickerController.SourceType) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        imagePickerController.allowsEditing = true
        imagePickerController.sourceType = sourceType
        imagePickerController.mediaTypes = ["public.image"]
        imagePickerController.view.tintColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        self.present(imagePickerController, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let editedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage {
            self.profliePic =  editedImage
            self.ProfileImageView.image = editedImage
        } else if let originalImage = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.profliePic =  originalImage
            self.ProfileImageView.image = originalImage
        }
        dismiss(animated: true, completion: nil)
    }
    
}
