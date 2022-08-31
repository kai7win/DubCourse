//
//  AppTabView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI

struct AppTabView: View {
    
//    init() {
//        let appearance = UITabBarAppearance()
//        UITabBar.appearance().scrollEdgeAppearance = appearance
//    }
    
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
        .task {
            try? await CloudKitManager.shared.getUserRecord()
            viewModel.checkIfHasSeenOnboard()
        }
        .sheet(isPresented: $viewModel.isShowingOnboardView){
            OnboardView()
        }
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
