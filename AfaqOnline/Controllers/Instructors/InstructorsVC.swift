//
//  InstructorsVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/21/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import DropDown

class InstructorsVC: UIViewController {

    @IBOutlet weak var AdsCollectionView: UICollectionView!
    @IBOutlet weak var InstructorsCollectionView: UICollectionView!
    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    //SortBy Drop Down
    let SortByDropDown = DropDown()
    var SortByNames = ["Default", "High To Low", "Low To High", "Rate"]
    var SortByIds = [0, 1, 2,3]
    var selectedSortById = Int()
    
    //Filter Drop Down
    let FilterDropDown = DropDown()
    var FilterNames = ["Filer","Test1", "Test2"]
    var FilterIds = [0, 1, 2]
    var selectedFilterId = Int()
    private let instructorViewModel = InstructorsViewModel()
    var disposeBag = DisposeBag()
    var Ads = ["Heya"]{
            didSet {
                DispatchQueue.main.async {
                    self.instructorViewModel.fetchAds(Ads: self.Ads)
                }
            }
        }
    var Instructors = [Instructor]() {
        didSet {
            DispatchQueue.main.async {
                self.instructorViewModel.fetchInstructors(Instructors: self.Instructors)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupAdsCollectionView()
        setupInstructorsCollectionView()
        BindButtonActions()
        SetupSortByDropDown()
        SetupFilterDropDown()
        getInstructors(lth: 0,htl: 0,rate : 0)
        self.instructorViewModel.showIndicator()
        self.searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
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
    func SetupSortByDropDown() {
        self.SortByDropDown.anchorView = self.sortByButton
        self.SortByDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        self.SortByDropDown.dataSource = self.SortByNames
        self.SortByDropDown.selectionAction = { [weak self] (index, item) in
            self?.sortByButton.setTitle(item, for: .normal)
            if index == 0{
                self?.getInstructors(lth: 0,htl: 0,rate : 0)
            }else if index == 1 {
                self?.getInstructors(lth: 0,htl: 1,rate : 0)
            }else if index == 2{
                self?.getInstructors(lth: 1,htl: 0,rate : 0)
            }else if index == 3{
                self?.getInstructors(lth: 0,htl: 0,rate : 1)
            }

        }
        self.SortByDropDown.direction = .bottom
        self.SortByDropDown.width = self.view.frame.width * 0.95
    }
    func SetupFilterDropDown() {
        self.FilterDropDown.anchorView = self.FilterButton
        self.FilterDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        self.FilterDropDown.dataSource = self.FilterNames
        self.FilterDropDown.selectionAction = { [weak self] (index, item) in
            self?.FilterButton.setTitle(item, for: .normal)
            self?.selectedFilterId = self?.FilterIds[index] ?? 0
        }
        self.FilterDropDown.direction = .bottom
        self.FilterDropDown.width = self.view.frame.width * 0.95
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
extension InstructorsVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
extension InstructorsVC {
    //MARK:- GET Instructors
    func getInstructors(lth: Int,htl: Int,rate: Int) {
        self.instructorViewModel.getInstructors(lth: lth,htl: htl,rate: rate).subscribe(onNext: { (instructorsModel) in
            if let data = instructorsModel.data.instructors {
                self.instructorViewModel.dismissIndicator()
                self.Instructors = data
                self.instructorViewModel.fetchAds(Ads: self.Ads)
            }
        }, onError: { (error) in
            self.instructorViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension InstructorsVC : UICollectionViewDelegate {
    func BindButtonActions() {
        self.sortByButton.rx.tap.bind {
            self.SortByDropDown.show()
        }.disposed(by: disposeBag)
        self.FilterButton.rx.tap.bind {
//            self.FilterDropDown.show()
            guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
            main.modalPresentationStyle = .overFullScreen
            main.modalTransitionStyle = .crossDissolve
            main.search_name = self.searchTF.text ?? ""
            self.present(main, animated: true, completion: nil)
        }.disposed(by: disposeBag)
    }
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
    
    func setupInstructorsCollectionView() {
        let cellIdentifier = "InstructorsCell"
        self.InstructorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.InstructorsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.instructorViewModel.Instructors.bind(to: self.InstructorsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: InstructorsCell.self)) { index, element, cell in
            let instructorData = self.Instructors[index].user
            cell.config(InstructorImageURL: self.Instructors[index].image ?? "", InstructorName: "\(instructorData?.firstName ?? "") \(instructorData?.lastName ?? "")")
        }.disposed(by: disposeBag)
        self.InstructorsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstructorDetailsVC") as? InstructorDetailsVC else { return }
            main.instructor_id = self.Instructors[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension InstructorsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == AdsCollectionView {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: collectionView.frame.size.height - 10)
        } else  {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
            return CGSize(width: size, height: size)
        }
    }
}
