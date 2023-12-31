//
//  MapContentView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import MapKit
import SwiftUI

struct MapContentView: View {
    var switchToBar: (BarWithUsers) -> Void
    private var items: [BarWithUsers]
    var switchToLogin: () -> Void
    @Binding private var selectedItem: BarWithUsers?
    @Binding private var user: User?
    @State private var region: MKCoordinateRegion
    private var zoom : Double

    init(switchToBar: @escaping (BarWithUsers) -> Void, items: [BarWithUsers], selectedItem: Binding<BarWithUsers?>, user: Binding<User?>, zoom: Double, switchToLogin: @escaping () -> Void) {
        self.switchToBar = switchToBar
        self.items = items
        self._selectedItem = selectedItem
        self._user = user
        self.zoom = zoom
        self.switchToLogin = switchToLogin
        self._region = State(initialValue: calculateRegion(for: items))
    }

    private func centerMapOnLocation(location: BarWithUsers) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude - 0.001, longitude: location.longitude)
        let newRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        
        withAnimation(.easeInOut(duration: 1.0)) {
            self.region = newRegion
        }
    }

    var body: some View {
        Map(coordinateRegion: $region, annotationItems: items) { item in
            MapAnnotation(coordinate: item.coordinate) {
                MarkerView(item: item, selectedItem: $selectedItem) {
                    selectedItem = item
                    centerMapOnLocation(location: item)
                }
            }
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .overlay(
            Group {
                if let selectedItem = selectedItem {
                    Button(action: {
                        switchToBar(selectedItem)
                    }) {
                        LocationDetailView(item: selectedItem, onExit: { self.selectedItem = nil }, switchToLogin: switchToLogin, user: $user)
                    }
                }
            }.offset(y: -25),
            alignment: .bottom
            
        )
    }
}
