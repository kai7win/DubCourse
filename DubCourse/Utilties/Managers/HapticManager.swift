//
//  HapticManager.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/30.
//

import UIKit

struct HapticManager{
    
    static func playSuccess(){
        let generator = UINotificationFeedbackGenerator()
        generator.notificationOccurred(.success)
    }
}


