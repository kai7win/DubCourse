//
//  AppTabViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/29.
//


import SwiftUI

extension AppTabView{
    final class AppTabViewModel:NSObject,ObservableObject{
        
        @Published var isShowingOnboardView = false
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false{
            didSet{ isShowingOnboardView = hasSeenOnboardView }
        }
        
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        
        func checkIfHasSeenOnboard(){
            if !hasSeenOnboardView{ hasSeenOnboardView = true }
        }

    }
}



