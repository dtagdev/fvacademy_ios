//
//  ContactUS.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
//
//  AboutAppVc.swift
//  AfaqOnline
//
//  Created by MAC on 9/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation

import UIKit
import RxSwift


class ContactUsVC: UIViewController {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!


    private let AboutViewModel = AboutAppViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
        AboutViewModel.showIndicator()
        self.getContactUs()
    }
    
  

        override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(true)
            searchTF.isHidden = true
            searchTF.text = ""
        }
        
        @IBAction func FiltrationAction(_ sender: UIButton) {
            if self.searchTF.isHidden {
                Constants.shared.searchingEnabled = true
                self.searchTF.isHidden = false
            } else {
                Constants.shared.searchingEnabled = false
                self.searchTF.isHidden = true
            }
        }
        
        @IBAction func BackAction(_ sender: UIButton) {
            guard let window = UIApplication.shared.keyWindow else { return }
            guard let main = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController") as? RAMAnimatedTabBarController else { return }
            window.rootViewController = main
            UIView.transition(with: window, duration: 0.5, options: .beginFromCurrentState, animations: nil, completion: nil)
        }
        @IBAction func SearchDidEndEditing(_ sender: CustomTextField) {
               if Constants.shared.searchingEnabled {
                   guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
                   main.modalPresentationStyle = .overFullScreen
                   main.modalTransitionStyle = .crossDissolve
                   main.search_name = self.searchTF.text ?? ""
                self.searchTF.text = ""
                self.searchTF.isHidden = true
                   self.present(main, animated: true, completion: nil)
               }
           }
    }
  extension ContactUsVC: UITextFieldDelegate {
        func textFieldShouldReturn(_ textField: UITextField) -> Bool {
            self.searchTF.resignFirstResponder()
            return true
        }
    }

extension ContactUsVC {
    func getContactUs() {
        AboutViewModel.getContactUS().subscribe(onNext: { (about) in
            if about.errors != nil {
                if "lang".localized == "ar" {
                    displayMessage(title: "", message: "حدث خطأ ما يرجى المحاولة في وقت اللاحق.", status: .error, forController: self)
                } else {
                    displayMessage(title: "", message: about.errors ?? "", status: .error, forController: self)
                }

            } else {
                self.phoneLabel.text = about.data?.phone ?? ""
                self.emailLabel.text = about.data?.email ?? ""
                self.addressLabel.text = about.data?.address ?? ""
                if "lang".localized == "ar" {
                    self.nameLabel.text = "تواصل معانا"
                } else {
                    self.nameLabel.text = "Contact Us"
                }
            }
            self.AboutViewModel.dismissIndicator()
        }, onError: { (error) in

            if "lang".localized == "ar" {
                displayMessage(title: "", message: "حدث خطأ ما يرجى المحاولة في وقت لاحق", status: .error, forController: self)
            } else {
                displayMessage(title: "", message: "Something went wrong please try again later", status: .error, forController: self)
            }
            self.AboutViewModel.dismissIndicator()
        }).disposed(by: disposeBag)
    }

}
