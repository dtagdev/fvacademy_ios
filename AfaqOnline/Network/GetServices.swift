//
//  GetServices.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift
import SwiftyJSON

class GetServices {
    static let shared = GetServices()
    //MARK:- GET All Jobs
    func getAllJobs() -> Observable<JobsModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getJobs
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let jobsData = try JSONDecoder().decode(JobsModel.self, from: response.data!)
                        observer.onNext(jobsData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GET All Jobs
    
    //MARK:- GET All Categories
    func getAllCategories(lang: Int) -> Observable<CategoriesModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getAllCategories + "/\(lang)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CategoriesData = try JSONDecoder().decode(CategoriesModel.self, from: response.data!)
                        observer.onNext(CategoriesData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET All Categories
    
    //MARK:- GET All Instructors
    func getAllInstructors(lang: Int) -> Observable<InstructorsModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getAllInstructors + "/\(lang)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let InstructorsData = try JSONDecoder().decode(InstructorsModel.self, from: response.data!)
                        observer.onNext(InstructorsData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET All Instructors
    //MARK:- GET Courses of Specific Category
    func getCoursesOfSpecificCategory(category_id: Int, lang: Int) -> Observable<CoursesModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getCoursesOfCategory + "\(category_id)" + "/\(lang)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CoursesData = try JSONDecoder().decode(CoursesModel.self, from: response.data!)
                        observer.onNext(CoursesData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET Courses of Specific Category
    
    //MARK:- GET Course Details
    func getCourseDetails(course_id: Int, lang: Int) -> Observable<CourseDetailsModel> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getCourseDetails + "\(course_id)" + "/\(lang)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CourseDetailsData = try JSONDecoder().decode(CourseDetailsModel.self, from: response.data!)
                        observer.onNext(CourseDetailsData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GET Course Details
    //MARK:- GET Home Data
    func getHomeData(lang: Int) -> Observable<HomeModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getHomeData + "/\(lang)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let homeData = try JSONDecoder().decode(HomeModelJSON.self, from: response.data!)
                        observer.onNext(homeData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GET Home Data
    //MARK:- GET All Courses
    func getAllCourses(params: [String: Any], lang: Int) -> Observable<AllCoursesModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getAllCourses + "/\(lang)"
            let token = Helper.getAPIToken() ?? ""
            let headers = [
                "Authorization": "Bearer \(token)"
            ]
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: headers)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CoursesData = try JSONDecoder().decode(AllCoursesModelJSON.self, from: response.data!)
                        observer.onNext(CoursesData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET All Courses
    
    //MARK:- GET Related Courses
    func getRelatedCourses(course_id: Int, lang: Int) -> Observable<RelatedCoursesModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getRelatedCourses + "/\(course_id)" + "/\(lang)"

            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let CoursesData = try JSONDecoder().decode(RelatedCoursesModelJSON.self, from: response.data!)
                        observer.onNext(CoursesData)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            return Disposables.create()
        }
    }//END of GET Related Courses
    
    //MARK:- GET InstructorDetails
    func getInstructorDetails(instructor_id: Int) -> Observable<InstructorDetailsModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getInstructorDetails + "\(instructor_id)"
            
            Alamofire.request(url, method: .get, parameters: nil, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(InstructorDetailsModelJSON.self, from: response.data!)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GET InstructorDetails
    //MARK:- GET Course Comments Data
    func getCourseComments(params: [String: Any]) -> Observable<CommentsModelJSON> {
        return Observable.create { (observer) -> Disposable in
            let url = ConfigURLS.getCourseComments
            
            Alamofire.request(url, method: .get, parameters: params, encoding: URLEncoding.default, headers: nil)
                .validate(statusCode: 200..<300)
                .responseJSON { (response: DataResponse<Any>) in
                    do {
                        let data = try JSONDecoder().decode(CommentsModelJSON.self, from: response.data!)
                        print(data)
                        observer.onNext(data)
                    } catch {
                        print(error.localizedDescription)
                        observer.onError(error)
                    }
            }
            
            return Disposables.create()
        }
    }//END of GET Course Comments Data
}
