//
//  Navbar.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

struct NavBarView: View {   
    @State private var selectedTab = 0
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
            
            
            BarsView()
                .tabItem {
                    Image(systemName: "wineglass.fill")
                    Text("Bars")
                }
                .tag(1)
            
            MapView(user: $user, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)

            UsersView(checkBoxItems: $checkBoxItems)
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Users")
                }
                .tag(3)
        }.accentColor(Color("DarkBlue"))
    }
}


#Preview {
    NavBarView()
}
