//
//  ArticalList.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//



import UIKit
import RxCocoa
import RxSwift


class ArticalListVC : UIViewController {}
extension ArticalListVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
extension ArticalListVC: UITableViewDelegate {}

