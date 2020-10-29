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
    var Courses = PublishSubject<[TrendCourse]>()
    var Categories = PublishSubject<[Category]>()
    var Instructors = PublishSubject<[Instructor]>()
    var Events = PublishSubject<[Event]>()
    var Articals = PublishSubject<[Article]>()
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchCategories(Categories: [Category]) {
        self.Categories.onNext(Categories)
    }
    
    func fetchCourses(Courses: [TrendCourse]) {
        self.Courses.onNext(Courses)
    }
    func fetchEvents(Events: [Event]) {
        self.Events.onNext(Events)
    }
    func fetchInstructors(Instructors: [Instructor]) {
        self.Instructors.onNext(Instructors)
    }
    
    func fetchArtical(Artical: [Article]) {
        self.Articals.onNext(Artical)
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
