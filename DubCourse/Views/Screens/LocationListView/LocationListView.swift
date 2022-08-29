//
//  LocationListView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager:LocationManager
    
    @StateObject private var viewModel = LocationListViewModel()
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(locationManager.locations) { location in
                    
                    NavigationLink(destination:
                                    LocationDetailView(viewModel: LocationDetailViewModel(location: location))
                    ){
                        
                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id,default: []])
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Grab Spots")
            .onAppear { viewModel.getCheckInProfilesDictionary() }
            
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}


