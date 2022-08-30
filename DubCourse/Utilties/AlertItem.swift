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
    
    var alert:Alert{
        Alert(title: title, message: message, dismissButton: dismissButton)
    }
}

struct AlertContext{
    
    // MARK: - MapView Errors
    
    static let unableToGetLocations = AlertItem(title: Text("Locations Error"), message: Text("Unable to retrieve locations at this time.\nPlease try again"), dismissButton: .default(Text("OK")))
    
    static let locationRestricted = AlertItem(title: Text("Locations Restricted"), message: Text("Your location is restricted"), dismissButton: .default(Text("OK")))
    
    static let locationDenied = AlertItem(title: Text("Locations Denied"), message: Text("Your location is Denied,To change that go to your Settings"), dismissButton: .default(Text("OK")))
    
    static let locationDisable = AlertItem(title: Text("Locations Disable"), message: Text("Your location is Disable,To change that go to your settings >> Privacy"), dismissButton: .default(Text("OK")))
    
    static let checkInCount = AlertItem(title: Text("Server Error"), message: Text("Unable to get the number of people checked into each location.please check your internet connection and try again."), dismissButton: .default(Text("OK")))
    
    // MARK: - LocationListView Errors
    
    static let unableToGetAllCheckInProfiels = AlertItem(title: Text("Server Error"), message: Text("We are unable to get user checked into this location at this time.\nPlease try again"), dismissButton: .default(Text("OK")))
    
    
    // MARK: - ProfileView Errors
    
    static let invalidProfile = AlertItem(title: Text("Invalid Profile"), message: Text("All fields are required as well as a profile photo,Your bio must be < 100 characters.\nPlease try again"), dismissButton: .default(Text("OK")))
    
    static let noUserRecord = AlertItem(title: Text("No User Record"), message: Text("You must log into iCloud on your phone in order to utilize DubGrubs profile.Please log in your phone's settings screen"), dismissButton: .default(Text("OK")))
    
    static let createProfileSuccess = AlertItem(title: Text("Profile Created Successfully"), message: Text("Your profile has successfully been created"), dismissButton: .default(Text("OK")))
    
    static let createProfileFailure = AlertItem(title: Text("Failed to Create Profile"), message: Text("We were unable to create your profile at this time.\nPlease try again later or contact customer support if this persists"), dismissButton: .default(Text("OK")))
    
    static let unableToGetProfile = AlertItem(title: Text("Unable to Retrieve Profile"), message: Text("We were unable to retrieve your profile at this time.\nPlease check your internet connection and try again later or contact customer support if this persists"), dismissButton: .default(Text("OK")))
    
    static let updateProfileSuccess = AlertItem(title: Text("Profile Update Success!"), message: Text("Yor DubDub Grub profile was updated Success"), dismissButton: .default(Text("Sweet!")))
    
    static let updateProfileFailure = AlertItem(title: Text("Profile Update Failed!"), message: Text("We were unable to update your profile at this time \nPlease try again later."), dismissButton: .default(Text("OK")))
    
    
    // MARK: - LocationDetailView Errors
    
    static let invalidPhoneNumber = AlertItem(title: Text("Invalid Phone Number"), message: Text("The phone number for the location is invalid"), dismissButton: .default(Text("OK")))
    
    static let unableToGetCheckInStatus = AlertItem(title: Text("Server Error"), message: Text("Unable to retrieve checked in status of the current user. \nPlease try again"), dismissButton: .default(Text("OK")))
    
    static let unableToCheckInOrOut = AlertItem(title: Text("Server Error"), message: Text("We are unable to check in/out at this time. \nPlease try again"), dismissButton: .default(Text("OK")))
    
    static let unableToGetCheckInProfiels = AlertItem(title: Text("Server Error"), message: Text("We are unable to get user checked into this location at this time.\nPlease try again"), dismissButton: .default(Text("OK")))
    
}
