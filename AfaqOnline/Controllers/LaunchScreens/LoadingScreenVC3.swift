//
//  LoadingScreenVC3.swift
//  AfaqOnline
//
//  Created by MAC on 10/8/20.
//  Copyright © 2020 Dtag. All rights reserved.
//



import UIKit

class LoadingScreenVC3 : UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
    }

    @IBAction func nextAction(_ sender: CustomButtons) {
        
    }
    
    @IBAction func skipAction(_ sender: CustomButtons) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController")
        window.rootViewController = sb
               
    }
    

}

