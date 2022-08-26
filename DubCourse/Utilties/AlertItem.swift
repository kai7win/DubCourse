//
//  AlertItem.swift
//  DubCourse
//
//  Created by Kai Chi Tsao on 2022/8/22.
//

import SwiftUI

struct AlertItem:Identifiable{
    let id = UUID()
    let title: Text
    let message: Text
    let dismissButton: Alert.Button
}

struct AlertContext{
    
    // MARK: - MapView Errors
    
    static let unableToGetLocations = AlertItem(title: Text("Locations Error"), message: Text("Unable to retrieve locations at this time.\nPlease try again"), dismissButton: .default(Text("OK")))
    
    static let locationRestricted = AlertItem(title: Text("Locations Restricted"), message: Text("Your location is restricted"), dismissButton: .default(Text("OK")))
    
    static let locationDenied = AlertItem(title: Text("Locations Denied"), message: Text("Your location is Denied,To change that go to your Settings"), dismissButton: .default(Text("OK")))
    
    static let locationDisable = AlertItem(title: Text("Locations Disable"), message: Text("Your location is Disable,To change that go to your settings >> Privacy"), dismissButton: .default(Text("OK")))
    
    // MARK: - ProfileView Errors
    
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"), message: Text("All fields are required as well as a profile photo,Your bio must be < 100 characters.\nPlease try again"), dismissButton: .default(Text("OK")))
    
}
