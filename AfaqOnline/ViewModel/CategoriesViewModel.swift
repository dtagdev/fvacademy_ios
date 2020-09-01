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
    var Categories = PublishSubject<[CategoryData]>()
    
    
    func fetchAds(Ads: [String]) {
        self.Ads.onNext(Ads)
    }
    
    func fetchCategories(Categories: [CategoryData]) {
        self.Categories.onNext(Categories)
    }
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getCategories() -> Observable<CategoriesModel> {
        var lang = Int()
        if "lang".localized == "ar" {
            lang = 0
        } else {
            lang = 1
        }
        let observer = GetServices.shared.getAllCategories(lang: 0)
        return observer
    }
}
