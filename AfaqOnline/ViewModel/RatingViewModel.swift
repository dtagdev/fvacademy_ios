//
//  RatingViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD

struct RatingViewModel {
    
    var Comment = BehaviorSubject<String>(value: "")
    
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    func AddRate(course_id: Int, user_id: Int, rate_value: Double) -> Observable<RateModelJSON> {
        let comment = try? Comment.value()
        let params: [String: Any] = [
            "course_id": course_id,
            "user_id": user_id,
            "rate_value": rate_value,
            "comment": comment ?? ""
        ]
        
        let observer = AddServices.shared.POSTAddRate(params: params)
        return observer
    }
    
    
}
