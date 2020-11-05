//
//  CategoriesDetailsVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/3/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import UIKit
import RxSwift
import RxCocoa

class CategoriesDetailsVC : UIViewController {

    @IBOutlet weak var CoursesCollectionView: CustomCollectionView!
    @IBOutlet weak var allCoursesCollectionView: CustomCollectionView!
    @IBOutlet weak var InstructorsCollectionView: CustomCollectionView!
    @IBOutlet weak var EventsCollectionView: CustomCollectionView!
    @IBOutlet weak var TrendingButton: UIButton!
    @IBOutlet weak var InstructorButton: UIButton!
    @IBOutlet weak var EventsButton: UIButton!

    private let homeViewModel = HomeViewModel()
    var disposeBag = DisposeBag()
    var Courses = [TrendCourse]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchCourses(Courses: self.Courses)
            }
        }
    }
        
    var Events = [Event](){
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchEvents(Events: self.Events)
            }
        }
    }

    
    var Instructors = [Instructor]() {
        didSet {
            DispatchQueue.main.async {
                self.homeViewModel.fetchInstructors(Instructors: self.Instructors)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupCoursesCollectionView()
        setupEventsCollectionView()
        setupInstructorCollectionView()
        setupAllCoursesCollectionView()
        self.getHomeData()
        self.homeViewModel.showIndicator()
        
     }
    
    @IBAction func SeeAllActions(_ sender: UIButton) {
        switch sender.tag {
        case 1:
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "NewCoursesVC") as? NewCoursesVC else { return }
            main.type = "Course"
            self.navigationController?.pushViewController(main, animated: true)
        case 2:
           guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "NewCoursesVC") as? NewCoursesVC else { return }
           main.type = "Event"
           self.navigationController?.pushViewController(main, animated: true)
        case 3:
            guard let main = UIStoryboard(name: "Categories", bundle: nil).instantiateViewController(withIdentifier: "CategoryInstractorVC") as? CategoryInstractorVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        default:
            break
            }
        }
    
    @IBAction func backAction(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }

    
}
//MARK:- Retrieving Backend Data
extension CategoriesDetailsVC {
    func getHomeData() {
        self.homeViewModel.getHomeData().subscribe(onNext: { (homeData) in
            if homeData.status ?? false {
                if let data = homeData.data {
                    self.homeViewModel.dismissIndicator()
                    self.Courses = data.courses ?? []
                    self.Instructors = data.instructors ?? []
                    self.Events = data.events ?? []
                    self.TrendingButton.setTitle("See All ( \(self.Courses.count) )", for: .normal)
                    self.InstructorButton.setTitle("See All ( \(self.Instructors.count) )", for: .normal)
                    self.EventsButton.setTitle("See All ( \(self.Events.count) )", for: .normal)
                
                }
                
            }
        }, onError: { (error) in
            self.homeViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}


//MARK:- Data Binding
extension CategoriesDetailsVC: UICollectionViewDelegate {
    func setupCoursesCollectionView() {
        let cellIdentifier = "CoursesCell"
        self.CoursesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.CoursesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Courses.bind(to: self.CoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: CoursesCell.self)) { index, element, cell in
            
            // cell.config(courseName: self.Courses[index].name ?? "", courseInstractor: "\(self.Courses[index].instructor?.user?.firstName ?? "") \(self.Courses[index].instructor?.user?.lastName ??  "")", courseTime: self.Courses[index].time ?? "", courseType: self.Courses[index].type ?? "", rating: ((self.Courses[index].rate?.rounded(toPlaces: 1) ?? 0)), price: Double(self.Courses[index].price ?? "0") ?? 0.0, discountPrice: ((Double(self.Courses[index].price ?? "") ?? 0.0) - (Double(self.Courses[index].discount ?? "") ?? 0.0)), imageURL: self.Courses[index].mainImage ?? "", videoURL: self.Courses[index].courseURL ?? "")
            
        }.disposed(by: disposeBag)
    }
    
    func setupEventsCollectionView() {
        let cellIdentifier = "EventsCell"
        self.EventsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.EventsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Events.bind(to: self.EventsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: EventsCell.self)) { index, element, cell in
          
            //let dis =   (Double(self.Events[index].discount ?? "") ?? 0.0)
            //let price = (Double(self.Events[index].price ?? "") ?? 0.0)
            //let result = price - dis
          //  cell.config(eventName: self.Events[index].name ?? "", eventDesc: self.Events[index].eventDescription ?? "", eventStartTime: self.Events[index].startDate ?? "", eventEndTime: self.Events[index].endDate ?? "", eventType: "", rating: ((self.Events[index].rate?.rounded(toPlaces: 1) ?? 0)) , price: Double(self.Events[index].price ?? "") ?? 0.0, discountPrice: result, imageURL: self.Events[index].mainImage ?? "" , videoURL: self.Events[index].eventURL ?? "" , userImages: [""])
       
        }.disposed(by: disposeBag)
     
    }
    
    
    func setupInstructorCollectionView() {
        
        let cellIdentifier = "HomeInstructorCell"
        self.InstructorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.InstructorsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.homeViewModel.Instructors.bind(to: self.InstructorsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeInstructorCell.self)) { index, element, cell in
            let instructorData = self.Instructors[index].user
            cell.config(InstructorImageURL: self.Instructors[index].image ?? "", InstructorName: "\(instructorData?.firstName ?? "") \(instructorData?.lastName ??  "")",rating:((self.Instructors[index].rate?.rounded(toPlaces: 1) ?? 0)))
        }.disposed(by: disposeBag)
    }
    
    func setupAllCoursesCollectionView() {
           let cellIdentifier = "AllCourseCell"
           self.allCoursesCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
           self.allCoursesCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
           self.homeViewModel.Courses.bind(to: self.allCoursesCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AllCourseCell.self)) { index, element, cell in
               //cell.config(courseName: self.Courses[index].name ?? "", courseInstractor: "\(self.Courses[index].instructor?.user?.firstName ?? "") \(self.Courses[index].instructor?.user?.lastName ??  "")", courseTime: self.Courses[index].time ?? "", courseType: self.Courses[index].type ?? "", rating: ((self.Courses[index].rate?.rounded(toPlaces: 1) ?? 0)), price: Double(self.Courses[index].price ?? "") ?? 0.0, discountPrice:((Double(self.Courses[index].price ?? "") ?? 0.0) - (Double(self.Courses[index].discount ?? "") ?? 0.0)), imageURL: self.Courses[index].mainImage ?? "", videoURL: self.Courses[index].courseURL ?? "")
               
           }.disposed(by: disposeBag)
       }
}

extension CategoriesDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
           if collectionView == CoursesCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
            
        } else if collectionView == EventsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 1.3
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
            
        } else if collectionView == allCoursesCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
             let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
             let size:CGFloat = (collectionView.frame.size.width - space) / 1
             return CGSize(width: size, height: 120)
            
        } else {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
                return CGSize(width: 140, height: 140)
        }
    }
}
