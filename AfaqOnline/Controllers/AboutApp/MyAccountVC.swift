//
//  MyAccountVC.swift
//  AfaqOnline
//
//  Created by MAC on 11/22/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift


class MyAccountVC : UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var passwordView : UIView!
  
    
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
    
    
    var showing  = false
    @IBAction func changePassAction(_ sender: UIButton) {
        if showing ==  false  {
        passwordView.isHidden = false
            self.showing  = true
        }else{
            passwordView.isHidden = true
            self.showing  = false

        }
    }
    
 

}


