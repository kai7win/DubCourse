//
//  ProfileViewModel.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/26.
//

import CloudKit

final class ProfileViewModel:ObservableObject{
    
    @Published var firstName = ""
    @Published var lastName = ""
    @Published var companyName = ""
    @Published var bio = ""
    @Published var avatar = PlaceholderImage.avatar
    @Published var isShowingPhotoPicker = false
    @Published var alertItem:AlertItem?
    
    func isValidProfile() -> Bool{
        
        guard !firstName.isEmpty,
              !lastName.isEmpty,
              !companyName.isEmpty,
              !bio.isEmpty,
              avatar != PlaceholderImage.avatar,
              bio.count < 100 else { return false }
        
        return true
    }
    
    func createProfile(){
        guard isValidProfile() else {
            //show Alert
            alertItem = AlertContext.invalidProfile
            return
        }
        
        //Create our profile send it up to Cloudkit
        //1.Create our CKRecord from the ProfileView
        let profileRecord = createProfileRecord()
        
        //2.Get our UserRecordID from the Container
        CKContainer.default().fetchUserRecordID { recordID, error in
            
            guard let recordID = recordID,error == nil else {
                print("Debug:\(error!.localizedDescription)")
                return
            }

            //3.Get UserRecord from the Public Database
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord,error == nil else {
                    print("Debug:\(error!.localizedDescription)")
                    return
                }
                
                //4.Create reference on UserRecord to the DDGProfile we created
                userRecord["userProfile"] = CKRecord.Reference(recordID: profileRecord.recordID, action: .none)
                
                //5.Create a CKOperation to save our User and Profile Records
                
                let operation = CKModifyRecordsOperation(recordsToSave: [userRecord,profileRecord])
                operation.modifyRecordsCompletionBlock = { savedRecords,_,error in
                    
                    guard let savedRecords = savedRecords,error == nil else {
                        print("Debug: \(error!.localizedDescription)")
                        return
                    }
                    
                    print(savedRecords)
                }
                
                CKContainer.default().publicCloudDatabase.add(operation)
            }
        }
        
    }
    
    
    func getProfile(){
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID, error == nil else {
                print("Debug:\(error!.localizedDescription)")
                return
            }
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord, error == nil else {
                    print("Debug:\(error!.localizedDescription)")
                    return
                }
                
                let profileReference = userRecord["userProfile"] as! CKRecord.Reference
                let profileRecordID = profileReference.recordID
                
                CKContainer.default().publicCloudDatabase.fetch(withRecordID: profileRecordID) { profileRecord, error in
                    guard let profileRecord = profileRecord, error == nil else {
                        print("Debug:\(error!.localizedDescription)")
                        return
                    }
                    
                    DispatchQueue.main.async { [self] in
                        let profile = DDGProfile(record: profileRecord)
                        firstName = profile.firstName
                        lastName = profile.lastName
                        companyName = profile.companyName
                        bio = profile.bio
                        avatar = profile.createAvatarImage()
                    }
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
    
    
}
