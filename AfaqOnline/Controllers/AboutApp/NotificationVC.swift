//
//  NotificationVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/23/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift


class NotificationVC : UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var NotificationTableView : UITableView!

    
    private let AboutViewModel = AboutAppViewModel()
    let cellIdentifier = "NotificationCell"

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


extension NotificationVC : UITableViewDelegate, UITableViewDataSource {
   
    func setupContentTableView() {
        self.NotificationTableView.delegate = self
        self.NotificationTableView.dataSource = self
        self.NotificationTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
        self.NotificationTableView.rowHeight = UITableView.automaticDimension
        self.NotificationTableView.estimatedRowHeight = UITableView.automaticDimension
        self.NotificationTableView.sectionHeaderHeight = UITableView.automaticDimension
        self.NotificationTableView.estimatedSectionHeaderHeight = UITableView.automaticDimension
        self.NotificationTableView.invalidateIntrinsicContentSize()
        self.NotificationTableView.layoutIfNeeded()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
         guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? NotificationCell else { return UITableViewCell()}
        return cell
    }

}

