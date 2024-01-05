//
//  BarWithUsers.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 05/01/2024.
//

import Foundation
import CoreLocation

struct BarWithUsers: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let capacity: String
    let type: String
    let description: String
    var usersInBar: [User]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, longitude, latitude, capacity, type, description, usersInBar = "users_in_bar"
    }

    enum IDKeys: String, CodingKey {
        case oid = "$oid"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idContainer = try container.nestedContainer(keyedBy: IDKeys.self, forKey: .id)
        id = try idContainer.decode(String.self, forKey: .oid)

        name = try container.decode(String.self, forKey: .name)
        
        let longitudeString = try container.decode(String.self, forKey: .longitude)
        let latitudeString = try container.decode(String.self, forKey: .latitude)
        guard let longitude = Double(longitudeString), let latitude = Double(latitudeString) else {
            throw DecodingError.dataCorruptedError(forKey: .longitude, in: container, debugDescription: "Longitude/Latitude values are not valid doubles.")
        }
        self.longitude = longitude
        self.latitude = latitude
        
        capacity = try container.decode(String.self, forKey: .capacity)
        type = try container.decode(String.self, forKey: .type)
        description = try container.decode(String.self, forKey: .description)
        usersInBar = try container.decode([User].self, forKey: .usersInBar)
    }
}

