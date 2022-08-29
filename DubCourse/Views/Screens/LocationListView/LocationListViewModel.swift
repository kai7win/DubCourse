//
//  LocationListViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/29.
//

import CloudKit

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
    
}
