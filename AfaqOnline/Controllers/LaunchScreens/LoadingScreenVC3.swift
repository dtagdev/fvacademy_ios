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

    @IBAction func signUpAction(_ sender: CustomButtons) {
        guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    @IBAction func browseAction(_ sender: CustomButtons) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController")
        window.rootViewController = sb
    }
    
    
    @IBAction func userAction(_ sender: CustomButtons) {
          guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "LoginVC") as? LoginVC else { return }
          self.navigationController?.pushViewController(main, animated: true)
          
      }
      
    @IBAction func instractorAction(_ sender: CustomButtons) {
     guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
        main.type = "instructor"
        self.navigationController?.pushViewController(main, animated: true)

      }
    

}

