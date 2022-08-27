//
//  AppTabView.swift
//  DubDubGrubCourse
//
//  Created by Kai Chi Tsao on 2022/8/21.
//

import SwiftUI

struct AppTabView: View {
    
    let appearance = UITabBarAppearance()
    
    init() {
        UITabBar.appearance().scrollEdgeAppearance = appearance
    }
    
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
        .onAppear { CloudKitManager.shared.getUserRecord() }
        .accentColor(.brandPrimary)
    }
}

struct AppTabView_Previews: PreviewProvider {
    static var previews: some View {
        AppTabView()
    }
}
