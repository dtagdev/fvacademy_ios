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
    var CartItems = PublishSubject<[Cart]>()
    
    func fetchOrders(data: [MyCoursesData]) {
        self.Orders.onNext(data)
    }

    func fetchCartItems(items: [Cart]) {
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
    
    func getMyCart() -> Observable<getCartModelJSON> {
        let observer = Authentication.shared.getMyGetCart()
        return observer
    }
    
    func postRemoveCart(course_id: Int) -> Observable<RemoveFromCartModelJSON> {
           let observer = AddServices.shared.postRemoveFromCart(course_id: course_id)
           return observer
       }

    
}
