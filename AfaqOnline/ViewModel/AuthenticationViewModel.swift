//
//  AuthenticationViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/17/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct AuthenticationViewModel {
    var email = BehaviorSubject<String>(value: "")
    var confirm_password = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var first_name = BehaviorSubject<String>(value: "")
    var last_name = BehaviorSubject<String>(value: "")
    var id_number = BehaviorSubject<String>(value: "")
    var medical_number = BehaviorSubject<String>(value: "")
    var phone = BehaviorSubject<String>(value: "")
   
    var Categories = PublishSubject<[Category]>()
      
    
    
    func fetchCategories(Categories: [Category]) {
          self.Categories.onNext(Categories)
      }
    
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func showProgress(progress: Float) {
        SVProgressHUD.showProgress(progress)
    }
    
    //MARK:- Attempt to register
    func attemptToRegister(image : UIImage,gender : String,job : String,title: String,bindedEmail:String,bindedPassword:String,bindedFirstName:String,bindedLastName:String,bindedIdNumber:String,bindedMedicalNumber:String,bindedPhone:String) -> Observable<AfaqModelsJSON> {
        
        let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword ,
            "first_name": bindedFirstName ,
            "last_name": bindedLastName ,
            "id_number": bindedIdNumber ,
            "medical_number": bindedMedicalNumber ,
            "phone": bindedPhone ,
            "title": title,
            "job": job,
            "gender": gender,
            "avatar": image
            ]
        let observer = Authentication.shared.postRegister(image:image,params: params)
        return observer
    }
    
    
    //MARK:- Attempt to register
    func attemptToRegisterInstrcutor(image : UIImage,gender : String,job : String,title: String,bindedEmail:String,bindedPassword:String,bindedFirstName:String,bindedLastName:String,bindedIdNumber:String,bindedMedicalNumber:String,bindedPhone:String,bindedLang:Int,bindedDetails:String,bindedCat:Int) -> Observable<AfaqModelsJSON> {
        let params: [String: Any] = [
            "email": bindedEmail,
            "password": bindedPassword ,
            "first_name": bindedFirstName ,
            "last_name": bindedLastName ,
            "id_number": bindedIdNumber ,
            "medical_number": bindedMedicalNumber ,
            "phone": bindedPhone ,
            "title": title,
            "job": job,
            "gender": gender,
            "lang":bindedLang,
            "details":bindedDetails,
            "category_id":bindedCat,
            "avatar": image
            ]
        let observer = Authentication.shared.postRegisterInstracutor(image:image,params: params)
        return observer
    }
    
    
    
    
    func validate(gender : String,job : String,title: String,type : String,categiory : String ,lang:String) -> Observable<String> {
            return Observable.create({ (observer) -> Disposable in
                let bindedName = (try? self.first_name.value()) ?? ""
                let bindedLastName = (try? self.last_name.value()) ?? ""
                let bindedEmail = (try? self.email.value()) ?? ""
                let bindedPhone = (try? self.phone.value()) ?? ""
                let bindedIdNumber = (try? self.id_number.value()) ?? ""
                let bindedMedicalNumber = (try? self.medical_number.value()) ?? ""
            
                if bindedName.isEmpty {
                    observer.onNext("Please Enter Your First name ")
                } else if bindedLastName.isEmpty {
                    observer.onNext("Please Enter Your last Name ")
                } else if bindedPhone.isEmpty {
                    observer.onNext("Please Enter your phone first")
                } else if !bindedPhone.isPhone() {
                    if "lang".localized == "ar" {
                        observer.onNext("يرجى إدخال رقم سعودي صحيح.")
                    } else {
                        observer.onNext("Please Enter a valid KSA phone number")
                    }
                }else if bindedEmail.isEmpty {
                    observer.onNext("Please Enter Your Email First")
                } else if !bindedEmail.isValidEmail() {
                    observer.onNext("Please Enter Valid Email")
                } else if bindedIdNumber.isEmpty {
                    observer.onNext("Please Enter Id Number ")
                } else if bindedMedicalNumber.isEmpty {
                   observer.onNext("Please Enter Medical Number")
                }else if gender.isEmpty {
                   observer.onNext("Please select your gender")
                }else if job.isEmpty {
                   observer.onNext("Please select your title")
                }else if title.isEmpty {
                   observer.onNext("Please select your job")
                }else if type == "Instructor" {
                    if categiory.isEmpty{
                        observer.onNext("Please select your Categiory")
                    }else if lang.isEmpty{
                        observer.onNext("Please select your Language")
                    }
                }else{
                    observer.onNext("")
                }
                
                return Disposables.create()
            })
        }

    func validatePass() -> Observable<String> {
        return Observable.create({ (observer) -> Disposable in
            let bindedPassword = (try? self.password.value()) ?? ""
            let bindedConfirm_password = (try? self.confirm_password.value()) ?? ""
            if bindedPassword.isEmpty {
                observer.onNext("Please Enter Your Password")
            } else if bindedConfirm_password.isEmpty {
                observer.onNext("Please Enter Your Password Confirmation")
            } else if bindedPassword != bindedConfirm_password {
                observer.onNext("Password & Password confirmation not matched")
            }else{
                observer.onNext("")
            }
            return Disposables.create()
        })
    }
    
    //MARK:- Attempt to register
    func attemptToLogin() -> Observable<LoginModelJSON> {
        let bindedEmail = try? email.value()
        let bindedPassword = try? password.value()
        
        let params: [String: Any] = [
            "email": bindedEmail ?? "",
            "password": (bindedPassword ?? "").arToEnDigits,
            ]
        let observer = Authentication.shared.postLogin(params: params)
        return observer
    }
    func getJobs() -> Observable<JobsModel> {
        let observer = GetServices.shared.getAllJobs()
        return observer
    }
    
    func POSTForgetPassword() -> Observable<PasswordJSONModel> {
        let bindedPhone = try? phone.value()
        let params: [String: Any] = [
            "email": bindedPhone ?? ""
        ]
        
        let observer = Authentication.shared.postForgetPassword(params: params)
        return observer
    }
    
    
    func POSTSendCode(email : String) -> Observable<PasswordJSONModel> {
        let params: [String: Any] = [
            "email": email
        ]
        
        let observer = Authentication.shared.postForgetPassword(params: params)
        return observer
    }

    
    func GETCheckUserCode(code: String,type : String) -> Observable<PasswordJSONModel> {
        let observer = Authentication.shared.getCheckUserCode(code: code, type :type)
        return observer
    }
    
    func POSTUpdatePassowrd(code:String) -> Observable<PasswordUpdatJSONModel> {
        let bindedPhone = try? phone.value()
        let bindedPassword = try? password.value()
       
         let params: [String: Any] = [
            "password": bindedPassword?.arToEnDigits ?? "",
            "email": bindedPhone ?? "",
            "code": code
        ]
        let observer = Authentication.shared.postUpdatePassword(params: params)
        return observer
    }
    
    func attemptToEditProfile(gender: String,avatar : UIImage) -> Observable<ProfileModelJSON> {
            let bindedEmail = try? email.value()
            let bindedFirstName = try? first_name.value()
            let bindedLastName = try? last_name.value()
            let bindedIdNumber = try? id_number.value()
            let bindedMedicalNumber = try? medical_number.value()
            let bindedPhone = try? phone.value()
            let params: [String: Any] = [
                "email": bindedEmail ?? "",
                "first_name": bindedFirstName ?? "",
                "last_name": bindedLastName ?? "",
                "id_number": (bindedIdNumber ?? "").arToEnDigits,
                "medical_number": (bindedMedicalNumber ?? "").arToEnDigits,
                "phone": (bindedPhone ?? "").arToEnDigits,
                "gender": gender,
                ]
        let observer = Authentication.shared.postEditProfile(image: avatar, params: params)
            return observer
        }
    
       func getProfile() -> Observable<ProfileModelJSON> {
           let params: [String: Any] = [
               "email": Helper.getUserEmail() ?? ""
           ]
           let observer = Authentication.shared.getProfile(params: params)
           return observer
       }
    
    
    func getCategories(lth: Int,htl: Int,rate : Int) -> Observable<CategoriesModel> {
         var lang = Int()
         if "lang".localized == "ar" {
             lang = 0
         } else {
             lang = 1
         }
         let observer = GetServices.shared.getAllCategories(lang: 1,lth: lth,htl: htl,rate : rate)
         return observer
     }
    
}
