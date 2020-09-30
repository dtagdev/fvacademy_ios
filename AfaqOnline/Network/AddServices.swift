//
//  AddServices.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

struct AddServices {
    
    static let shared = AddServices()
    
    //MARK:- POST Add Rate
    func POSTAddRate(params: [String: Any]) -> Observable<RateModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postAddRate
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(RateModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of POST Add Rate
    
    //MARK:- Add To Wish List
    func POSTAddToWishList(params: [String: Any]) -> Observable<AddWishlistModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postAddToWishlist
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AddWishlistModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of Add To Wish Lists
    //MARK:- Remove from Wish List
    func postRemoveFromWishList(course_id: Int) -> Observable<RemoveFromWishListModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postDeletFromWishlist + "\(course_id)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    print(JSON(response.result.value))
                    do {
                        let data = try JSONDecoder().decode(RemoveFromWishListModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of Remove from Wish List
    //MARK:- POST Search by word
    func postSearchByWord(params: [String: Any]) -> Observable<CoursesModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postSearchByWord
            
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    
                    do {
                        let data = try JSONDecoder().decode(CoursesModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            
            return Disposables.create()
        }
    }//END of POST Search by word
    
    //MARK:- POST Add Comment
    func postAddComment(params: [String: Any]) -> Observable<CourseCommentsModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postAddComment
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(CourseCommentsModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of POST Add Comment
    
    //MARK:- POST Add Comment
       func postAddArticalComment(params: [String: Any]) -> Observable<AddCommentModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.postAddArticalComment
               let token = Helper.getAPIToken() ?? ""
               let headers = [
                   "Authorization": "Bearer \(token)"
               ]
               
               Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       do {
                           let data = try JSONDecoder().decode(AddCommentModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               
               return Disposables.create()
           }
       }//END of POST Add Comment
    //MARK:- POST Add Comment
          func postAddEventComment(params: [String: Any]) -> Observable<EventDetailsModelJSON> {
              return Observable.create { (observer) -> Disposable in
                  let url = ConfigURLS.postAddEventComment
                  let token = Helper.getAPIToken() ?? ""
                  let headers = [
                      "Authorization": "Bearer \(token)"
                  ]
                  
                  Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                      .validate(statusCode: 200..<300)
                      .responseJSON { (response: DataResponse<Any>) in
                          do {
                              let data = try JSONDecoder().decode(EventDetailsModelJSON.self, from: response.data!)
                              observer.onNext(data)
                          } catch {
                              print(error.localizedDescription)
                              observer.onError(error)
                          }
                  }
                  
                  return Disposables.create()
              }
          }//END of POST Add Comment
    
    //MARK:- POST Add To Cart
    func postAddToCart(params: [String: Any]) -> Observable<AddToCartModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.postAddToCart
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(AddToCartModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    } //END of POST Add To Cart
    
    //MARK:- POST remove Cart
    func postRemoveFromCart(course_id: Int) -> Observable<RemoveFromCartModelJSON> {
           return Observable.create { (observer) -> Disposable in
               let url = ConfigURLS.postDeletFromCart + "\(course_id)"
               let token = Helper.getAPIToken() ?? ""
               let headers = [
                   "Authorization": "Bearer \(token)"
               ]
               Alamofire.request(url, method: .delete, parameters: nil, encoding: URLEncoding.default, headers: headers)
                   .validate(statusCode: 200..<300)
                   .responseJSON { (response: DataResponse<Any>) in
                       print(JSON(response.result.value))
                       do {
                           let data = try JSONDecoder().decode(RemoveFromCartModelJSON.self, from: response.data!)
                           observer.onNext(data)
                       } catch {
                           print(error.localizedDescription)
                           observer.onError(error)
                       }
               }
               return Disposables.create()
           }
       }//END of Remove from Wish List
    
}
