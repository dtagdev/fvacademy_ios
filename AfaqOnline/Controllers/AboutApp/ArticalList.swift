//
//  ArticalList.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//



import UIKit
import RxCocoa
import RxSwift


class ArticalListVC: UIViewController {

    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var OrdersTableView: UITableView!
    @IBOutlet weak var backButton: UIButton!
    
    var Articles = [Article]() {
        didSet {
            DispatchQueue.main.async {
                self.ArticleVM.fetchArtical(data: self.Articles)
            }
        }
    }
    var ArticleVM = ArticalViewModel()
    var disposeBag = DisposeBag()
    
    let cellIdentifier = "ArticalCell"
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        setupOrdersTableView()
        searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
        self.ArticleVM.showIndicator()
        getMyCourses()
    }
    

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }
    
    @IBAction func FiltrationAction(_ sender: UIButton) {
        if self.searchTF.isHidden {
            Constants.shared.searchingEnabled = true
            self.searchTF.isHidden = false
        } else {
            Constants.shared.searchingEnabled = false
            self.searchTF.isHidden = true
        }
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        guard let window = UIApplication.shared.keyWindow else { return }
        guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
        window.rootViewController = main
        UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
    }
    @IBAction func SearchDidEndEditing(_ sender: CustomTextField) {
           if Constants.shared.searchingEnabled {
               guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
               main.modalPresentationStyle = .overFullScreen
               main.modalTransitionStyle = .crossDissolve
               main.search_name = self.searchTF.text ?? ""
            self.searchTF.text = ""
            self.searchTF.isHidden = true
               self.present(main, animated: true, completion: nil)
           }
       }
}
extension ArticalListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
extension ArticalListVC: UITableViewDelegate {
    
    func setupOrdersTableView() {
        OrdersTableView.rx.setDelegate(self).disposed(by: disposeBag)
        OrdersTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.ArticleVM.Article.bind(to: self.OrdersTableView.rx.items(cellIdentifier: cellIdentifier, cellType: ArticalCell.self)) { index, element, cell in
            cell.config(articalName: self.Articles[index].title ?? "", articalDesc: self.Articles[index].details ?? "")
        }.disposed(by: disposeBag)
        self.OrdersTableView.rx.itemSelected.bind { (indexPath) in
            guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "ArticalcontentVc") as? ArticalcontentVc else { return }
            main.id = self.Articles[indexPath.row].id ?? 0
            main.progressName = self.Articles[indexPath.row].title ?? ""
            main.progressDescription = self.Articles[indexPath.row].details ?? ""
            self.navigationController?.pushViewController(main, animated: true)
        }.disposed(by: disposeBag)
        
        self.OrdersTableView.rx.contentOffset.bind { (contentOffset) in
            
        }.disposed(by: disposeBag)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
}
extension ArticalListVC {
    func getMyCourses() {
        self.ArticleVM.getMyArtical().subscribe(onNext: { (myArticalModel) in
            if let error = myArticalModel.errors {
                displayMessage(title: "", message: error, status: .error, forController: self)
            } else if let myArticle = myArticalModel.data?.articles {
                self.ArticleVM.dismissIndicator()
                self.Articles = myArticle
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
