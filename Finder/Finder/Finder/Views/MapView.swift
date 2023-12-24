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

var zoom : Double = 0.005

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


struct Bar: Identifiable {
    let id = UUID()
    let name: String
    let longitude: Double
    let latitude: Double
    let capacity: String
    let type: String
    let description: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
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

    var body: some View {
        HStack {
            Text(item.name)
            
            Spacer()
            
            Button(action: onExit) {
                Image(systemName: "xmark.circle.fill")
                    .foregroundColor(Color("DarkBlue"))
            }
            
            // Add more details about the location here
        }
        .padding()
        .frame(width: 300)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Orange"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}


struct MapContent: View {
    var items: [Bar]
    @Binding var selectedItem: Bar?
    @State private var region: MKCoordinateRegion

    init(items: [Bar], selectedItem: Binding<Bar?>) {
        self.items = items
        self._selectedItem = selectedItem
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
                    LocationDetailView(item: selectedItem) {
                        self.selectedItem = nil  // Deselect item
                    }
                }
            }.offset(y: -25),
            alignment: .bottom
            
        )
    }
}


struct MapView: View {
    @State private var selectedItem: Bar?
    
    // Example data
    let items = [
        Bar(name: "Coquetel-Bar",
            longitude: 6.86235398027921,
            latitude: 47.63931306388334,
            capacity: "35",
            type: "bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(name: "Mandala - Café & bar",
            longitude: 6.862761676004622,
            latitude: 47.639323907444904,
            capacity: "30",
            type: "café bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(name: "Le bar à vins du Lion",
            longitude: 6.863298117748583,
            latitude: 47.63901667232958,
            capacity: "40",
            type: "bar à vins",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(name: "L'Estaminet",
            longitude: 6.8624237177059255,
            latitude: 47.63865521693967,
            capacity: "45",
            type: "bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque."),

        Bar(name: "Café bar les Marronniers",
            longitude: 6.8625739214845325,
            latitude: 47.63821062337903,
            capacity: "50",
            type: "café bar",
            description: "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Nulla quam velit, vulputate eu pharetra nec, mattis ac neque.")
    ]

    var body: some View {
        MapContent(items: items, selectedItem: $selectedItem)
    }
}

#Preview {
    return MapView()
}
