//
//  LocationMapView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI
import MapKit

struct LocationMapView: View {
    
    @EnvironmentObject private var locationManager:LocationManager
    @StateObject private var viewModel = LocationMapViewModel()
    @Environment(\.sizeCategory) var sizeCategory
    
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
            .accentColor(.grubRed)
            .ignoresSafeArea()
            
                LogoView(frameWidth: 125).shadow(radius: 10)
            
        }
        .sheet(isPresented: $viewModel.isShowingDetailView, content: {
            NavigationView{
                viewModel.createLocationDetailView(for: locationManager.selectedLocation!, in: sizeCategory)
                    .toolbar {
                        Button("Dismiss") { viewModel.isShowingDetailView = false }
                    }
            }
            .accentColor(.brandPrimary)
        })
        
        .alert(item: $viewModel.alertItem, content: { $0.alert })
        
        .onAppear{
            
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


