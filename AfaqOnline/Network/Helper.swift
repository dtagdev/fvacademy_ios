//
//  Helper.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/18/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class Helper {
    
    class func restartApp() {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil)
        var vc: UIViewController
        if Helper.getAPIToken() == nil{
            // go to login Screen
            vc = sb.instantiateViewController(withIdentifier: "HomeTabController")
            Singletone.instance.appUserType = .guest
        } else {
            let role = Helper.getUserRole() ?? 0
            switch role {
            case 1:
                // go to main Screen
                vc = sb.instantiateViewController(withIdentifier: "HomeTabController")
//                Authentication.postSetToken(params: params, userType: "user") { (errro, result) in
//                    if let result = result {
//                        if result.successMessage != "" {
//                            print("Device Token have been set")
//                        } else {
//                            print("Error Happened")
//                        }
//                    }
//                }
            Singletone.instance.appUserType = .customer
            default:
                vc = sb.instantiateViewController(withIdentifier: "HomeTabController")
                Singletone.instance.appUserType = .guest
            }
        }
        window.rootViewController = vc
        UIView.transition(with: window, duration: 0.5, options: .transitionFlipFromRight, animations: nil, completion: nil)
    }
    
    //Save API Token Function to userDefaults
    class func saveAPIToken(user_id: Int,email: String, role: Int, name: String, token: String) {
        let def = UserDefaults.standard
        def.set(token, forKey: "token")
        //def.set(token_type, forKey: "token_type")
        def.set(user_id, forKey: "user_id")
        def.set(email, forKey: "email")
        def.set(role, forKey: "role")
        def.set(name, forKey: "name")
        def.synchronize()
        //restartApp()
    }
    class func saveAPIToken(token: String) {
        let def = UserDefaults.standard
        def.set(token, forKey: "token")
       // def.set(token_type, forKey: "token_type")
        def.synchronize()
        //restartApp()
        }
    class func getAPIToken() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "token") as? String
    }
    class func getTokenType() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "token_type") as? String
    }
    class func saveDeviceToken(deviceToken: String) {
        let def = UserDefaults.standard
        def.set(deviceToken, forKey: "deviceToken")
    }
    class func saveCurrency(currency: String) {
        let def = UserDefaults.standard
        def.set(currency, forKey: "current_currency")
    }
    class func getCurrentCurrency() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "current_currency") as? String
    }
    class func getDeviceToken() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "deviceToken") as? String
    }
    class func getImageURL() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "imageURL") as? String
    }
    class func getUserEmail() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "email") as? String
    }
    class func getUserRole() -> Int? {
        let def = UserDefaults.standard
        return def.object(forKey: "role") as? Int
    }
    class func getUserID() -> Int? {
        let def = UserDefaults.standard
        return def.object(forKey: "user_id") as? Int
    }
    class func getUserName() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "name") as? String
    }
    class func LogOut() {
        let def = UserDefaults.standard
        def.removeObject(forKey: "token")
        def.removeObject(forKey: "token_type")
        def.removeObject(forKey: "user_id")
        def.removeObject(forKey: "email")
        def.removeObject(forKey: "role")
        def.removeObject(forKey: "name")
        def.synchronize()
    }
    class func saveCartCounter(Cart counter: Int) {
        let def = UserDefaults.standard
        def.set(counter, forKey: "cart_counter")
    }
    
    class func getCartCounter() -> Int? {
        let def = UserDefaults.standard
        return def.object(forKey: "cart_counter") as? Int
    }
    class func saveVerificationCode(VerificationCode Code: String) {
        let def = UserDefaults.standard
        def.set(Code, forKey: "VerificationCode")
    }
    class func getVerificationCode() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "VerificationCode") as? String
    }
    class func saveLang(Lang: String) {
        let def = UserDefaults.standard
        def.set(Lang, forKey: "Lang")
    }
    class func getLang() -> String? {
        let def = UserDefaults.standard
        return def.object(forKey: "Lang") as? String
    }
}

