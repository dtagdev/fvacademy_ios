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

    @IBOutlet weak var InstructorsCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    

    private let instructorViewModel = InstructorsViewModel()
    var disposeBag = DisposeBag()
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
        setupInstructorsCollectionView()
        getInstructors(lth: 0,htl: 0,rate : 0)
        self.instructorViewModel.showIndicator()
        self.hideKeyboardWhenTappedAround()
    }

    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
 
}
extension InstructorsVC {
    //MARK:- GET Instructors
    func getInstructors(lth: Int,htl: Int,rate: Int) {
        self.instructorViewModel.getInstructors(lth: lth,htl: htl,rate: rate).subscribe(onNext: { (instructorsModel) in
            if let data = instructorsModel.data.instructors {
                self.instructorViewModel.dismissIndicator()
                self.Instructors = data
            }
        }, onError: { (error) in
            self.instructorViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension InstructorsVC : UICollectionViewDelegate {
    
    func setupInstructorsCollectionView() {
        let cellIdentifier = "HomeInstructorCell"
        self.InstructorsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.InstructorsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.instructorViewModel.Instructors.bind(to: self.InstructorsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: HomeInstructorCell.self)) { index, element, cell in
            let instructorData = self.Instructors[index].user
            cell.config(InstructorImageURL: self.Instructors[index].image ?? "", InstructorName: "\(instructorData?.firstName ?? "") \(instructorData?.lastName ??  "")",rating:((self.Instructors[index].rate?.rounded(toPlaces: 1) ?? 0)))
        }.disposed(by: disposeBag)
        self.InstructorsCollectionView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "Instructors", bundle: nil).instantiateViewController(withIdentifier: "InstractorProfileVc") as? InstractorProfileVc else { return }
            main.id = self.Instructors[indexPath.row].id ?? 0
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
    }
}

extension InstructorsVC: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space) / 3.1
            return CGSize(width: size, height: size)
        }
}
