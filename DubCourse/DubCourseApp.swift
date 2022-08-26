//
//  DubCourseApp.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import SwiftUI

@main
struct DubCourseApp: App {
    
    let locationManager = LocationManager()
    
    var body: some Scene {
        WindowGroup {
            AppTabView().environmentObject(locationManager)
        }
    }
}
