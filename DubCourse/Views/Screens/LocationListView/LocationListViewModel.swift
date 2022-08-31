//
//  LocationListViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/29.
//

import CloudKit
import SwiftUI

extension LocationListView{
    
    @MainActor final class LocationListViewModel:ObservableObject{
        
        @Published var checkedInProfiles:[CKRecord.ID:[DDGProfile]] = [:]
        @Published var alertItem:AlertItem?
        
//ios 14
//        func getCheckInProfilesDictionary(){
//            CloudKitManager.shared.getCheckedInProfilesDictionary { result in
//                DispatchQueue.main.async { [self] in
//                    switch result{
//                    case .success(let checkedInProfiles):
//                        self.checkedInProfiles = checkedInProfiles
//                    case .failure(_):
//                        alertItem = AlertContext.unableToGetAllCheckInProfiels
//                    }
//                }
//
//            }
//        }
        
        func getCheckInProfilesDictionary(){
            Task{
                do {
                    checkedInProfiles = try await CloudKitManager.shared.getCheckedInProfilesDictionary()
                } catch {
                    alertItem = AlertContext.unableToGetAllCheckInProfiels
                }
            }
        }
        
        func createVoiceOverSummary(for location:DDGLocation) -> String{
            let count = checkedInProfiles[location.id,default: []].count
            let personPlurality = count == 1 ? "person" : "people"
            return "\(location.name) \(count) \(personPlurality) checkedin."
        }
        
        @MainActor  @ViewBuilder func createLocationDetailView(for location: DDGLocation, in dynamicTypeSize: DynamicTypeSize) -> some View{
            
            if dynamicTypeSize >= .accessibility3{
                LocationDetailView(viewModel: LocationDetailViewModel(location: location)).embedInScrollView()
            }else{
                LocationDetailView(viewModel: LocationDetailViewModel(location: location))
            }
        }
    }
    
}
