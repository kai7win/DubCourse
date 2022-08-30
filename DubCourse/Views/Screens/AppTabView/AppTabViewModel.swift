//
//  AppTabViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/29.
//

import MapKit
import SwiftUI

extension AppTabView{
    final class AppTabViewModel:NSObject,ObservableObject,CLLocationManagerDelegate {
        
        @Published var isShowingOnboardView = false
        @Published var alertItem:AlertItem?
        @AppStorage("hasSeenOnboardView") var hasSeenOnboardView = false{
            didSet{ isShowingOnboardView = hasSeenOnboardView }
        }
        
        var deviceLocationManager:CLLocationManager?
        let kHasSeenOnboardView = "hasSeenOnboardView"
        
        
        func runStartupChecks(){
            if !hasSeenOnboardView{
                hasSeenOnboardView = true
            }else{
                checkIfLocationServiceIsEnable()
            }
        }
        
        func checkIfLocationServiceIsEnable(){
            if CLLocationManager.locationServicesEnabled(){
                deviceLocationManager = CLLocationManager()
                deviceLocationManager!.delegate = self
            }else{
                //show an alert
                alertItem = AlertContext.locationDisable
            }
        }
        
        private func checkLocationAuthorization(){
            
            guard let deviceLocationManager = deviceLocationManager else {  return print("Debug: no deviceLocation") }
            
            switch deviceLocationManager.authorizationStatus {
            case .notDetermined:
                deviceLocationManager.requestWhenInUseAuthorization()
            case .restricted:
                //show alert
                alertItem = AlertContext.locationRestricted
            case .denied:
                //show alert
                alertItem = AlertContext.locationDenied
                
            case .authorizedAlways,.authorizedWhenInUse:
                break
            @unknown default:
                break
            }
        }
        func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
            checkLocationAuthorization()
        }
    }
}



