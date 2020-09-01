//
//  CourseContentViewModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import RxSwift
import SVProgressHUD


struct CourseContentViewModel {

    var Reviews = PublishSubject<[String]>()
    var Comments = PublishSubject<[CommentData]>()
    
    func fetchReviews(data: [String]) {
        self.Reviews.onNext(data)
    }
    func fetchComments(data: [CommentData]) {
        self.Comments.onNext(data)
    }
    func showIndicator() {
        SVProgressHUD.show()
    }
    func dismissIndicator() {
        SVProgressHUD.dismiss()
    }
    func getCourseComments(course_id: Int?) -> Observable<CommentsModelJSON> {
        let params: [String: Any] = [
            "course_id": course_id != nil ? course_id ?? 0 : ""
        ]
        
        let observer = GetServices.shared.getCourseComments(params: params)
        return observer
    }
    func postAddComment(course_id: Int, comment: String) -> Observable<AddCommentModelJSON> {
        let params: [String: Any] = [
            "course_id": course_id,
            "comment": comment
        ]
        
        let observer = AddServices.shared.postAddComment(params: params)
        return observer
    }
}
