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

class CourseDetailsVC: UIViewController {

    @IBOutlet weak var CourseImageView: UIImageView!
    @IBOutlet weak var enrollerImageView1: CustomImageView!
    @IBOutlet weak var enrollerImageView2: CustomImageView!
    @IBOutlet weak var enrollerImageView3: CustomImageView!
    @IBOutlet weak var enrollerImageView4: CustomImageView!
    @IBOutlet weak var enrollersCounter: UILabel!
    @IBOutlet weak var price_discountLabel: UILabel!
    @IBOutlet weak var enrollView: CustomView!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseTimeLabel: CustomLabel!
    @IBOutlet weak var courseDescriptionTextView: CustomTextView!
    @IBOutlet weak var courseInformationLabel: UILabel!
    @IBOutlet weak var currentStepNameLabel: UILabel!
    @IBOutlet weak var currentStepDateLabel: UILabel!
    @IBOutlet weak var currentStepTimeLabel: UILabel!
    @IBOutlet weak var courseContentDataLabel: UILabel!
    @IBOutlet weak var ContentTableView: CustomTableView!
    @IBOutlet weak var stepProgressBar: StepProgressBar!
    private var courseViewModel = CourseDetailsViewModel()
    var disposeBag = DisposeBag()
    let cellIdentifier = "CourseContentCell"
    var courseData = [String]() {
        didSet {
            DispatchQueue.main.async {
                self.ContentTableView.reloadData()
            }
        }
    }
    var course_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let enrollViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.EnrollAction))
        self.enrollView.addGestureRecognizer(enrollViewGesture)
        setupContentTableView()
        self.getCourseDetails(course_id: course_id)
    }
    @objc func EnrollAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("Enroll Action")
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    

}

extension CourseDetailsVC {
    func getCourseDetails(course_id: Int) {
        self.courseViewModel.getCourses(course_id: course_id).subscribe(onNext: { (courseDetails) in
            if let data =  courseDetails.data {
                self.courseNameLabel.text = data.name ?? ""
                self.courseDescriptionTextView.text = data.details ?? ""
                self.price_discountLabel.attributedText = NSAttributedString(attributedString: "50".strikeThrough()) + NSAttributedString(string: " \(data.price ?? "")")
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
extension CourseDetailsVC: UITableViewDelegate, UITableViewDataSource {
    func setupContentTableView() {
        self.ContentTableView.delegate = self
        self.ContentTableView.dataSource = self
        self.ContentTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Introduction"
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return courseData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? CourseContentCell else { return UITableViewCell()}
        
        return cell
    }
}
