//
//  Navbar.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

struct NavBarView: View {   
    var body: some View {
        TabView {
            LoginView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Profile")
                }
            
            Tab2View()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Bars")
                }
            
            MapView()
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }

            Tab4View()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Users")
                }
        }.accentColor(Color("DarkBlue"))
    }
}

struct Tab2View: View {
    var body: some View {
        Text("Bar view")
    }
}

struct Tab4View: View {
    var body: some View {
        Text("Users View")
    }
}
#Preview {
    NavBarView()
}
