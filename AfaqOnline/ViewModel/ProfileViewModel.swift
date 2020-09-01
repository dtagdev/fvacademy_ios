//
//  ProfileViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct ProfileViewModel {

    var Items = PublishSubject<[SideMenuModel]>()
    
    func fetchItems(data: [SideMenuModel]) {
        self.Items.onNext(data)
    }

    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func getProfile() -> Observable<ProfileModelJSON> {
        let params: [String: Any] = [
            "email": Helper.getUserEmail() ?? ""
        ]
        let observer = Authentication.shared.getProfile(params: params)
        return observer
    }
}
