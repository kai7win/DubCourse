//
//  CloudKitManager.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import CloudKit
import UIKit

final class CloudKitManager{
    
    static let shared = CloudKitManager()
    
    private init() {}
    
    var userRecord:CKRecord?
    var profileRecordID:CKRecord.ID?
    
    func getUserRecord(){
        CKContainer.default().fetchUserRecordID { recordID, error in
            guard let recordID = recordID,error == nil else {
                print("Debug:\(error!.localizedDescription)")
                return
            }
            
            CKContainer.default().publicCloudDatabase.fetch(withRecordID: recordID) { userRecord, error in
                guard let userRecord = userRecord,error == nil else {
                    print("Debug:\(error!.localizedDescription)")
                    return
                }
                self.userRecord = userRecord
                
                if let profileReference = userRecord["userProfile"] as? CKRecord.Reference{
                    self.profileRecordID = profileReference.recordID
                }
                
            }
        }
    }
    
    
    func getLocations(completed:@escaping(Result<[DDGLocation],Error>) -> Void){
        
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            
            guard let records = records, error == nil else {
                completed(.failure(error!))
                return
            }

            let locations = records.map(DDGLocation.init)
            completed(.success(locations))
            
        }
        
    }
    
    func getCheckedInProfiles(for locationID:CKRecord.ID,completed:@escaping (Result<[DDGProfile],Error>) -> Void){
        
        let reference = CKRecord.Reference(recordID: locationID, action: .none)
        let predicate = NSPredicate(format: "isCheckedIn == %@", reference)
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        
        CKContainer.default().publicCloudDatabase.perform(query,inZoneWith: nil) { records, error in
            guard let records = records,error == nil else {
                completed(.failure(error!))
                return
            }
            
            let profiles = records.map(DDGProfile.init)
            completed(.success(profiles))
        }
        
    }
    
    func getCheckedInProfilesDictionary(completed:@escaping (Result<[CKRecord.ID:[DDGProfile]],Error>) -> Void){
        print("✅ Network call fired off")
        
        let predicate = NSPredicate(format: "isCheckedNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query) 
//        operation.resultsLimit = 1
        
        var checkedInProfiles:[CKRecord.ID:[DDGProfile]] = [:]
        
        operation.recordFetchedBlock = { record in
            
            //Build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            checkedInProfiles[locationReference.recordID,default: []].append(profile)
            
        }
        operation.queryCompletionBlock = { cursor,error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            if let cursor = cursor{
                print("1️⃣ Inital cursor is not nil - \(cursor)")
                print("👨‍👩‍👧‍👦 Current dictionary - \(checkedInProfiles)")
                self.continueWithCheckinProfilesDict(cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result{
                    case .success(let profiles):
                        print("😀1️⃣ Initial Cursor Success - \(profiles)")
                        completed(.success(profiles))
                    case .failure(let error):
                        print("❌1️⃣ Initial cursor error - \(error)")
                        completed(.failure(error))
                    }
                }
            }else{
                completed(.success(checkedInProfiles))
            }
        }
        CKContainer.default().publicCloudDatabase.add(operation)
        
    }
    
    
    func continueWithCheckinProfilesDict(cursor:CKQueryOperation.Cursor,dictionary:[CKRecord.ID:[DDGProfile]],completed:@escaping (Result<[CKRecord.ID:[DDGProfile]],Error>) -> Void){
        
        var checkedInProfiles = dictionary
        let operation = CKQueryOperation(cursor: cursor)
//        operation.resultsLimit = 1
        
        operation.recordFetchedBlock = { record in
            //Build our dictionary
            let profile = DDGProfile(record: record)
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            checkedInProfiles[locationReference.recordID,default: []].append(profile)
        }
        operation.queryCompletionBlock = { cursor,error in
            
            if let cursor = cursor{
                print("⭕️ Recursive cursor is not nil - \(cursor)")
                print("👨‍👩‍👧‍👦 Current dictionary - \(checkedInProfiles)")
                self.continueWithCheckinProfilesDict(cursor: cursor, dictionary: checkedInProfiles) { result in
                    switch result{
                    case .success(let profiles):
                        print("😀⭕️ Recursive Success - \(profiles)")
                        completed(.success(profiles))
                    case .failure(let error):
                        print("❌⭕️ Recursive cursor error - \(error)")
                        completed(.failure(error))
                    }
                }
            }else{
                completed(.success(checkedInProfiles))
            }
            
        }
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func getCheckedInProfilesCount(completed:@escaping (Result<[CKRecord.ID:Int],Error>) -> Void){
        let predicate = NSPredicate(format: "isCheckedNilCheck == 1")
        let query = CKQuery(recordType: RecordType.profile, predicate: predicate)
        let operation = CKQueryOperation(query: query)
        operation.desiredKeys = [DDGProfile.kIsCheckedIn]
        
        var checkedInProfiles:[CKRecord.ID:Int] = [:]
        
        operation.recordFetchedBlock = { record in
            
            //Build our dictionary
            guard let locationReference = record[DDGProfile.kIsCheckedIn] as? CKRecord.Reference else { return }
            
            if let count = checkedInProfiles[locationReference.recordID]{
                checkedInProfiles[locationReference.recordID] = count + 1
            }else{
                checkedInProfiles[locationReference.recordID] = 1
            }
            
        }
        operation.queryCompletionBlock = { cursor,error in
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            
            //handle cussor in later video
            completed(.success(checkedInProfiles))
        }
        CKContainer.default().publicCloudDatabase.add(operation)
        
    }
    
    
    func batchSave(records:[CKRecord],completed:@escaping (Result<[CKRecord],Error>) -> Void){
        
        let operation = CKModifyRecordsOperation(recordsToSave:records)
        operation.modifyRecordsCompletionBlock = { savedRecords,_,error in
            guard let savedRecords = savedRecords,error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(savedRecords))
        }
        
        CKContainer.default().publicCloudDatabase.add(operation)
    }
    
    func save(record:CKRecord,completed:@escaping (Result<CKRecord,Error>) -> Void){
        CKContainer.default().publicCloudDatabase.save(record) { record, error in
            guard let record = record,error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(record))

        }
    }
    
    
    func fetchRecord(with id:CKRecord.ID,completed:@escaping (Result<CKRecord,Error>) -> Void){
        
        CKContainer.default().publicCloudDatabase.fetch(withRecordID: id) { record, error in
            guard let record = record, error == nil else {
                completed(.failure(error!))
                return
            }
            completed(.success(record))
        }
        
    }
    
}

