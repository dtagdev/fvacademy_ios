//
//  CustomAudioController.swift
//  SevenArt
//
//  Created by D-TAG on 11/21/19.
//  Copyright © 2019 D-TAG. All rights reserved.
//

import Foundation
import IQAudioRecorderController

class CustomAudioViewController {
    
    var delegate: IQAudioRecorderViewControllerDelegate
    
    init(delegate: IQAudioRecorderViewControllerDelegate) {
        self.delegate = delegate
    }
    
    func presentAudioRecorder(target: UIViewController) {
        let audioController =  IQAudioRecorderViewController()
        audioController.normalTintColor = #colorLiteral(red: 0.2392156869, green: 0.6745098233, blue: 0.9686274529, alpha: 1)
        audioController.delegate = delegate
        audioController.title = "Record"
        audioController.maximumRecordDuration = 120
        audioController.allowCropping = true
        //        self.addChild(popOverVC)
        //        popOverVC.view.frame = self.view.frame
        //        self.view.addSubview(popOverVC.view)
        //        popOverVC.didMove(toParent: self)
        target.presentBlurredAudioRecorderViewControllerAnimated(audioController)
        
    }
}
