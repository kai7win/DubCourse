//
//  CKRecord+Ext.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import CloudKit

extension CKRecord{
    func convertToDDGLocation() -> DDGLocation{ return DDGLocation(record: self) }
    func convertToDDGProfile() -> DDGProfile { return DDGProfile(record: self) }
}
