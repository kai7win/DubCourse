//
//  CloudKitManager.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import CloudKit

struct CloudKitManager{
    
    static func getLocations(completed:@escaping(Result<[DDGLocation],Error>) -> Void){
        
        let sortDescriptor = NSSortDescriptor(key: DDGLocation.kName, ascending: true)
        let query = CKQuery(recordType: RecordType.location, predicate: NSPredicate(value: true))
        query.sortDescriptors = [sortDescriptor]
        
        CKContainer.default().publicCloudDatabase.perform(query, inZoneWith: nil) { records, error in
            
            guard error == nil else {
                completed(.failure(error!))
                return
            }
            guard let records = records else { return }
            
//            var locations = [DDGLocation]()
//
//            for record in records {
//                let loaction = DDGLocation(record: record)
//                locations.append(loaction)
//            }
            
            let locations = records.map { $0.convertToDDGLocation() }
            
            completed(.success(locations))
            
        }
        

        
        
        
    }
    
}

