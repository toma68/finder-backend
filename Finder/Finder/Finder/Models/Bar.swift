//
//  Bar.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 30/12/2023.
//

import Foundation
import CoreLocation

struct Bar: Identifiable, Equatable {
    var id: String
    var name: String
    var longitude: Double
    var latitude: Double
    var capacity: String
    var type: String
    var description: String

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
