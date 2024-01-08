//
//  Navbar.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

var API_URL: String = "http://127.0.0.1:5000"

struct NavBarView: View {   
    @State private var selectedTab = 0
    @State private var selectedBar: BarWithUsers? = nil
    @State private var selectedMapBar: BarWithUsers? = nil
    @State private var selectedUser: User? = nil
    @State private var user: User? = nil
    
    @State private var checkBoxItems: [CheckboxItem] = [
        CheckboxItem(id: 1, label: "Man", image: "mustache.fill", value: "m"),
        CheckboxItem(id: 2, label: "Woman", image: "mouth.fill", value: "w"),
        CheckboxItem(id: 3, label: "Neutral", image: "figure.child", value: "n")
    ]

    var body: some View {
        TabView(selection: $selectedTab) {
            if user != nil {
                UserEditView(user: $user)
                    .tabItem {
                        Image(systemName: "person.crop.square")
                        Text("Profile")
                    }
                    .tag(0)
            } else {
                LoginView(user: $user, items: $checkBoxItems)
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
            
            MapView(switchToBar: barView, selectedItem: $selectedMapBar, user: $user, selectedTab: $selectedTab)
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
    
    private func barView(selectedBar: BarWithUsers) {
        selectedTab = 1
        self.selectedBar = selectedBar
    }
    
    private func mapView(selectedBar: BarWithUsers) {
        selectedTab = 2
        self.selectedMapBar = selectedBar
    }
    
    private func userView(selectedUser: User) {
        selectedTab = 3
        self.selectedUser = selectedUser
    }
}


#Preview {
    NavBarView()
}
