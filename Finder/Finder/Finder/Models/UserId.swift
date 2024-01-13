//
//  UserId.swift
//  Finder
//
//  Created by Hopy on 11/01/2024.
//

import Foundation

struct UserId: Identifiable, Decodable, Equatable {
    var id: String

    enum CodingKeys: String, CodingKey {
        case id = "_id"
    }

    enum IDKeys: String, CodingKey {
        case oid = "$oid"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idContainer = try container.nestedContainer(keyedBy: IDKeys.self, forKey: .id)
        id = try idContainer.decode(String.self, forKey: .oid)
    }
    
    init(id: String) {
        self.id = id
    }
}
