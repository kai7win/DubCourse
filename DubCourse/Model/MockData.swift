//
//  MockData.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import CloudKit

struct MockData{
    
    static var location:CKRecord{
        let record = CKRecord(recordType: RecordType.location)
        record[DDGLocation.kName] = "3345678 home"
        record[DDGLocation.kAddress] = "123 Main Street"
        record[DDGLocation.kDescription] = "This is a test Description,This is a test Description,This is a test Description,This is a test Description"
        record[DDGLocation.kWebsiteURL] = "https://google.com"
        record[DDGLocation.kLocation] = CLLocation(latitude: 37.331516, longitude: -121.891054)
        record[DDGLocation.kPhoneNumber] = "111-111-1111"
        return record
    }
}
