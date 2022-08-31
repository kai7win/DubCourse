//
//  LocationMapView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import CoreLocationUI
import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager:LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    @Environment(\.dynamicTypeSize) var dynamicTypeSize
    
    var body: some View {
        
        ZStack(alignment:.top){
            Map(coordinateRegion: $viewModel.region,showsUserLocation: true,annotationItems: locationManager.locations) { location in
                MapAnnotation(coordinate: location.location.coordinate,anchorPoint: CGPoint(x: 0.5, y: 0.75)) {
                    DDGAnnotation(location: location, number: viewModel.checkedInProfiles[location.id,default: 0])
                        
                        .onTapGesture {
                            locationManager.selectedLocation = location
                            viewModel.isShowingDetailView = true
                        }
                }
            }
            .tint(.grubRed)
            .ignoresSafeArea()
            
            LogoView(frameWidth: 125).shadow(radius: 10)
            
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, content: {
            NavigationView{
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: dynamicTypeSize)
                    .toolbar {
                        Button("Dismiss") { viewModel.isShowingDetailView = false }
                    }
            }
        })
        
        .overlay(alignment: .bottomLeading){
            LocationButton(.currentLocation) {
                viewModel.requestAllowOnceLocationPermission()
                
            }
            .foregroundColor(.white)
            .symbolVariant(.fill)
            .tint(.grubRed)
            .labelStyle(.iconOnly)
            .clipShape(Circle())
            .padding(EdgeInsets(top: 0, leading: 20, bottom: 40, trailing: 0))
        }
        
        
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        
        .task{
            
            if locationManager.locations.isEmpty{
                viewModel.getLocations(for: locationManager)
            }
            viewModel.getCheckedInCounts()
        }
        
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView().environmentObject(LocationManager())
    }
}


