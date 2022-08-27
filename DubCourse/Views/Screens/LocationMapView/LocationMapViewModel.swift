//
//  LocationMapViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import MapKit

final class LocationMapViewModel:NSObject,ObservableObject{
    
    @Published var isShowingOnboardView = false
    @Published var alertItem:AlertItem?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
    
    var deviceLocationManager:CLLocationManager?
    let kHasSeenOnboardView = "hasSeenOnBoardView"
    
    var hasSeenOnboardView:Bool{
        return UserDefaults.standard.bool(forKey: kHasSeenOnboardView)
    }
    
    func runStartupChecks(){
        if !hasSeenOnboardView{
            isShowingOnboardView = true
            UserDefaults.standard.set(true, forKey: kHasSeenOnboardView)
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
    
    func getLocations(for locationManager:LocationManager){
        CloudKitManager.shared.getLocations { result in
            DispatchQueue.main.async {
                switch result {
                    
                case .success(let locations):
                    locationManager.locations = locations
                case .failure(_):
                    self.alertItem = AlertContext.unableToGetLocations
                }
            }
        }
    }
    
}

extension LocationMapViewModel: CLLocationManagerDelegate {
    func locationManagerDidChangeAuthorization(_ manager: CLLocationManager) {
        checkLocationAuthorization()
    }
}

