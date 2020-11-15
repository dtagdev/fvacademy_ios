//
//  LiveVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//



import UIKit
import RxSwift
import RxCocoa
import DropDown

class LiveVC : UIViewController {
    
    @IBOutlet weak var EventsCollectionView: UICollectionView!
    @IBOutlet weak var backButton: UIButton!
    
    private let eventViewModel = EventsViewModel()
    var disposeBag = DisposeBag()

    var Events = [Event]() {
        didSet {
            DispatchQueue.main.async {
                self.eventViewModel.fetchEvents(Events: self.Events)
            }
        }
    }
    
    var categoryName = String()
    var currentPage = 1
    var loading = false
    var loadMore = false
    var type = String()
    var previousScreen = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupEventsCollectionView()
        self.eventViewModel.showIndicator()
        self.getAllEvents(lth: 0,htl: 0,rate: 0)
        self.hideKeyboardWhenTappedAround()
    }
    
    @IBAction func backAction(_ sender: UIButton) {
            self.navigationController?.popViewController(animated: true)
    }
}

extension LiveVC {
    
    func getNextPage() {
        self.getAllEvents(lth: 0,htl: 0,rate: 0)
    }
    
    func getAllEvents(lth: Int,htl: Int,rate: Int) {
        self.eventViewModel.getAllEvent(lth: lth,htl: htl,rate: rate).subscribe(onNext: { (EventModelJSON) in
            self.eventViewModel.dismissIndicator()
            if let data = EventModelJSON.data.events {
                if !self.loadMore {
                    self.Events = data

                } else {
                    self.Events.append(contentsOf: data)
                }

//                let dataClass = CoursesModelJSON.data ??
//                if dataClass.to != nil && data.count != 0 {
//                    self.currentPage += 1
//                    self.loadMore = true
//                    if self.currentPage == 2 {
//                        self.getNextPage()
//                    }
//
//                } else {
//                    self.loadMore = false
//                }

                self.loading = false
            }
        }, onError: { (error) in
            self.eventViewModel.dismissIndicator()
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
        }).disposed(by: disposeBag)
    }
}
extension LiveVC : UICollectionViewDelegate {
    
    func setupEventsCollectionView() {
        let cellIdentifier = "AllLiveCell"
        self.EventsCollectionView.rx.setDelegate(self).disposed(by: disposeBag)
        self.EventsCollectionView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        self.eventViewModel.Events.bind(to: self.EventsCollectionView.rx.items(cellIdentifier: cellIdentifier, cellType: AllLiveCell.self)) { index, element, cell in
           // cell.config(eventName: self.Events[index].name ?? "", eventDesc:  self.Events[index].eventDescription ?? "", eventStartTime: self.Events[index].startDate ?? "", eventEndTime:  self.Events[index].endDate ?? "", eventType: "", rating: 4.6, price:(Double(self.Events[index].price ?? "") ?? 0.0), discountPrice: ((Double(self.Events[index].price ?? "") ?? 0.0) - (Double(self.Events[index].discount ?? "") ?? 0.0)), imageURL: self.Events[index].mainImage ?? "",  videoURL: self.Events[index].eventURL ?? "", userImages: [""])
            cell.openDetailsAction = {
                
            }
        }.disposed(by: disposeBag)
        self.EventsCollectionView.rx.itemSelected.bind { (indexPath) in
//            guard let main = UIStoryboard(name: "Events", bundle: nil).instantiateViewController(withIdentifier: "EventsDetailsVC") as? EventsDetailsVC else { return }
//            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
        
    }
}

extension LiveVC: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
            let flowayout = collectionViewLayout as? UICollectionViewFlowLayout
            let space: CGFloat = (flowayout?.minimumInteritemSpacing ?? 0.0) + (flowayout?.sectionInset.left ?? 0.0) + (flowayout?.sectionInset.right ?? 0.0)
            
            let size:CGFloat = (collectionView.frame.size.width - space)
            return CGSize(width: size, height: 140)
        }
}
