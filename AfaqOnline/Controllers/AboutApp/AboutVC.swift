//
//  AboutVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//


import UIKit
import RxSwift


class AboutVC : UIViewController {
    

    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var PrivacyButton: UIButton!
    @IBOutlet weak var TermsConditionsButton: UIButton!
    @IBOutlet weak var AboutButton: UIButton!

    
    var appPageType = String()

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
    
    @IBAction func PrivacyButtonAction(_ sender: UIButton) {
           guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "PrivecyVC") as? PrivecyVC else { return }
        main.appPageType = "Return"

        self.navigationController?.pushViewController(main, animated: true)

    }
    @IBAction func TermsConditionsButtonAction(_ sender: UIButton) {
            guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "PrivecyVC") as? PrivecyVC else { return }
        main.appPageType = "Terms"
         self.navigationController?.pushViewController(main, animated: true)

     }
    @IBAction func AboutButtonAction(_ sender: UIButton) {
            guard let main = UIStoryboard(name: "AboutApp", bundle: nil).instantiateViewController(withIdentifier: "PrivecyVC") as? PrivecyVC else { return }
        main.appPageType = "About"
         self.navigationController?.pushViewController(main, animated: true)

     }
    
    }


