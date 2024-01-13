//
//  MapContentViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation
import MapKit
import SwiftUI

class MapContentViewModel: ObservableObject {
    private var mapService: MapService = MapService()
    @Published var region: MKCoordinateRegion
    private var items: [BarWithUsers]
    private var zoom: Double

    init(items: [BarWithUsers], zoom: Double) {
        self.items = items
        self.zoom = zoom
        self.region = mapService.calculateRegion(for: items)
    }

    func centerMapOnLocation(location: BarWithUsers) {
        let coordinate = CLLocationCoordinate2D(latitude: location.latitude - 0.001, longitude: location.longitude)
        let newRegion = MKCoordinateRegion(center: coordinate, span: MKCoordinateSpan(latitudeDelta: zoom, longitudeDelta: zoom))
        DispatchQueue.main.async {
            withAnimation(.easeInOut(duration: 1.0)) {
                self.region = newRegion
            }
        }
    }

    var mapAnnotations: [BarWithUsers] {
        return items
    }
}
