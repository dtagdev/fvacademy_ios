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

class ProfileVC : UIViewController {

    @IBOutlet weak var ProfileImageView: CustomImageView!
    @IBOutlet weak var UserNameLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var emailLabel : UILabel!
    @IBOutlet weak var idNumber: UILabel!
    @IBOutlet weak var medicalNumber: UILabel!
    @IBOutlet weak var editButton: UIButton!
    @IBOutlet weak var registerLabel: UILabel!

    
    
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
         setupMultiColorRegisterLabel()
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.hideKeyboardWhenTappedAround()
        
        let gestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(self.RegisterTapAction(_:)))
        registerLabel.isUserInteractionEnabled = true
        registerLabel.addGestureRecognizer(gestureRecognizer)
        
    }

}
    

    
    @objc func RegisterTapAction(_ sender: UITapGestureRecognizer) {
        guard let main = UIStoryboard(name: "Authentication", bundle: nil).instantiateViewController(withIdentifier: "RegistrationVC") as? RegistrationVC else { return }
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    
    
    func setupMultiColorRegisterLabel() {
        let main_string = "Don’t have an account? Sign Up"
        let coloredString = "Sign Up"
        
        let Range = (main_string as NSString).range(of: coloredString)
        
        let attribute = NSMutableAttributedString.init(string: main_string)
        attribute.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red , range: Range)
        registerLabel.attributedText = attribute
    }
    
}

//MARK:- Getting Data From Observable
extension ProfileVC {
}
