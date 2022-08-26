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
    
    var body: some View {
        
        ZStack {
            Map(coordinateRegion: $viewModel.region,showsUserLocation: true,annotationItems: locationManager.locations) { location in
                MapPin(coordinate: location.location.coordinate, tint: .brandPrimary)
            }
            .accentColor(.grubRed)
            .ignoresSafeArea()
            
            VStack {
                LogoView(frameWidth: 125)
                    .shadow(radius: 10)
                Spacer()
            }
        }
        .sheet(isPresented: $viewModel.isShowingOnboardView,onDismiss: viewModel.checkIfLocationServiceIsEnable){
            OnboardView(isShowingOnboardView: $viewModel.isShowingOnboardView)
        }
        
        
        .alert(item: $viewModel.alertItem, content: { alertItem in
            Alert(title: alertItem.title, message: alertItem.message, dismissButton: alertItem.dismissButton)
        })
        
        .onAppear{
            viewModel.runStartupChecks()
            
            if locationManager.locations.isEmpty{
                viewModel.getLocations(for: locationManager)
            }
        }
        
    }
}

struct LocationMapView_Previews: PreviewProvider {
    static var previews: some View {
        LocationMapView()
    }
}


