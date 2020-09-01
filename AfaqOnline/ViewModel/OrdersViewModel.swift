//
//  OrdersViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct OrdersViewModel {

    var Orders = PublishSubject<[MyCoursesData]>()
    var CartItems = PublishSubject<[String]>()
    
    func fetchOrders(data: [MyCoursesData]) {
        self.Orders.onNext(data)
    }

    func fetchCartItems(items: [String]) {
        self.CartItems.onNext(items)
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    
    func getMyCourses() -> Observable<MyCoursesModelJSON> {
        let observer = Authentication.shared.getMyCourses()
        return observer
    }
}
