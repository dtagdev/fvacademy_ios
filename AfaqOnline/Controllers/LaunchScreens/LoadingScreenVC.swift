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
        
        
    }

    @IBAction func nextAction(_ sender: CustomButtons) {
      
        guard let window = UIApplication.shared.keyWindow else { return }
        let main = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LoadingScreenVC2")
        window.rootViewController = main
        
    }
    
    @IBAction func skipAction(_ sender: CustomButtons) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController")
        window.rootViewController = sb
               
    }
    

}

