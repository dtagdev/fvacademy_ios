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
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
 
        if token != "" {
            self.getProfile()
        }

    }
  
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
        
    }
    
    @IBAction func EditProfileAction(_ sender: CustomButtons) {
        
    }
}


//MARK:- Getting Data From Observable
extension EditProfile {
    func getProfile() {
        self.ProfileVM.getProfile().subscribe(onNext: { (ProfileModel) in
            if let profile = ProfileModel.data {
                self.UserNameLabel.text = "\(profile.firstName ??  "") \(profile.lastName ??  "")"
                self.emailTF.text = profile.email ?? ""
                self.idNumberTF.text = profile.idNumber ?? ""
                self.medicalNumberTF.text = profile.medicalNumber ?? ""
                self.usernameTF.text = "\(profile.firstName ??  "") \(profile.lastName ??  "")"
                if profile.avatar ?? "" != "" {
                    guard let url = URL(string: "https://dev.fv.academy/public/files/" + (profile.avatar ?? "")) else { return }
                    self.ProfileImageView.kf.setImage(with: url, placeholder: #imageLiteral(resourceName: "placeholder"))
                }
            }
        }, onError: { (error) in
            displayMessage(title: "", message: error.localizedDescription, status: .error, forController: self)
            }).disposed(by: disposeBag)
    }
}
