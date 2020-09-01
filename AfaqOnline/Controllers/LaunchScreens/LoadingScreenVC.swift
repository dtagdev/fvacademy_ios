//
//  ViewController.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/5/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class LoadingScreenVC: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        Timer.scheduledTimer(withTimeInterval: 2, repeats: false) { timer in
            guard let window = UIApplication.shared.keyWindow else { return }
            let main = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LanguageScreenVC")
            window.rootViewController = main
            UIView.transition(with: window, duration: 1, options: .curveEaseInOut, animations: nil, completion: nil)
        }
    }


}

