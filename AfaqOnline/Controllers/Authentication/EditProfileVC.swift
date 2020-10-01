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

    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var CreateAccountButton: CustomButtons!
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
    var gender = String()
    var profliePic = UIImage()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        self.hideKeyboardWhenTappedAround()
        self.AuthViewModel.showIndicator()
        getProfile()
    
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
        self.AuthViewModel.showIndicator()
        self.postEditProfile(gender: self.gender, avatar: self.profliePic)
    }
    
    
    
    @IBAction func choosePic(_ sender: CustomButtons) {
           showImageActionSheet()
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
    func postEditProfile(gender: String,avatar : UIImage){
        AuthViewModel.attemptToEditProfile(gender: gender,avatar:avatar).subscribe(onNext: { (registerData) in
            if registerData.status ?? false {
                self.AuthViewModel.dismissIndicator()
             displayMessage(title: "", message: "Your profile edit Successfully", status: .success, forController: self)
            } else {
                self.AuthViewModel.dismissIndicator()
               displayMessage(title: "", message: "something went Wrong ", status: .error, forController: self)
            }
            
        }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.CreateAccountButton.isEnabled = true
        }).disposed(by: disposeBag)
    }
    
    func getProfile() {
           self.AuthViewModel.getProfile().subscribe(onNext: { (ProfileModel) in
               if let profile = ProfileModel.data {
                self.AuthViewModel.dismissIndicator()
                self.emailTF.text = profile.email ?? ""
                self.firstNameTF.text = profile.firstName ??  ""
               self.lastNameTF.text = profile.lastName ??  ""
                self.phoneTF.text =  profile.phone ??  ""
                self.idNumberTF.text = profile.idNumber ??  ""
                self.medicalNumberTF.text = profile.medicalNumber ?? ""
                self.gender = profile.gender ?? ""
                if self.gender == "male"{
                self.maleRadioButton.selected()
                } else if self.gender == "female" {
                self.femaleRadioButton.selected()
                }
                self.DataBinding()
                if profile.avatar ?? "" != "" {
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + (profile.avatar ?? "")) else { return }
                    self.ProfileImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "userProfile"))
                }
               
               }
           }, onError: { (error) in
            self.AuthViewModel.dismissIndicator()
               displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
               }).disposed(by: disposeBag)
       }
    
}
extension EditProfileVC {
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

extension EditProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func showImageActionSheet() {
        if ("lang".localized == "en") {
            let chooseFromLibraryAction = UIAlertAction(title: "Choose from Library", style: .default) { (action) in
                self.showImagePicker(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "Take a Picture from Camera", style: .default) { (action) in
                self.showImagePicker(sourceType: .camera)
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "Pick Your Picture", message: nil, actions: [chooseFromLibraryAction, cameraAction, cancelAction], completion: nil)
        } else {
            let chooseFromLibraryAction = UIAlertAction(title: "أختر من مكتبة الصور", style: .default) { (action) in
                self.showImagePicker(sourceType: .photoLibrary)
            }
            let cameraAction = UIAlertAction(title: "إلتقاط صورة من الكاميرة", style: .default) { (action) in
                self.showImagePicker(sourceType: .camera)
            }
            
            let cancelAction = UIAlertAction(title: "إلغاء", style: .cancel, handler: nil)
            AlertService.showAlert(style: .actionSheet, title: "أختر صورك", message: nil, actions: [chooseFromLibraryAction, cameraAction, cancelAction], completion: nil)
        }
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
