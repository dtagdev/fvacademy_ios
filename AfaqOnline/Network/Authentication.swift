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
    func postRegister(image: UIImage?,params: [String : Any]) -> Observable<AfaqModelsJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postRegister
            
            Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                if let data = image?.jpegData(compressionQuality: 0.8) {
                    form.append(data, withName: "avatar", fileName: "image.jpeg", mimeType: "image/jpeg")
                }
                for (key, value) in params {
                    form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                        
                }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil) { (result: SessionManager.MultipartFormDataEncodingResult) in
                    switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                    observer.onError(error)
                case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                    upload.uploadProgress { (progress) in
                      print("Image Uploading Progress: \(progress.fractionCompleted)")
                  }.responseJSON { (response: DataResponse<Any>) in
             do {
                    let registerData = try JSONDecoder().decode(AfaqModelsJSON.self, from: response.data!)
                    print(registerData)
                    if let data = registerData.data {
                     Helper.saveAPIToken(user_id: data.id ?? 0, email: data.email ?? "", role: data.role ?? 0, name: data.firstName ?? "", token: data.token ?? "")
                        }
                        observer.onNext(registerData)
                     } catch {
                         print(error.localizedDescription)
                        observer.onError(error)
                    }
                  }
                }
             }
            return Disposables.create()
        }
    }//END of POST Register
    
    //MARK:- POST Register Unstructor
      func postRegisterInstracutor(image: UIImage?,params: [String : Any]) -> Observable<AfaqModelsJSON> {
          return Observable.create { (observer) -> Disposable in
              let url = ConfigURLS.postRegister
              
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                if let data = image?.jpegData(compressionQuality: 0.8) {
                      form.append(data, withName: "avatar", fileName: "image.jpeg", mimeType: "image/jpeg")
                  }
                  for (key, value) in params {
                      form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                  }
                          
                  }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: nil) { (result: SessionManager.MultipartFormDataEncodingResult) in
                      switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                        print("Image Uploading Progress: \(progress.fractionCompleted)")
                    }.responseJSON { (response: DataResponse<Any>) in
               do {
                      let registerData = try JSONDecoder().decode(AfaqModelsJSON.self, from: response.data!)
                      print(registerData)
                      if let data = registerData.data {
                       Helper.saveAPIToken(user_id: data.id ?? 0, email: data.email ?? "", role: data.role ?? 0, name: data.firstName ?? "", token: data.token ?? "")
                          }
                          observer.onNext(registerData)
                       } catch {
                           print(error.localizedDescription)
                          observer.onError(error)
                      }
                    }
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
                            Helper.saveAPIToken(user_id: data.id ?? 0, email: data.email ?? "", role: data.role ?? 0, name: "\(data.firstName ?? "") \(data.lastName ?? "")", token: data.token ?? "")
                            Helper.restartApp()
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
    
    //MARK:- GETCheckPAss Code
    func getCheckPassCode(code: String) -> Observable<PasswordJSONModel> {
         return Observable.create { (observer) -> Disposable in
             let url = ConfigURLS.getCheckPassCode + "/\(code)"
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
     }//END of GETCheckPAss Code
    
    //MARK:- POST Update Password
    func postUpdatePassword(params: [String: Any]) -> Observable<PasswordUpdatJSONModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postUpdatePassword
            let token = Helper.getAPIToken() ?? ""
            let headers = [
            "Authorization": "Bearer \(token)"
            ]
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(PasswordUpdatJSONModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of POST Update Password
    

    func postEditProfile(image: UIImage, params: [String : Any]) -> Observable<ProfileModelJSON> {
          return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postEditProfile
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
                ]
            
              Alamofire.upload(multipartFormData: { (form: MultipartFormData) in
                  if let data = image.jpegData(compressionQuality: 0.8) {
                      form.append(data, withName: "avatar", fileName: "image.jpeg", mimeType: "image/jpeg")
                  }
                for (key, value) in params {
                    form.append("\(value)".data(using: String.Encoding.utf8)!, withName: key)
                }
                
              }, usingThreshold: SessionManager.multipartFormDataEncodingMemoryThreshold, to: url, method: .post, headers: headers) { (result: SessionManager.MultipartFormDataEncodingResult) in
                  switch result {
                  case .failure(let error):
                      print(error.localizedDescription)
                      observer.onError(error)
                  case .success(request: let upload, streamingFromDisk: _, streamFileURL: _):
                      upload.uploadProgress { (progress) in
                          print("Image Uploading Progress: \(progress.fractionCompleted)")
                      }.responseJSON { (response: DataResponse<Any>) in
                          do {
                            let msgData = try JSONDecoder().decode(ProfileModelJSON.self, from: response.data!)
                            if let data = msgData.data {
                            Helper.saveAPIToken(user_id: data.id ?? 0, email: data.email ?? "", role: 0, name: data.firstName ?? "", token: Helper.getAPIToken() ?? "")
                                Helper.saveAvatar(image: data.avatar ?? "")
                            }
                            observer.onNext(msgData)
                          } catch {
                              print(error.localizedDescription)
                              observer.onError(error)
                          }
                      }
                  }
              }
              return Disposables.create()
          }
        
    }
    
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
    
    //MARK:- GET My Cart
     func getMyGetCart() -> Observable<getCartModelJSON> {
         return Observable.create { (observer) -> Disposable in
             let url = ConfigURLS.GetCart
             let token = Helper.getAPIToken() ?? ""
             let headers = [
                 "Authorization": "Bearer \(token)"
             ]
             Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                 .validate(statusCode: 200..<300)
                 .responseJSON { (response: DataResponse<Any>) in
                     do {
                         let data = try JSONDecoder().decode(getCartModelJSON.self, from: response.data!)
                         observer.onNext(data)
                     } catch {
                         print(error.localizedDescription)
                         observer.onError(error)
                     }
             }
             return Disposables.create()
         }
     }//END of GET My Courses
    
    
    //MARK:- GET My Artical
    func getMyArtical(lang : Int) -> Observable<AllArticalModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getUserArtical + "/\(lang)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AllArticalModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET My Courses
    
    //MARK:- GET My Artical
    func getArticalDetails(lang : Int,id : Int) -> Observable<ArticaDetalislModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getArticalDetalis + "/\(id)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(ArticaDetalislModelJSON.self, from: response.data!)
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
