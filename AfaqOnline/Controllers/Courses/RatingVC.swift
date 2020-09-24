//
//  RatingVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import Cosmos
import RxSwift
import RxCocoa

class RatingVC: UIViewController {

    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var postButton: UIButton!
    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var courseDescriptionTextView: CustomTextView!
    @IBOutlet weak var enrollerImageView1: CustomImageView!
    @IBOutlet weak var enrollerImageView2: CustomImageView!
    @IBOutlet weak var enrollerImageView3: CustomImageView!
    @IBOutlet weak var enrollerImageView4: CustomImageView!
    @IBOutlet weak var enrollersCounter: UILabel!
    @IBOutlet weak var EnrollerView: CustomView!
    @IBOutlet weak var ratingView: CosmosView!
    @IBOutlet weak var commentTextView: CustomTextView!
    @IBOutlet weak var submitButton: CustomButtons!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    var rating = Double()
    var price = String()
    var courseName = String()
    var courseDetails = String()
    private let ratingVM = RatingViewModel()
    var disposeBag = DisposeBag()
    var course_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        _ = self.commentTextView.rx.text.map({$0 ?? ""}).bind(to: ratingVM.Comment).disposed(by: disposeBag)
        switch UIDevice().type {
        case .iPhone4, .iPhone5, .iPhone6, .iPhone6S, .iPhone7, .iPhone8, .iPhone5S, .iPhoneSE, .iPhoneSE2:
            self.submitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.submitButton.frame.width - 75), bottom: 0, right: 0)
        default:
            self.submitButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: (self.submitButton.frame.width - 75), bottom: 0, right: 0)
        }
        
        commentTextView.text = "Write your experience"
        commentTextView.textColor = UIColor.lightGray
        let enrollViewGesture = UITapGestureRecognizer(target: self, action:  #selector(self.EnrollAction))
        self.EnrollerView.addGestureRecognizer(enrollViewGesture)
        commentTextView.delegate = self
        ratingView.didTouchCosmos = { (rate) in
            self.rating = rate
        }
        self.courseNameLabel.text = courseName
        self.courseDescriptionTextView.text = courseDetails
        self.priceLabel.text = "\(self.price) SAR"
        self.searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }
    @objc func EnrollAction(sender : UITapGestureRecognizer) {
        // Do what you want
        print("Enroll Action")
        guard let main = UIStoryboard(name: "PaymentMethod", bundle: nil).instantiateViewController(withIdentifier: "PaymentVC") as? PaymentVC else { return }
        main.courseName = self.courseNameLabel.text ?? ""
        main.price = self.priceLabel.text ?? ""
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func submitAction(_ sender: CustomButtons) {
        self.ratingVM.showIndicator()
        self.AddRate(course_id: self.course_id, user_id: Helper.getUserID() ?? 0, rating: self.rating)
    }
    @IBAction func SearchAction(_ sender: UIButton) {
        if self.searchTF.isHidden {
            Constants.shared.searchingEnabled = true
            self.searchTF.isHidden = false
        } else {
            Constants.shared.searchingEnabled = false
            self.searchTF.isHidden = true
        }
    }
    @IBAction func searchDidEndEditing(_ sender: CustomTextField) {
        if Constants.shared.searchingEnabled {
            guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
            main.modalPresentationStyle = .overFullScreen
            main.modalTransitionStyle = .crossDissolve
            main.search_name = self.searchTF.text ?? ""
            self.searchTF.text = ""
            self.searchTF.isHidden = true
            self.present(main, animated: true, completion: nil)
            //                self.navigationController?.pushViewController(main, animated: true)
        }
    }
    
}

extension RatingVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}

extension RatingVC {
    func AddRate(course_id: Int, user_id: Int, rating: Double) {
        self.ratingVM.AddRate(course_id: course_id, user_id: user_id, rate_value: rating).subscribe(onNext: { (ratingModel) in
            if ratingModel.status ?? false {
                displayMessage(title: "", message: "Your Review Have been added", status: .success, forController: self)
                self.navigationController?.popViewController(animated: true)
            }
            self.ratingVM.dismissIndicator()
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            self.ratingVM.dismissIndicator()
            }).disposed(by: disposeBag)
    }
}
extension RatingVC: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == UIColor.lightGray {
            textView.text = nil
            textView.textColor = #colorLiteral(red: 0.1333333333, green: 0.1411764706, blue: 0.3333333333, alpha: 1)
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty || textView.text == "" {
            commentTextView.text = "Write your experience"
            commentTextView.textColor = UIColor.lightGray
        }
    }
}
