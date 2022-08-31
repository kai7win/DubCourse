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
    @Environment(\.dynamicTypeSize) var dynamicTypeSize

    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(locationManager.locations) { location in
                    NavigationLink(destination:
                    viewModel.createLocationDetailView(for: location, in: dynamicTypeSize)
                    ){
                        LocationCell(location: location, profiles: viewModel.checkedInProfiles[location.id,default: []])
                            .accessibilityElement(children: .ignore)
                            .accessibilityLabel(viewModel.createVoiceOverSummary(for: location))
                    }
                }
                
            }
            .listStyle(.plain)
            .navigationTitle("Grab Spots")
            .onAppear { viewModel.getCheckInProfilesDictionary() }
            .alert(item: $viewModel.alertItem) { $0.alert }
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}


