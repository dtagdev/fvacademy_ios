//
//  EditProfile.swift
//  AfaqOnline
//
//  Created by MAC on 11/15/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
//
//  ProfileVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

class EditProfile : UIViewController {

    @IBOutlet weak var ProfileImageView: CustomImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var emailTF: CustomTextField!
    @IBOutlet weak var usernameTF: CustomTextField!
    @IBOutlet weak var idNumberTF: CustomTextField!
    @IBOutlet weak var medicalNumberTF: CustomTextField!
    
    let token = Helper.getAPIToken() ?? ""

    private var ProfileVM = ProfileViewModel()

    var disposeBag = DisposeBag()
    var Items = [SideMenuModel]() {
        didSet {
            DispatchQueue.main.async {
                self.ProfileVM.fetchItems(data: self.Items)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.hideKeyboardWhenTappedAround()
    }
  
  
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func EditProfileAction(_ sender: CustomButtons) {
        
    }
}


//MARK:- Getting Data From Observable
extension EditProfile {
}
