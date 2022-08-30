//
//  LocationMapViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import MapKit
import CloudKit
import SwiftUI

final class LocationMapViewModel:ObservableObject{

    @Published var checkedInProfiles:[CKRecord.ID:Int] = [:]
    @Published var isShowingDetailView = false
    @Published var alertItem:AlertItem?
    @Published var region = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.331516, longitude: -121.891054), span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))

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
    
    func getCheckedInCounts(){
        CloudKitManager.shared.getCheckedInProfilesCount { result in
            
            DispatchQueue.main.async {
                switch result{
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    //Show alert
                    break
                }
            }
        }
    }
    
    
    @ViewBuilder func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View{
        
        if sizeCategory >= .accessibilityMedium{
            LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
        }else{
            LocationDetailView(viewModel: LocationDetailViewModel(location: location))
        }
    }
    
    
}

