//
//  LocationListViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/29.
//

import CloudKit
import SwiftUI

final class LocationListViewModel:ObservableObject{
    
    @Published var checkedInProfiles:[CKRecord.ID:[DDGProfile]] = [:]
    
    func getCheckInProfilesDictionary(){
        CloudKitManager.shared.getCheckedInProfilesDictionary { result in
            DispatchQueue.main.async {
                switch result{
                case .success(let checkedInProfiles):
                    self.checkedInProfiles = checkedInProfiles
                case .failure(_):
                    print("Debug: Error getting back dictionary")
                }
            }
            
        }
    }
    
    func createVoiceOverSummary(for location:DDGLocation) -> String{
        let count = checkedInProfiles[location.id,default: []].count
        let personPlurality = count == 1 ? "person" : "people"
        return "\(location.name) \(count) \(personPlurality) checkedin."
    }
    
    @ViewBuilder func createLocationDetailView(for location: DDGLocation, in sizeCategory: ContentSizeCategory) -> some View{
        
        if sizeCategory >= .accessibilityMedium{
            LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
        }else{
            LocationDetailView(viewModel: LocationDetailViewModel(location: location))
        }
    }
     
}
