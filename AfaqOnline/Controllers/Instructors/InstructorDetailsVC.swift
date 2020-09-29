//
//  InstructorDetailsVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class InstructorDetailsVC: UIViewController {
    
    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var InstructorNameLabel: UILabel!
    @IBOutlet weak var InstructorImageView: CustomImageView!
    @IBOutlet weak var InstructorEmailLabel: UILabel!
    @IBOutlet weak var InstructorRating: UILabel!
    @IBOutlet weak var NumberOfCoursesLabel: UILabel!
    @IBOutlet weak var WelcomeHeaderLabel: UILabel!
    @IBOutlet weak var InstructorSummaryTV: CustomTextView!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    
    private let instructorViewModel = InstructorsViewModel()
    var disposeBag = DisposeBag()
    
    var Ads = ["Heya"]
    //        [String]() {
    //        didSet {
    //            DispatchQueue.main.async {
    //                self.categoryViewModel.fetchAds(Ads: self.Ads)
    //            }
    //        }
    //    }
    var instructor_id = Int()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupAdsCollectionView()
        self.InstructorNameLabel.adjustsFontSizeToFitWidth = true
        self.InstructorNameLabel.minimumScaleFactor = 0.5
        self.InstructorEmailLabel.adjustsFontSizeToFitWidth = true
        self.InstructorEmailLabel.minimumScaleFactor = 0.5
        self.InstructorRating.adjustsFontSizeToFitWidth = true
        self.InstructorRating.minimumScaleFactor = 0.5
        self.NumberOfCoursesLabel.adjustsFontSizeToFitWidth = true
        self.NumberOfCoursesLabel.minimumScaleFactor = 0.5
        self.WelcomeHeaderLabel.adjustsFontSizeToFitWidth = true
        self.WelcomeHeaderLabel.minimumScaleFactor = 0.5
        self.InstructorSummaryTV.textContainerInset = UIEdgeInsets(top: 0, left: 10, bottom: 0, right: 10)
        self.searchTF.delegate = self
        self.instructorViewModel.showIndicator()
        self.getInstructorDetails(instructor_id: self.instructor_id)
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
        self.instructorViewModel.fetchAds(Ads: self.Ads)
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
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension InstructorDetailsVC {
    func getInstructorDetails(instructor_id: Int) {
        self.instructorViewModel.getInstructorDetails(instructor_id: instructor_id).subscribe(onNext: { (InstructorModel) in
            if let data = InstructorModel.data {
                self.instructorViewModel.dismissIndicator()
                let user = data.user
                self.InstructorNameLabel.text = "\(user?.firstName ?? "") \(user?.lastName ??  "")"
                self.InstructorEmailLabel.text = user?.email ?? ""
                self.InstructorRating.text = "\(4) Instructor Rating"
                self.InstructorSummaryTV.text = data.details ?? ""
                self.NumberOfCoursesLabel.text = "\(data.courses?.count ?? 0) Courses"
                if data.image ?? "" != "" {
                    guard let url = URL(string: "https://dev.fv.academy/public/files/" + (data.image ?? "")) else { return }
                    self.InstructorImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "userProfile"))
                }
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension InstructorDetailsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
extension InstructorDetailsVC : UICollectionViewDelegate {
    
    func setupAdsCollectionView() {
        let cellIdentifier = "AdsCell"
        self.AdsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.AdsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.instructorViewModel.Ads.bind(to: self.AdsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AdsCell.self)) { index, element, cell in
            cell.config(Type: "Image", imageURL: "")
            cell.AdOpenActionClosure = {
                
            }
        }.disposed(by: disposeBag)
        self.AdsCollectionView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
    }
}
extension InstructorDetailsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
        let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
        
        let size:CGFloat = (collectionView.frame.size.width - space)
        return CGSize(width: size, height: collectionView.frame.size.height - 10)
    }
}
