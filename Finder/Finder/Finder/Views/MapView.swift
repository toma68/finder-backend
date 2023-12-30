//
//  MapView.swift
//  Finder
//
//  Created by user234363 on 12/24/23.
//

import SwiftUI
import MapKit
import Foundation
import CoreLocation

private var zoom : Double = 0.005

func calculateRegion(for items: [Bar]) -> MKCoordinateRegion {
    let latitudes = items.map { $0.coordinate.latitude }
    let longitudes = items.map { $0.coordinate.longitude }

    let maxLat = latitudes.max() ?? 0
    let minLat = latitudes.min() ?? 0
    let maxLong = longitudes.max() ?? 0
    let minLong = longitudes.min() ?? 0

    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLong + maxLong) / 2
    )

    let span = MKCoordinateSpan(
        latitudeDelta: max(maxLat - minLat, zoom) * 1.2, // 20% extra for padding
        longitudeDelta: max(maxLong - minLong, zoom) * 1.2 // 20% extra for padding
    )

    return MKCoordinateRegion(center: center, span: span)
}


struct MarkerView: View {
    var item: Bar
    var onTap: () -> Void

    var body: some View {
        Image(systemName: "mappin.circle.fill")
            .foregroundColor(.red)
            .onTapGesture {
                onTap()
            }
    }
}


struct LocationDetailView: View {
    var item: Bar
    var onExit: () -> Void
    
    @Binding var user: User?

    var body: some View {
        VStack {
            HStack {
                Text(item.name)
                
                Spacer()
                
                Button(action: onExit) {
                    Image(systemName: "xmark.circle.fill")
                        .foregroundColor(Color("DarkBlue"))
                }
                
            }.padding(5)
            
            HStack {
                Image(systemName: "person.3")
                Text(":")
                
                Spacer()
                
                Text("0" + " / " + item.capacity)
            }.padding(5)
            
            HStack {
                Text(item.description)
            }.padding(5)
            
            HStack {
                if user != nil {
                    if user?.barId == item.id {
                        Button(action: {
                            leaveBar(item: item)
                        }) {
                            Image(systemName: "figure.walk.departure")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .padding(12)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("Orange"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    } else {
                        Button(action: {
                            enterBar(item: item)
                        }) {
                            Image(systemName: "figure.walk.arrival")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 35, height: 35)
                                .padding(12)
                        }
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                        .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                }
                else {
                    NavigationLink(destination: SignupView()) {
                        Image(systemName: "person.crop.circle.badge.plus")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 35, height: 35)
                            .padding(12)
                    }
                    .frame(maxWidth: .infinity)
                    .background(Color("LightBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }
            .padding(5)
        }
        .padding()
        .frame(width: 300)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Orange"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    private func enterBar(item: Bar) {
        user?.barId = item.id
    }

    private func leaveBar(item: Bar) {
        user?.barId = nil
    }
}


struct MapContent: View {
    var items: [Bar]
    @Binding var selectedItem: Bar?
    @Binding var user: User?
    @State private var region: MKCoordinateRegion

    init(items: [Bar], selectedItem: Binding<Bar?>, user: Binding<User?>) {
            self.items = items
            self._selectedItem = selectedItem
            self._user = user
            self._region = State(initialValue: calculateRegion(for: items))
    }

    private func centerMapOnLocation(location: Bar) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude, longitude: location.longitude)
        region = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: items) { item in
            MapAnnotation(coordinate: item.coordinate) {
                MarkerView(item: item) {
                    selectedItem = item
                    centerMapOnLocation(location: item)
                }
            }
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .overlay(
            Group {
                if let selectedItem = selectedItem {
                    LocationDetailView(item: selectedItem, onExit: { self.selectedItem = nil }, user: $user)
                }
            }.offset(y: -25),
            alignment: .bottom
            
        )
    }
}


struct MapView: View {
    @State private var selectedItem: Bar?
    
    // Example data
    @State private var user: User? = User(
            id: "657ecff0151500481a95d0ed",
            name: "Kayla",
            surname: "Ramos",
            company: "Irwin-Long",
            bio: "Almost goal speak his institution late magazine.",
            photo: URL(string: "https://placekitten.com/33/616")!,
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
    
    let items = [
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

    var body: some View {
        MapContent(items: items, selectedItem: $selectedItem, user: $user)
    }
}

#Preview {
    return MapView()
}
