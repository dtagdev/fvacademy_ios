//
//  AboutAppViewModel.swift
//  Dokanak
//
//  Created by MGoKu on 3/16/20.
//  Copyright © 2020 D-tag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct AboutAppViewModel {
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getAboutApp() -> Observable<AboutAppModelJSON> {
        var lang = Int()
                   if "lang".localized == "ar" {
                       lang = 0
                   } else {
                       lang = 1
                   }
        
        let observer = GetServices.shared.getAboutApp(lang: lang)
        return observer
    }
    
    func getContactUS() -> Observable<ContactUsModelJSON> {
        var lang = Int()
                   if "lang".localized == "ar" {
                       lang = 0
                   } else {
                       lang = 1
                   }
        
        let observer = GetServices.shared.getContactUS(lang: lang)
        return observer
    }
}
