//
//  HomeViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct  HomeViewModel {
    var Ads = PublishSubject<[String]>()
    var Courses = PublishSubject<[CoursesData]>()
    var Categories = PublishSubject<[Category]>()
    var Instructors = PublishSubject<[Instructore]>()
    var Events = PublishSubject<[String]>()
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchCategories(Categories: [Category]) {
        self.Categories.onNext(Categories)
    }
    
    func fetchCourses(Courses: [CoursesData]) {
        self.Courses.onNext(Courses)
    }
    func fetchEvents(Events: [String]) {
        self.Events.onNext(Events)
    }
    func fetchInstructors(Instructors: [Instructore]) {
        self.Instructors.onNext(Instructors)
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getHomeData() -> Observable<HomeModelJSON> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getHomeData(lang: 1)
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
