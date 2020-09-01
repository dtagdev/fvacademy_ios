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
    var username = BehaviorSubject<String>(value: "")
    var password = BehaviorSubject<String>(value: "")
    var first_name = BehaviorSubject<String>(value: "")
    var last_name = BehaviorSubject<String>(value: "")
    var id_number = BehaviorSubject<String>(value: "")
    var medical_number = BehaviorSubject<String>(value: "")
    var phone = BehaviorSubject<String>(value: "")
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
    func attemptToRegister(gender: String, title: String, job: String) -> Observable<AfaqModelsJSON> {
        let bindedEmail = try? email.value()
        let bindedUsername = try? username.value()
        let bindedPassword = try? password.value()
        let bindedFirstName = try? first_name.value()
        let bindedLastName = try? last_name.value()
        let bindedIdNumber = try? id_number.value()
        let bindedMedicalNumber = try? medical_number.value()
        let bindedPhone = try? phone.value()
        let params: [String: Any] = [
            "email": bindedEmail ?? "",
//            "name": bindedUsername ?? "",
            "password": (bindedPassword ?? "").arToEnDigits,
            "first_name": bindedFirstName ?? "",
            "last_name": bindedLastName ?? "",
            "id_number": (bindedIdNumber ?? "").arToEnDigits,
            "medical_number": (bindedMedicalNumber ?? "").arToEnDigits,
            "phone": (bindedPhone ?? "").arToEnDigits,
            "title": title,
            "job": job,
            "gender": gender
            ]
        let observer = Authentication.shared.postRegister(params: params)
        return observer
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
            "phone": bindedPhone?.arToEnDigits ?? ""
        ]
        
        let observer = Authentication.shared.postForgetPassword(params: params)
        return observer
    }
    
    func GETCheckUserCode(code: String) -> Observable<PasswordJSONModel> {
        let observer = Authentication.shared.getCheckUserCode(code: code)
        return observer
    }
    
    func POSTUpdatePassowrd() -> Observable<PasswordJSONModel> {
        let bindedPhone = try? phone.value()
        let bindedPassword = try? password.value()
        let params: [String: Any] = [
            "password": bindedPassword?.arToEnDigits ?? "",
            "phone": bindedPhone?.arToEnDigits ?? ""
        ]
        let observer = Authentication.shared.postUpdatePassword(params: params)
        return observer
    }
}
