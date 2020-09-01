//
//  SearchResultsVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/10/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import DropDown
import RxSwift
import RxCocoa

class SearchResultsVC: UIViewController {

    @IBOutlet weak var FilterButton: UIButton!
    @IBOutlet weak var sortByButton: UIButton!
    @IBOutlet weak var ResultsTableView: CustomTableView!
    @IBOutlet weak var searchTermHeaderLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    var SearchVM = SearchViewModel()
    var disposeBag = DisposeBag()
    private let cellIdentifier = "SearchCell"
    
    var results = [CoursesData]() {
        didSet {
            DispatchQueue.main.async {
                self.SearchVM.fetchResults(data: self.results)
            }
        }
    }
    //SortBy Drop Down
    let SortByDropDown = DropDown()
    var SortByNames = ["Default","High To Low", "Low To High", "Rate"]
    var SortByIds = [0, 1, 2]
    var selectedSortById = Int()
    
    //Filter Drop Down
    let FilterDropDown = DropDown()
    var FilterNames = ["Filer","Test1", "Test2"]
    var FilterIds = [0, 1, 2]
    var selectedFilterId = Int()
    //Pagination Handling
    var currentPage = 1
    var loading = false
    var loadMore = false
    
    var search_name = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupDropDownMenus()
        setupResultTableView()
        SetupSortByDropDown()
        SetupFilterDropDown()
        BindButtonActions()
        self.getSearchResult(search_name: self.search_name)
    }
    
    @IBAction func backButton(_ sender: UIButton) {
//        self.navigationController?.popViewController(animated: true)
        self.dismiss(animated: true, completion: nil)
    }
    func SetupSortByDropDown() {
        self.SortByDropDown.anchorView = self.sortByButton
        self.SortByDropDown.bottomOffset = CGPoint(x: 0, y: 50)
        self.SortByDropDown.dataSource = self.SortByNames
        self.SortByDropDown.selectionAction = { [weak self] (index, item) in
            self?.sortByButton.setTitle(item, for: .normal)
            self?.selectedSortById = self?.SortByIds[index] ?? 0
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
}

extension SearchResultsVC {
    func getSearchResult(search_name: String) {
        self.searchTermHeaderLabel.text = "\"\(self.search_name)\""
        self.SearchVM.getSearchResults(name: search_name).subscribe(onNext: { (CourseModel) in
            if let data = CourseModel.data {
                self.results = data
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}

extension SearchResultsVC: UITableViewDelegate {
    func BindButtonActions() {
        self.sortByButton.rx.tap.bind {
            self.SortByDropDown.show()
        }.disposed(by: disposeBag)
        self.FilterButton.rx.tap.bind {
//            self.FilterDropDown.show()
        }.disposed(by: disposeBag)
    }
    func setupDropDownMenus() {
        self.FilterButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.FilterButton.frame.width - 20, bottom: 0, right: 0)
        self.FilterButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
        self.sortByButton.imageEdgeInsets = UIEdgeInsets(top: 0, left: self.sortByButton.frame.width - 20, bottom: 0, right: 0)
        self.sortByButton.titleEdgeInsets = UIEdgeInsets(top: 0, left: -40, bottom: 0, right: 0)
    }
    func setupResultTableView() {

        self.ResultsTableView.rx.setDelegate(self).disposed(by: disposeBag)
        self.ResultsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.SearchVM.Results.bind(to: self.ResultsTableView.rx.items(cellIdentifier: self.cellIdentifier, cellType: SearchCell.self)) { index, element, cell in
            cell.config(InstructorImageUrl: "", CourseName: self.results[index].name ?? "", InstructorName: "TestInstructor", CourseTime: self.results[index].time ?? "", CoursePrice: self.results[index].price ?? "", discountPrice: self.results[index].discount ?? "")
        }.disposed(by: disposeBag)
        
        self.ResultsTableView.rx.itemSelected.bind { (indexPath) in
            
        }.disposed(by: disposeBag)
        self.ResultsTableView.rx.contentOffset.bind { (contentOffset) in
            if contentOffset.y + self.ResultsTableView.frame.size.height + 10 > self.ResultsTableView.contentSize.height && self.loadMore && !self.loading {
                print("ResultsTableView Load More")
                
            }
        }.disposed(by: disposeBag)
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 120
    }
}
