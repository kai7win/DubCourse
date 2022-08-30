//
//  AppTabView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI

struct AppTabView: View {
    
    init() {
        let appearance = UITabBarAppearance()
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
    @StateObject private var viewModel = AppTabViewModel()
    
    var body: some View {
        TabView {
            
            LocationMapView()
                .tabItem {
                    Label("Map", systemImage: "map")
                }
            
            LocationListView()
                .tabItem {
                    Label("Locations", systemImage: "building")
                }
            
            NavigationView{
                ProfileView()
            }
            .tabItem {
                Label("Profile", systemImage: "person")
            }
            
        }
        .onAppear {
            CloudKitManager.shared.getUserRecord()
            viewModel.runStartupChecks()
        }
        .accentColor(.brandPrimary)
        .sheet(isPresented: $viewModel.isShowingOnboardView,onDismiss: viewModel.checkIfLocationServiceIsEnable){
            OnboardView(isShowingOnboardView: $viewModel.isShowingOnboardView)
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
