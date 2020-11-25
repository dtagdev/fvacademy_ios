//
//  HelpVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift


class HelpVC : UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var questionTableView : UITableView!

    
    private let AboutViewModel = AboutAppViewModel()
    let cellIdentifier = "HelpCell"

    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupContentTableView()
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
        }
    
}


extension HelpVC : UITableViewDelegate, UITableViewDataSource {
   
    func setupContentTableView() {
        self.questionTableView.delegate = self
        self.questionTableView.dataSource = self
        self.questionTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.questionTableView.rowHeight = UITableView.automaticDimension
        self.questionTableView.estimatedRowHeight = UITableView.automaticDimension
        self.questionTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.questionTableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.questionTableView.invalidateIntrinsicContentSize()
        self.questionTableView.layoutIfNeeded()

    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? HelpCell else { return UITableViewCell()}
        if indexPath.row == 0 {
            cell.answerLabel.isHidden = false
        }
          cell.showAnswert = {
            cell.answerLabel.isHidden = false
            self.questionTableView.reloadData()
        }
        return cell
    }

}

