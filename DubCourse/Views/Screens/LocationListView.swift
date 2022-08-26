//
//  LocationListView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI

struct LocationListView: View {
    
    @EnvironmentObject private var locationManager:LocationManager
    
    var body: some View {
        NavigationView {
            
            List {
                ForEach(locationManager.locations) { location in
                    
                    NavigationLink(destination: LocationDetailView(location: location) ){
                        
                        LocationCell(location: location)
                    }
                }
            }
            .listStyle(.plain)
            .navigationTitle("Grab Spots")
        }
    }
}

struct LocationListView_Previews: PreviewProvider {
    static var previews: some View {
        LocationListView()
    }
}


