//
//  ChatServices.swift
//  AfaqOnline
//
//  Created by MGoKu on 7/15/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON


struct ChatServices {
    static let shared = ChatServices()
    
    //MARK:- SEND Message
    func sendMessage(params: [String: Any]) -> Observable<MessageJSONModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.sendMessage
            
            Alamofire.request(url, method: .post, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(MessageJSONModel.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of SEND Message
    //MARK:- GET Room Chat
    func getEventChat(room_id: Int) -> Observable<RoomChatModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getRoomChat + "/\(room_id)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(RoomChatModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GET Room Chat
}
