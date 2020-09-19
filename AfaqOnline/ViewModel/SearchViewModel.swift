//
//  SearchViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct SearchViewModel {

    var Results = PublishSubject<[TrendCourse]>()
    
    func fetchResults(data: [TrendCourse]) {
        self.Results.onNext(data)
    }

    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    
    func getSearchResults(name: String) -> Observable<CoursesModel> {
        let params: [String: Any] = [
            "name": name
        ]
        
        let observer = AddServices.shared.postSearchByWord(params: params)
        return observer
    }
    
}
