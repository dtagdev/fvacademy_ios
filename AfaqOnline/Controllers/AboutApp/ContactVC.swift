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




import UIKit
import RxSwift


class ContactVC : UIViewController {
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var feedBackView : UIView!
  @IBOutlet weak var reportViewView : UIView!

    
    private let AboutViewModel = AboutAppViewModel()
    var disposeBag = DisposeBag()
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    @IBAction func BackAction(_ sender: UIButton) {
        self.navigationController?.popViewController(animated: true)
    }
    
    
    var addFeedBack  = false
    @IBAction func addFeedBackAction(_ sender: UIButton) {
        if addFeedBack ==  false  {
        feedBackView.isHidden = false
            self.addFeedBack  = true
        }else{
            feedBackView.isHidden = true
            self.addFeedBack  = false

        }
    }
    
    
    var report  = false
    @IBAction func reportProblemAction(_ sender: UIButton) {
        if report ==  false  {
        reportViewView.isHidden = false
            self.report  = true
        }else{
            reportViewView.isHidden = true
            self.report  = false

        }
    }
    
 

}



