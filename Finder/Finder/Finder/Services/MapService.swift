//
//  MapService.swift
//  Finder
//
//  Created by Hopy on 12/01/2024.
//

import Foundation
import CoreLocation
import MapKit

class MapService {
    // Function to calculate region
    func calculateRegion(for items: [BarWithUsers]) -> MKCoordinateRegion {
        let zoom : Double = 0.005
    
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
}
