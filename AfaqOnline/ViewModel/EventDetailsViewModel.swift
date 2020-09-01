//
//  EventDetailsViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/24/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import Foundation
import RxSwift
import SVProgressHUD

struct  EventDetailsViewModel {
    var Ads = PublishSubject<[String]>()
    var Participants = PublishSubject<[String]>()
    var EventContent = PublishSubject<[String]>()
    var ChatArr = PublishSubject<[ChatModel]>()
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchParticipants(data: [String]) {
        self.Participants.onNext(data)
    }
    func fetchEventContent(data: [String]) {
        self.EventContent.onNext(data)
    }
    func fetchChat(data: [ChatModel]) {
        self.ChatArr.onNext(data)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func postSendMessage(message: String, room_id: Int, user_id: Int) -> Observable<MessageJSONModel> {
        let params: [String: Any] = [
            "body": message,
            "room_id": room_id,
            "sender_id": user_id
        ]
        let observer = ChatServices.shared.sendMessage(params: params)
        return observer
    }
    
    func getRoomChat(room_id: Int) -> Observable<RoomChatModelJSON> {
        let observer = ChatServices.shared.getEventChat(room_id: room_id)
        return observer
    }
    
}
