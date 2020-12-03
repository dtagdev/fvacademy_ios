//
//  HomeVC.swift
//  AfaqOnline
//
//  Created by MGoKu on 5/19/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa


class HomeVC: UIViewController {

   
    

 
  
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

       
        
        
        // Do any additional setup after loading the view.
        setupAdsCollectionView()
        setupCoursesCollectionView()
        setupCategoryCollectionView()
        setupEventsCollectionView()
        setupInstructorCollectionView()
         setupArticalCollectionView()
        self.getHomeData()
        self.hideKeyboardWhenTappedAround()
        self.homeViewModel.showIndicator()
     }

    
    override func viewWillAppear(_ animated: Bool) {
           super.viewWillAppear(true)
       }
       
    
       
       @IBAction func sideMenuAction(_ sender: UIBarButtonItem) {
           self.setupSideMenu()
         }
       
    
    }
    
   
    



//MARK:- Data Binding
extension HomeVC: UICollectionViewDelegate {
    func setupAdsCollectionView(){}
    func setupCoursesCollectionView(){}
    
    func setupEventsCollectionView(){}
    
    func setupCategoryCollectionView(){}
    func setupArticalCollectionView(){}
    
    func setupInstructorCollectionView() {}
}

extension HomeVC: UICollectionViewDelegateFlowLayout {
    
}
