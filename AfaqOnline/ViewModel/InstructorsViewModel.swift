//
//  InstructorsViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct InstructorsViewModel {
    var Ads = PublishSubject<[String]>()
    var Instructors = PublishSubject<[Instructor]>()
    
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchInstructors(Instructors: [Instructor]) {
        self.Instructors.onNext(Instructors)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getInstructors(lth: Int,htl: Int,rate: Int) -> Observable<InstructorsModelJson> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getAllInstructors(lang: 1,lth: lth,htl: htl,rate: rate)
        return observer
    }
    
    func getInstructorDetails(instructor_id: Int) -> Observable<InstructorDetailsModelJSON> {
        
        let observer = GetServices.shared.getInstructorDetails(instructor_id: instructor_id)
        return observer
    }
}
