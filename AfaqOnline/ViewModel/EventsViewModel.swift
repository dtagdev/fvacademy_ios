//
//  EventsViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct  EventsViewModel {
    var Events = PublishSubject<[String]>()
    var Ads = PublishSubject<[String]>()
    var Participants = PublishSubject<[String]>()
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchParticipants(data: [String]) {
        self.Participants.onNext(data)
    }
    func fetchEvents(Events: [String]) {
        self.Events.onNext(Events)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func postAddToCart(course_id: Int, price: String) -> Observable<AddToCartModelJSON> {
        let params: [String: Any] = [
            "course_id": course_id,
            "price": price
        ]
        let observer = AddServices.shared.postAddToCart(params: params)
        return observer
    }
}
