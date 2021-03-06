//
//  CourseDetailsViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct CourseDetailsViewModel {

    var CourseData = PublishSubject<[String]>()
    var RecommendedCourses = PublishSubject<[CoursesData]>()
    
    func fetchCourseData(data: [String]) {
        self.CourseData.onNext(data)
    }
    func fetchRecommendedCourses(data: [CoursesData]) {
        self.RecommendedCourses.onNext(data)
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getCourseDetails(course_id: Int) -> Observable<CourseDetailsModel> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getCourseDetails(course_id: course_id, lang: 1)
        return observer
    }
    
    func getRelatedCourses(course_id: Int) -> Observable<RelatedCoursesModelJSON> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getRelatedCourses(course_id: course_id, lang: 1)
        
        return observer
    }
    
    func postAddToWishList(course_id: Int) -> Observable<AddWishlistModelJSON> {
        let params: [String: Any] = [
            "user_id": Helper.getUserID() ?? 0,
            "cousre_id": course_id
        ]
        let observer = AddServices.shared.POSTAddToWishList(params: params)
        return observer
    }
    func postRemoveFromWishList(course_id: Int) -> Observable<RemoveFromWishListModelJSON> {
        
        let observer = AddServices.shared.postRemoveFromWishList(course_id: course_id)
        return observer
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
