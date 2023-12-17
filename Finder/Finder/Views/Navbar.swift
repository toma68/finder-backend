//
//  Navbar.swift
//  Finder
//
//  Created by user234363 on 12/17/23.
//

import SwiftUI

struct NavBar: View {   
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
            
            Tab3View()
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

struct Tab3View: View {
    var body: some View {
        Text("Map View")
    }
}

struct Tab4View: View {
    var body: some View {
        Text("Users View")
    }
}
#Preview {
    NavBar()
}
