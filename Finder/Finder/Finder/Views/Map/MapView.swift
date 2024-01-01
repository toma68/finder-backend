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
    @State var selectedItem: Bar?
    @State var bars: [Bar]
    @State var user: User?
    @Binding var selectedTab: Int
    
    private func goToLogin() {
        selectedTab = 0 
    }
    
    

    var body: some View {
        MapContentView(items: bars, selectedItem: $selectedItem, user: $user, zoom: zoom, switchToLogin: goToLogin)
    }
}
