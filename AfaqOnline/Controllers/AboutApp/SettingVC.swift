//
//  SettingVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift


class SettingVC  : UIViewController {
    

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var myAccountButton: UIButton!
    @IBOutlet weak var languageButton: UIButton!
    @IBOutlet weak var contactUSButton: UIButton!
    @IBOutlet weak var rateUSButton: UIButton!
    
    private let AboutViewModel = AboutAppViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
        }
    
    
    @IBAction func myAccountButtonAction(_ sender: UIButton) {
        guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "MyAccountVC") as? MyAccountVC else { return }
        self.navigationController?.pushViewController(main, animated: true)
    }
    
    @IBAction func languageButtonButtonAction(_ sender: UIButton) {
       let sb = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LanguageScreenVC")
        self.navigationController?.pushViewController(sb, animated: true)
     }
    
    @IBAction func contactUSButtonAction(_ sender: UIButton) {
            guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "ContactVC") as? ContactVC else { return }
         self.navigationController?.pushViewController(main, animated: true)
     }
    
    @IBAction func rateUSButtonAction(_ sender: UIButton) {
               guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "PrivecyVC") as? PrivecyVC else { return }
            self.navigationController?.pushViewController(main, animated: true)
        }
   
}


