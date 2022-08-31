//
//  ProfileViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/26.
//

import CloudKit

enum ProfileContent { case create,update }

extension ProfileView{
    
    final class ProfileViewModel:ObservableObject{
        @Published var firstName = ""
        @Published var lastName = ""
        @Published var companyName = ""
        @Published var bio = ""
        @Published var avatar = PlaceholderImage.avatar
        @Published var isShowingPhotoPicker = false
        @Published var isLoading = false
        @Published var alertItem:AlertItem?
        @Published var isCheckedIn = false
        
        private var existingProfileRecord:CKRecord? {
            didSet{ profileContent = .update }
        }
        var profileContent:ProfileContent = .create
        var buttonTitle:String{ profileContent == .create ? "Create Profile" : "Upate Profile" }
        
        
        private func isValidProfile() -> Bool{
            
            guard !firstName.isEmpty,
                  !lastName.isEmpty,
                  !companyName.isEmpty,
                  !bio.isEmpty,
                  avatar != PlaceholderImage.avatar,
                  bio.count < 100 else { return false }
            
            return true
        }
        
        func getCheckedInStatus(){
            guard let profileRecordID = CloudKitManager.shared.profileRecordID else { return }
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
                
                DispatchQueue.main.async { [self] in
                    switch result{
                    case .success(let record):
                        if let _ = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference{
                            isCheckedIn = true
                            
                        }else{
                            isCheckedIn = false
                        }
                    case .failure(_):
                        break
                    }
                }
            }
            
        }
        
        func determineButtonAction(){
            profileContent == .create ? createProfile() : updateProfile()
        }
        
        func checkout(){
            guard let profileID = CloudKitManager.shared.profileRecordID else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            showLoadingView()
            CloudKitManager.shared.fetchRecord(with: profileID) { result in
                
                
                switch result{
                case .success(let record):
                    record[DDGProfile.kIsCheckedIn] = nil
                    record[DDGProfile.kisCheckedNilCheck] = nil
                    
                    CloudKitManager.shared.save(record: record) { result in
                        self.hideLoadingView()
                        DispatchQueue.main.async { [self] in
                            switch result{
                            case .success(_):
                                isCheckedIn = false
                                HapticManager.playSuccess()
                                
                            case .failure(_):
                                alertItem = AlertContext.unableToCheckInOrOut
                            }
                        }
                    }
                case .failure(_):
                    
                    DispatchQueue.main.async {
                        self.alertItem = AlertContext.unableToCheckInOrOut
                    }
                    
                }
            }
            
        }
        
        
        private func createProfile(){
            guard isValidProfile() else {
                //show Alert
                alertItem = AlertContext.invalidProfile
                return
            }
            
            //Create our profile send it up to Cloudkit
            //1.Create our CKRecord from the ProfileView
            
            let profileRecord = createProfileRecord()
            
            //2.Get our UserRecordID from the Container(CloudKitManager.shared.userRecord)
            //3.Get UserRecord from the Public Database(CloudKitManager.shared.userRecord)
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            //4.Create reference on UserRecord to the DDGProfile we created
            userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
            
            showLoadingView()
            //5.Create a CKOperation to save our User and Profile Records
            CloudKitManager.shared.batchSave(records: [userRecord,profileRecord]) {result in
                DispatchQueue.main.async { [self] in
                    hideLoadingView()
                    
                    switch result{
                    case .success(let records):
                        
                        for record in records where record.recordType == RecordType.profile{
                            existingProfileRecord = record
                            CloudKitManager.shared.profileRecordID = record.recordID
                        }
                        alertItem = AlertContext.createProfileSuccess
                    case .failure(_):
                        //show alert
                        alertItem = AlertContext.createProfileFailure
                        break
                    }
                    
                }
                
            }
            
            
        }
        
        
        func getProfile(){
            
            guard let userRecord = CloudKitManager.shared.userRecord else {
                alertItem = AlertContext.noUserRecord
                return
            }
            guard let profileReference = userRecord["userProfile"] as? CKRecord.Reference else { return }
            let profileRecordID = profileReference.recordID
            
            showLoadingView()
            CloudKitManager.shared.fetchRecord(with: profileRecordID) { result in
                
                DispatchQueue.main.async { [self] in
                    hideLoadingView()
                    switch result{
                    case .success(let record):
                        existingProfileRecord = record
                        let profile = DDGProfile(record: record)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        companyName = profile.companyName
                        bio = profile.bio
                        avatar = profile.avatarImage
                    case .failure(_):
                        //show alert
                        alertItem = AlertContext.unableToGetProfile
                        break
                    }
                    
                }
            }
            
        }
        
        private func updateProfile(){
            
            guard isValidProfile() else {
                alertItem = AlertContext.invalidProfile
                return
            }
            
            guard let profileRecord = existingProfileRecord else {
                alertItem = AlertContext.unableToGetProfile
                return
            }
            
            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kCompanyName] = companyName
            profileRecord[DDGProfile.kBio] = bio
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
            
            showLoadingView()
            CloudKitManager.shared.save(record: profileRecord) { result in
                
                DispatchQueue.main.async { [self] in
                    hideLoadingView()
                    
                    switch result{
                        
                    case .success(_):
                        alertItem = AlertContext.updateProfileSuccess
                    case .failure(_):
                        alertItem = AlertContext.updateProfileFailure
                        
                    }
                }
                
            }
            
        }
        
        private func createProfileRecord() -> CKRecord{
            let profileRecord = CKRecord(recordType: RecordType.profile)
            profileRecord[DDGProfile.kFirstName] = firstName
            profileRecord[DDGProfile.kLastName] = lastName
            profileRecord[DDGProfile.kCompanyName] = companyName
            profileRecord[DDGProfile.kBio] = bio
            profileRecord[DDGProfile.kAvatar] = avatar.convertToCKAsset()
            
            return profileRecord
        }
        
        private func showLoadingView(){ isLoading = true }
        private func hideLoadingView(){ isLoading = false }
    }
}
