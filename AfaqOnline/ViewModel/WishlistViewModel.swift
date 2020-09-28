//
//  WishlistViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct WishlistViewModel {

    var Courses = PublishSubject<[WishlistData]>()
    
    func fetchCourses(data: [WishlistData]) {
        self.Courses.onNext(data)
    }

    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getWishlist() -> Observable<WishlistModelJSON> {
        let observer = Authentication.shared.getUserWishList()
        return observer
    }
    
    func postRemoveFromWishList(wishlistID: Int) -> Observable<RemoveFromWishListModelJSON> {
           let observer = AddServices.shared.postRemoveFromWishList(course_id: wishlistID)
           return observer
       }
    
}
