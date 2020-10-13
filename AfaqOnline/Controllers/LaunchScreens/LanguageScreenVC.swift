//
//  LanguageScreenVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/17/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import MOLH
class LanguageScreenVC: UIViewController {
    
    var type = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func EnglishLanguageAction(_ sender: CustomButtons) {
        Helper.saveLang(Lang: "en")
        if MOLHLanguage.currentAppleLanguage() == "ar" {
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            Helper.saveCurrency(currency: "SAR")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
            MOLH.reset()
        } else {
            if ("lang".localized == "en") {
                displayMessage(title: "", message: "Your App is Already in English Language", status: .info, forController: self)
            } else {
                displayMessage(title: "", message: "البرنامج بالفعل على اللغة الإنجليزية", status: .info, forController: self)
            }
            if type == "home" {
                guard let window = UIApplication.shared.keyWindow else { return }
                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
                window.rootViewController = main
               
                UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
            } else {
                     guard let window = UIApplication.shared.keyWindow else { return }
                let main = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LoadingScreenVC")
                window.rootViewController = main
                UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
            }
             UIView.appearance().semanticContentAttribute = .forceLeftToRight
        }
        
        
    }
    @IBAction func ArabicLanguageAction(_ sender: CustomButtons) {
        Helper.saveLang(Lang: "ar")
        if MOLHLanguage.currentAppleLanguage() == "en" {
            MOLH.setLanguageTo(MOLHLanguage.currentAppleLanguage() == "en" ? "ar" : "en")
            Helper.saveCurrency(currency: "ريال")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
            MOLH.reset()
        } else {
            if ("lang".localized == "en") {
                displayMessage(title: "", message: "Your App is Already in Arabic Language", status: .info, forController: self )
            } else {
                displayMessage(title: "", message: "البرنامج بالفعل على اللغة العربية", status: .info, forController: self )
            }
            if type == "home" {
                guard let window = UIApplication.shared.keyWindow else { return }
                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
                window.rootViewController = main
                UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
            } else {
                guard let window = UIApplication.shared.keyWindow else { return }
                let main = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LoadingScreenVC")
                window.rootViewController = main
                UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
            }
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
    }
    
}
