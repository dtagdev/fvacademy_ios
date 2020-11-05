//
//  SideMenuModel.swift
//  AfaqOnline
//
//  Created by MGoKu on 6/11/20.
//  Copyright © 2020 Dtag. All rights reserved.
//

import Foundation
import UIKit


struct SideMenuModel {
    var Name: String
     var Id: String
    var image: UIImage
    
    init(Name: String, Id: String, image: UIImage) {
        self.Name = Name
        self.Id = Id
        self.image = image
    }
}
