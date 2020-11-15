//
//  ArticalesVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
//
//  CourseDetails.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import StepProgressBar
import RxSwift
import RxCocoa
import Charts

class ArticalesDetailsVC : UIViewController {

    @IBOutlet weak var CourseImageView: UIImageView!
  
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var DescriptionTV: UITextView!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var feedBackTableView: UITableView!
    @IBOutlet weak var chaerView : BarChartView!

    

    private var courseViewModel = CourseDetailsViewModel()
    
    var maxHeight: CGFloat = UIScreen.main.bounds.size.height
    var disposeBag = DisposeBag()
   
    let feedBackIdentifier = "ReviewsCell"
    
    var courseData : TrendCourse?{
        didSet {
            DispatchQueue.main.async {
//                self.ContentTableView.reloadData()
//                self.ContentTableView.invalidateIntrinsicContentSize()
//                self.ContentTableView.layoutIfNeeded()
            }
        }
    }

    var course_id = Int()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupContentTableView()
        setData()
    }

        
    
    @IBAction func backAction(_ sender: UIButton) {
          self.navigationController?.popViewController(animated: true)
      }

    
    @IBAction func instractorAction(_ sender: UIButton) {
        guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstractorProfileVc") as? InstractorProfileVc else { return }
        self.navigationController?.pushViewController(main, animated: true)
    }
    
}

extension ArticalesDetailsVC {
    func getCourseDetails(course_id: Int) {
        self.courseViewModel.getCourseDetails(course_id: course_id).subscribe(onNext: { (courseDetails) in
            if let data =  courseDetails.data {
                self.courseData = data
                self.courseNameLabel.text = data.name ?? ""
                guard let url = URL(string: "https://dev.fv.academy/public/files/" + (data.mainImage ?? "") ) else { return }
                 self.CourseImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "DetailsImage"))

              
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
    

    
}



extension ArticalesDetailsVC : UITableViewDelegate, UITableViewDataSource {
    func setupContentTableView() {
     
        self.feedBackTableView.delegate = self
        self.feedBackTableView.dataSource = self
        self.feedBackTableView.register(UINib(nibName: feedBackIdentifier , bundle: nil), forCellReuseIdentifier: feedBackIdentifier)
    
        self.feedBackTableView.rowHeight = UITableView.automaticDimension
        self.feedBackTableView.estimatedRowHeight = UITableView.automaticDimension
        self.feedBackTableView.invalidateIntrinsicContentSize()
        self.feedBackTableView.layoutIfNeeded()
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  3
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      guard let cell = tableView.dequeueReusableCell(withIdentifier: feedBackIdentifier) as? ReviewsCell else { return UITableViewCell()}
       cell.config(UserImageURL: "" ,UserName : "hazem",UserRating : 0.0, UserComment : "hi sweety" )
        cell.rateView.isHidden = true
        return cell
        
    }
}

extension ArticalesDetailsVC : ChartViewDelegate {
   
    
    func chartValueSelected(_ chartView: ChartViewBase, entry: ChartDataEntry, highlight: Highlight) {
        print("hazem")
    }
    func setData(){
        let yValue : [BarChartDataEntry] = [
             BarChartDataEntry(x: 10, y: 0),
             BarChartDataEntry(x: 20, y: 0),
             BarChartDataEntry(x: 30, y: 0),
             BarChartDataEntry(x: 40, y: 0),
             BarChartDataEntry(x: 50, y: 0),
             ]
        
        let set1 = BarChartDataSet(entries: yValue)
        let data = BarChartData(dataSet: set1)
        self.chaerView.data = data
    }
    
}
