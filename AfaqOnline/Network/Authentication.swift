//
//  Authentication.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class Authentication {
    
    static let shared = Authentication()
    //MARK:- POST Register
    func postRegister(params: [String : Any]) -> Observable<AfaqModelsJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postRegister
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let registerData = try JSONDecoder().decode(AfaqModelsJSON.self, from: response.data!)
                        print(registerData)
                        if let data = registerData.data {
                            Helper.saveAPIToken(user_id: data.id ?? 0, email: data.email ?? "", role: data.role ?? 0, name: data.name ?? "", token: data.token ?? "", token_type: data.tokenType ?? "")
                        }
                        observer.onNext(registerData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST Register
    
    //MARK:- POST Login
    func postLogin(params: [String: Any]) -> Observable<LoginModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postLogin
            
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let loginData = try JSONDecoder().decode(LoginModelJSON.self, from: response.data!)
                        if let data = loginData.data {
                            Helper.saveAPIToken(user_id: data.id ?? 0, email: data.email ?? "", role: data.role ?? 0, name: "\(data.firstName ?? "") \(data.lastName ?? "")", token: data.token ?? "", token_type: "")
                        }
                        observer.onNext(loginData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            
            return Disposables.create()
        }
    }//END of POST Login
    
    //MARK:- GET USER WishList
    func getUserWishList() -> Observable<WishlistModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getUserWishList + "/\(Helper.getUserID() ?? 0)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(WishlistModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of UserWishList
    
    //MARK:- GET Profile
    func getProfile(params: [String: Any]) -> Observable<ProfileModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getProfile
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        print(JSON(response.result.value))
                        let data = try JSONDecoder().decode(ProfileModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            
            return Disposables.create()
        }
    }//END of GET Profile
    
    //MARK:- POST Forget Password
    func postForgetPassword(params: [String: Any]) -> Observable<PasswordJSONModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postForgetPassword
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(PasswordJSONModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of POST Forget Password
    
    //MARK:- GETCheckUser Code
    func getCheckUserCode(code: String) -> Observable<PasswordJSONModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getCheckUserCode + "/\(code)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(PasswordJSONModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GETCheckUser Code
    
    //MARK:- POST Update Password
    func postUpdatePassword(params: [String: Any]) -> Observable<PasswordJSONModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postUpdatePassword
            
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(PasswordJSONModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of POST Update Password
    
    //MARK:- GET My Courses
    func getMyCourses() -> Observable<MyCoursesModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getUserCourses
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(MyCoursesModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET My Courses
}
