//
//  Navbar.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

// Variables
var API_URL: String = "http://127.0.0.1:5000"

struct NavBarView: View {   
    @State private var selectedTab = 0
    @State private var selectedBar: BarWithUsers? = nil
    @State private var selectedMapBar: BarWithUsers? = nil
    @State private var selectedUser: User? = nil
    
    @EnvironmentObject var globalUser: GlobalUser
    
    @State private var checkBoxItems: [CheckboxItem] = [
        CheckboxItem(id: 1, label: "Man", image: "mustache.fill", value: "m"),
        CheckboxItem(id: 2, label: "Woman", image: "mouth.fill", value: "w"),
        CheckboxItem(id: 3, label: "Neutral", image: "figure.child", value: "n")
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            if globalUser.userId != nil {
                UserEditView()
                    .tabItem {
                        Image(systemName: "person.crop.square")
                        Text("Profile")
                    }
                    .tag(0)
            } else {
                LoginView(items: $checkBoxItems)
                    .tabItem {
                        Image(systemName: "person.crop.square")
                        Text("Profile")
                    }
                    .tag(0)
            }
            
            
            BarsView(selectedBar: $selectedBar, selectedMapBar: $selectedMapBar, switchToMap: mapView, switchToUser: userView)
                .tabItem {
                    Image(systemName: "wineglass.fill")
                    Text("Bars")
                }
                .tag(1)
            
            MapView(selectedBar: $selectedMapBar, switchToBar: barView, switchToLogin: goToLogin)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)

            UsersView(selectedUser: $selectedUser, checkBoxItems: $checkBoxItems, selectedTab: $selectedTab, selectedBar: $selectedMapBar, switchToMap: mapView)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Users")
                }
                .tag(3)
        }.accentColor(Color("DarkBlue"))
    }
    
    private func goToLogin() {
        selectedTab = 0
    }
    
    private func barView(selectedBar: BarWithUsers) {
        self.selectedBar = selectedBar
        selectedTab = 1
    }
    
    private func mapView(selectedBar: BarWithUsers) {
        self.selectedMapBar = selectedBar
        selectedTab = 2
    }
    
    private func userView(selectedUser: User) {
        self.selectedUser = selectedUser
        selectedTab = 3
    }
}


#Preview {
    NavBarView()
}
