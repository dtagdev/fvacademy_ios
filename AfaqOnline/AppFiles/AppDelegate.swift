//
//  AppDelegate.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/5/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import MOLH

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, MOLHResetable {
    var window: UIWindow?
    let token = Helper.getAPIToken() ?? ""
    func reset() {
        if self.token == "" {
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
            
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
            Singletone.instance.appUserType = .guest
        } else {
            switch Singletone.instance.appUserType {
            case .customer:
                guard let window = UIApplication.shared.keyWindow else { return }
                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
                window.rootViewController = main
                UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
                Singletone.instance.appUserType = .customer
            case .guest:
                guard let window = UIApplication.shared.keyWindow else { return }
                guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
                window.rootViewController = main
                UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
                Singletone.instance.appUserType = .guest
            
                
            }
        }
        
    }
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        //Change Color of UITextField Cursor
        UITextField.appearance().tintColor = UIColor.red
        if #available(iOS 13.0, *) {
            let appearance = UINavigationBarAppearance()
            appearance.backgroundColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            appearance.titleTextAttributes = [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
            appearance.largeTitleTextAttributes = [.foregroundColor: #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)]
            
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            UINavigationBar.appearance().standardAppearance = appearance
            UINavigationBar.appearance().compactAppearance = appearance
            UINavigationBar.appearance().scrollEdgeAppearance = appearance
        } else {
            UINavigationBar.appearance().tintColor = #colorLiteral(red: 0, green: 0, blue: 0, alpha: 1)
            UINavigationBar.appearance().barTintColor = #colorLiteral(red: 0, green: 0.5898008943, blue: 1, alpha: 1)
            UINavigationBar.appearance().isTranslucent = false
        }
        MOLH.shared.activate(true)
        MOLH.shared.specialKeyWords = ["Cancel","Done"]
        if ("lang".localized == "en") {
            MOLHLanguage.setDefaultLanguage("en")
            Helper.saveLang(Lang: "en")
            UIView.appearance().semanticContentAttribute = .forceLeftToRight
        } else {
            MOLHLanguage.setDefaultLanguage("ar")
            Helper.saveLang(Lang: "ar")
            UIView.appearance().semanticContentAttribute = .forceRightToLeft
        }
        
        if token != "" {
           let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController")
            window?.rootViewController = sb
            Singletone.instance.appUserType = .customer
        } else if Helper.getLang() != "" {
            let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController")
            window?.rootViewController = sb
            Singletone.instance.appUserType = .guest
        } else {
        let sb = UIStoryboard(name: "LoadingScreens", bundle: nil).instantiateViewController(withIdentifier: "LoadingScreenVC")
         window?.rootViewController = sb
         Singletone.instance.appUserType = .guest
        }
        IQKeyboardManager.shared.enable = true
        PusherManager.shared.connectPusher()
        return true
    }
    
}

