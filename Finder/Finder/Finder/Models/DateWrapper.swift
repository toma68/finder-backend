//
//  DateWrapper.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 13/01/2024.
//

import Foundation

struct DateWrapper: Decodable {
    let date: Date

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let dateString = try container.decode(String.self, forKey: .date)
        if let date = ISO8601DateFormatter().date(from: dateString) {
            self.date = date
        } else {
            throw DecodingError.dataCorruptedError(forKey: .date, in: container, debugDescription: "Date string does not match ISO 8601 format.")
        }
    }

    enum CodingKeys: String, CodingKey {
        case date = "$date"
    }
}

