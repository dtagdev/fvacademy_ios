//
//  Constants.swift
//  Dokanak
//
//  Created by D-TAG on 1/21/20.
//  Copyright © 2020 D-tag. All rights reserved.
//

import UIKit



struct Constants {
    static var shared = Constants()
    
    var searchingEnabled = false
    var LatoBold = UIFont(name: "Lato-Bold", size: 16)
    var LatoRegular = UIFont(name: "Lato-Regular", size: 14)
    var LatoIpadBold = UIFont(name: "Lato-Bold", size: 22)
    var LatoIpadRegular = UIFont(name: "Lato-Regular", size: 18)
//    static var currency = Helper.getCurrentCurrency() ?? "SAR"
    static var CartLastScreen = "home"
    var countryCode = "EG"
    var latestAddress = String()
    var latestLat = Double()
    var latestLong = Double()
    var paymentMethod = String()
    var ElBankAlAHly = "12900000660309"
    var BankElRag7y = "263608010968214"
    var payBy = String()
    var account_number = String()
    var payment_required = String()
    var name_on_card = String()
    var card_number = String()
    var payment_amount = String()
    var verification_code = String()
}
