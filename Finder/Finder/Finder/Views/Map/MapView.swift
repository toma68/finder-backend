//
//  MapView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/24/23.
//

import MapKit
import SwiftUI

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
        MapContentView(items: items, selectedItem: $selectedItem, user: $user, zoom: zoom)
    }
}

#Preview {
    return MapView()
}
