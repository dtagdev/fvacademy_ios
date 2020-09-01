//
//  CoursesViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct  CoursesViewModel {
    var Courses = PublishSubject<[CoursesData]>()
    var Ads = PublishSubject<[String]>()
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchCourses(Courses: [CoursesData]) {
        self.Courses.onNext(Courses)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getCategoryCourses(category_id: Int) -> Observable<CoursesModel> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getCoursesOfSpecificCategory(category_id: category_id, lang: 0)
        return observer
    }
    func getAllCourses(page: Int) -> Observable<AllCoursesModelJSON> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let params = [
            "page": page
        ]
        let observer = GetServices.shared.getAllCourses(params: params, lang: 0)
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
