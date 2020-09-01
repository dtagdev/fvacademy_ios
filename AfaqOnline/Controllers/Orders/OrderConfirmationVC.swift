//
//  OrderConfirmationVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/31/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit

class OrderConfirmationVC: UIViewController {

    @IBOutlet weak var CourseNameLabel: UILabel!
    @IBOutlet weak var CoursePriceLabel: CustomLabel!
    @IBOutlet weak var SubtotalLabel: CustomLabel!
    @IBOutlet weak var VATaxesLabel: CustomLabel!
    @IBOutlet weak var TotalPriceLabel: CustomLabel!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    var courseName = String()
    var coursePrice = String()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.CourseNameLabel.text = courseName
        self.CoursePriceLabel.text = "SAR \(coursePrice)"
        self.SubtotalLabel.text = "SAR \(coursePrice)"
        self.TotalPriceLabel.text = "SAR \((Double(coursePrice) ?? 0.0) + 25.0)"
        self.searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }

    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func YourCoursesAction(_ sender: CustomButtons) {
        print("Go To Your Courses")
    }
    @IBAction func BrowseMoreAction(_ sender: CustomButtons) {
        guard let window = UIApplication.shared.keyWindow else { return }
        let sb = UIStoryboard(name: "Home", bundle: nil).instantiateViewController(withIdentifier: "HomeTabController")
        //                main.showBackButton = true
        window.rootViewController = sb
        UIView.transition(with: window, duration: 0.5, options: .curveEaseInOut, animations: nil, completion: nil)
    }
    @IBAction func SearchAction(_ sender: UIButton) {
        if self.searchTF.isHidden {
            Constants.shared.searchingEnabled = true
            self.searchTF.isHidden = false
        } else {
            Constants.shared.searchingEnabled = false
            self.searchTF.isHidden = true
        }
    }
    @IBAction func searchDidEndEditing(_ sender: CustomTextField) {
        if Constants.shared.searchingEnabled {
            guard let main = UIStoryboard(name: "Filtration", bundle: nil).instantiateViewController(withIdentifier: "FiltrationVC") as? FiltrationVC else { return }
            main.modalPresentationStyle = .overFullScreen
            main.modalTransitionStyle = .crossDissolve
            main.search_name = self.searchTF.text ?? ""
            self.searchTF.text = ""
            self.searchTF.isHidden = true
            self.present(main, animated: true, completion: nil)
            //self.navigationController?.pushViewController(main, animated: true)
        }
    }
}

extension OrderConfirmationVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}
