//
//  CategoriesViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct CategoriesViewModel {
    var Ads = PublishSubject<[String]>()
    var Categories = PublishSubject<[Category]>()
    
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchCategories(Categories: [Category]) {
        self.Categories.onNext(Categories)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getCategories(lth: Int,htl: Int,rate : Int) -> Observable<CategoriesModel> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getAllCategories(lang: 1,lth: lth,htl: htl,rate : rate)
        return observer
    }
}
