//
//  PaymentVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/28/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class PaymentVC: UIViewController {

    @IBOutlet weak var courseNameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var showAddCardView: CustomView!
    @IBOutlet weak var cardNameTF: CustomTextField!
    @IBOutlet weak var expiryDateTF: CustomTextField!
    @IBOutlet weak var cardNumberTF: CustomTextField!
    @IBOutlet weak var CCVTF: CustomTextField!
    @IBOutlet weak var paymentMethodsTableView: CustomTableView!
    @IBOutlet weak var noPaymentsLabel: UILabel!
    @IBOutlet weak var searchTF: CustomTextField!
    @IBOutlet weak var backButton: UIButton!
    var DatePicker = UIDatePicker()
    var paymentMethods = [PaymentsModel]() {
        didSet {
            DispatchQueue.main.async {
                self.paymentMethodsTableView.reloadData()
                if self.paymentMethods.count == 0 {
                    self.noPaymentsLabel.isHidden = false
                } else {
                    self.noPaymentsLabel.isHidden = true
                }
            }
        }
    }
    var price = String()
    var courseName = String()
    let cellIdentifier = "PaymentMethodsCell"
    
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        if "lang".localized == "ar" {
            self.backButton.setImage(#imageLiteral(resourceName: "nextAr"), for: .normal)
        } else {
            self.backButton.setImage(#imageLiteral(resourceName: "back"), for: .normal)
        }
        self.priceLabel.adjustsFontSizeToFitWidth = true
        self.priceLabel.minimumScaleFactor = 0.5
        DatePicker.datePickerMode = .date
        expiryDateTF.inputView = DatePicker
        DatePicker.addTarget(self, action: #selector(dateChanged(DatePicker:)), for: .valueChanged)
        setupPaymentMethodsTableView()
        self.courseNameLabel.text = self.courseName
        self.priceLabel.text = "\(price) SAR"
        _ = cardNameTF.rx.controlEvent([.editingChanged]).asObservable().bind(onNext: { (_) in
            guard self.validate() else {
                self.cardNameTF.borderColor = #colorLiteral(red: 0.521568656, green: 0.1098039225, blue: 0.05098039284, alpha: 1)
                self.cardNameTF.borderWidth = 1
                return }
            self.cardNameTF.borderColor = #colorLiteral(red: 0.4666666687, green: 0.7647058964, blue: 0.2666666806, alpha: 1)
        }).disposed(by: disposeBag)
        self.searchTF.delegate = self
        self.hideKeyboardWhenTappedAround()
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        searchTF.isHidden = true
        searchTF.text = ""
    }
    @objc func dateChanged(DatePicker: UIDatePicker) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/yy"
            expiryDateTF.text = dateFormatter.string(from: DatePicker.date)
    //        self.view.endEditing(true)
        }
    @IBAction func backAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    @IBAction func AddPaymentAction(_ sender: UIButton) {
        if showAddCardView.isHidden {
            self.showAddCardView.isHidden = false
        } else {
            self.showAddCardView.isHidden = true
        }
    }
    @IBAction func SubmitAction(_ sender: UIButton) {
        guard let main = UIStoryboard(name: "PaymentMethod", bundle: nil).instantiateViewController(withIdentifier: "OrderConfirmationVC") as? OrderConfirmationVC else { return }
        main.courseName = self.courseName
        main.coursePrice = self.price
        self.navigationController?.pushViewController(main, animated: true)
        
    }
    @IBAction func AddPaymentMethod(_ sender: CustomButtons) {
        guard let cardName = self.cardNameTF.text else {
            displayMessage(title: "", message: "Please Enter Card Name First", status: .error, forController: self)
            return }
        self.paymentMethods.append(PaymentsModel(cardImage: "", cardName: cardName, cardNumber: self.cardNumberTF.text ?? "", cardCCV: self.CCVTF.text ?? "", expiryDate: self.expiryDateTF.text ?? "", selected: false))
        displayMessage(title: "", message: "PaymentMethod Added Successfully (Test)", status: .success, forController: self)
        self.showAddCardView.isHidden = true
        self.clearAllTexts()
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
            //                self.navigationController?.pushViewController(main, animated: true)
        }
        
    }
    private func validate() -> Bool {
        if self.cardNameTF.text!.isEmpty {
            displayMessage(title: "", message: "Please Write your card name", status: .error, forController: self)
            return false
        } else if !self.cardNameTF.text!.validateEnglishCharsInput() {
            displayMessage(title: "", message: "Please write your card name in English Only", status: .error, forController: self)
            return false
        } else {
            return true
        }
    }
}
extension PaymentVC: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        self.searchTF.resignFirstResponder()
        return true
    }
}

extension PaymentVC: UITableViewDelegate, UITableViewDataSource {
    func setupPaymentMethodsTableView() {
        self.paymentMethodsTableView.delegate = self
        self.paymentMethodsTableView.dataSource = self
        self.paymentMethodsTableView.register(UINib(nibName: cellIdentifier, bundle: nil), forCellReuseIdentifier: cellIdentifier)
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.paymentMethods.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? PaymentMethodsCell else { return UITableViewCell()}
        cell.config(cardImageURL: "", cardNumber: self.paymentMethods[indexPath.row].cardName ?? "", selected: self.paymentMethods[indexPath.row].selected ?? false)
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        for i in 0..<self.paymentMethods.count {
            if i == indexPath.row {
                self.paymentMethods[i].selected = true
            } else {
                self.paymentMethods[i].selected = false
            }
        }
    }
    
}
