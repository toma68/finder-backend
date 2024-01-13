//
//  BarWithUsers.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 05/01/2024.
//

import Foundation
import CoreLocation

func subtractOneHour(from date: Date) -> Date {
    let calendar = Calendar.current
    return calendar.date(byAdding: .hour, value: -1, to: date) ?? date
}


struct BarWithUsers: Identifiable, Decodable, Equatable {
    let id: String
    let name: String
    let longitude: Double
    let latitude: Double
    let capacity: String
    let type: String
    let description: String
    let opening_hour: Date
    let closing_hour: Date
    let average_price: Int
    let payment_method: [String]
    let address: String
    let postal_code: String
    let town: String
    let phone: String
    var usersInBar: [User]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, longitude, latitude, capacity, type, description, opening_hour, closing_hour, average_price, payment_method, address, postal_code, town, phone, usersInBar = "users_in_bar"
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
        
        let openingHourWrapper = try container.decode(DateWrapper.self, forKey: .opening_hour)
        opening_hour = subtractOneHour(from: openingHourWrapper.date)
        
        let closingHourWrapper = try container.decode(DateWrapper.self, forKey: .closing_hour)
        closing_hour = subtractOneHour(from: closingHourWrapper.date)
        
        average_price = try Int(container.decode(String.self, forKey: .average_price)) ?? 0
        payment_method = try container.decode([String].self, forKey: .payment_method)
        address = try container.decode(String.self, forKey: .address)
        postal_code = try container.decode(String.self, forKey: .postal_code)
        town = try container.decode(String.self, forKey: .town)
        phone = try container.decode(String.self, forKey: .phone)
        usersInBar = try container.decode([User].self, forKey: .usersInBar)
    }
}

