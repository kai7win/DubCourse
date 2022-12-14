//
//  LocationMapViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import MapKit
import CloudKit
import SwiftUI

extension LocationMapView{
    
     final class LocationMapViewModel:NSObject,ObservableObject,CLLocationManagerDelegate{
        
        @Published var checkedInProfiles:[CKRecord.ID:Int] = [:]
        @Published var isShowingDetailView = false
        @Published var alertItem:AlertItem?
        @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        
        let deviceLocationManager = CLLocationManager()
        
        override init() {
            super.init()
            deviceLocationManager.delegate = self
        }
        
        func requestAllowOnceLocationPermission(){
            deviceLocationManager.requestLocation()
        }
        
        func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
            guard let currentLocation = locations.last else { return }
            withAnimation {
                region = MKCoordinateRegion(center: currentLocation.coordinate, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
            }
        }
        
        func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            print("Debug: Did fail with Error")
        }
        

        
//ios 14
//          func getLocations(for locationManager:LocationManager){
//            CloudKitManager.shared.getLocations { result in
//                DispatchQueue.main.async {
//                    switch result {
//
//                    case .success(let locations):
//                        locationManager.locations = locations
//                    case .failure(_):
//                        self.alertItem = AlertContext.unableToGetLocations
//                    }
//                }
//            }
//        }
        
        
        //ios15
        func getLocations(for locationManager:LocationManager){
            Task {
                do {
                    locationManager.locations = try await CloudKitManager.shared.getLocations()
                }catch{
                    alertItem = AlertContext.unableToGetLocations
                }
            }
        }
        
//ios 14
//        func getCheckedInCounts(){
//            CloudKitManager.shared.getCheckedInProfilesCount { result in
//
//                DispatchQueue.main.async { [self] in
//                    switch result{
//                    case .success(let checkedInProfiles):
//                        self.checkedInProfiles = checkedInProfiles
//                    case .failure(_):
//                        alertItem = AlertContext.checkInCount
//                        break
//                    }
//                }
//            }
//        }
        
        //ios 15
        func getCheckedInCounts(){
            Task{
                do{
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesCount()
                }catch{
                    alertItem = AlertContext.checkInCount
                }
            }
        }
        
        @MainActor @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View{
            
            if dynamicTypeSize >= .accessibility3{
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            }else{
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }
    
}
