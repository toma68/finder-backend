//
//  Navbar.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

struct NavBarView: View {   
    @State private var selectedTab = 0
    
    @State private var bars = [
        Bar(
            id: "657ed495dc43be55442b8538",
            name: "Coquetel-Bar",
            longitude: 6.86235398027921,
            latitude: 47.63931306388334,
            capacity: "35",
            type: "bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(
            id: "657ed495dc43be55442b8539",
            name: "Mandala - Café & bar",
            longitude: 6.862761676004622,
            latitude: 47.639323907444904,
            capacity: "30",
            type: "café bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(
            id: "657ed495dc43be55442b853a",
            name: "Le bar à vins du Lion",
            longitude: 6.863298117748583,
            latitude: 47.63901667232958,
            capacity: "40",
            type: "bar à vins",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(
            id: "657ed495dc43be55442b853b",
            name: "L'Estaminet",
            longitude: 6.8624237177059255,
            latitude: 47.63865521693967,
            capacity: "45",
            type: "bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(
            id: "657ed495dc43be55442b853c",
            name: "Café bar les Marronniers",
            longitude: 6.8625739214845325,
            latitude: 47.63821062337903,
            capacity: "50",
            type: "café bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque.")
    ]
    
    @State private var user: User? = User(
            id: "657ecff0151500481a95d0ed",
            name: "Kayla",
            surname: "Ramos",
            company: "Irwin-Long",
            bio: "Almost goal speak his institution late magazine.",
            photo: URL(string: "https://img.freepik.com/photos-premium/bateau-lac-montagnes-arriere-plan_865967-5725.jpg")!,
            gender: "m",
            barId: "657ed495dc43be55442b8538"
        )
//    @State private var user: User? = User(
//            id: "657ecff0151500481a95d0ed",
//            name: "Kayla",
//            surname: "Ramos",
//            company: "Irwin-Long",
//            bio: "Almost goal speak his institution late magazine.",
//            photo: URL(string: "https://placekitten.com/33/616")!,
//            gender: "m",
//            barId: nil
//        )
//    @State private var user: User? = nil
    
    var body: some View {
        TabView(selection: $selectedTab) {
            LoginView()
                .tabItem {
                    Image(systemName: "person.crop.square")
                    Text("Profile")
                }
                .tag(0)
            
            BarsView(bars: bars)
                .tabItem {
                    Image(systemName: "wineglass.fill")
                    Text("Bars")
                }
                .tag(1)
            
            MapView(bars: bars, user: user, selectedTab: $selectedTab)
                .tabItem {
                    Image(systemName: "map")
                    Text("Map")
                }
                .tag(2)

            Tab4View()
                .tabItem {
                    Image(systemName: "person.3")
                    Text("Users")
                }
                .tag(3)
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
