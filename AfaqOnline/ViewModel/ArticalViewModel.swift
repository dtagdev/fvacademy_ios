//
//  ArticalViewModel.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
//
//  OrdersViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct ArticalViewModel {

    var Article = PublishSubject<[Article]>()
    var Comments = PublishSubject<[Comment]>()
    
    func fetchArtical(data: [Article]) {
        self.Article.onNext(data)
    }

    
    func fetchComments(data: [Comment]) {
        self.Comments.onNext(data)
       }
    
 
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    
    
    func getMyArtical() -> Observable<AllArticalModelJSON> {
        var lang = Int()
            if "lang".localized == "ar" {
                lang = 0
            } else {
                lang = 1
            }
        let observer = Authentication.shared.getMyArtical(lang: 1)
        return observer
    }

    
    func getArticalDetails(id : Int) -> Observable<ArticaDetalislModelJSON> {
        var lang = Int()
            if "lang".localized == "ar" {
                lang = 0
            } else {
                lang = 1
            }
        let observer = Authentication.shared.getArticalDetails(lang: 1, id : id)
        return observer
    }
    
  
    func postAddComment(id: Int, comment: String) -> Observable<AddCommentModelJSON> {
        let params: [String: Any] = [
            "article_id": id,
            "comment": comment
        ]
        
        let observer = AddServices.shared.postAddArticalComment(params: params)
        return observer
    }

}
