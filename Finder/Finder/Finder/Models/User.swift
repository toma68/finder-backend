//
//  User.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 30/12/2023.
//

import Foundation

//struct User: Identifiable {
//    var id: String
//    var name: String
//    var surname: String
//    var company: String
//    var bio: String
//    var photo: URL
//    var gender: String
//    var barId: String?
//}

struct User: Identifiable, Decodable {
    var id: String
    var name: String
    var surname: String
    var company: String
    var bio: String
    var photo: URL
    var gender: String
    var barId: String?

    enum CodingKeys: String, CodingKey {
        case id = "_id"
        case name, surname, company, bio, photo, gender, barId = "bar_id"
    }

    enum IDKeys: String, CodingKey {
        case oid = "$oid"
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let idContainer = try container.nestedContainer(keyedBy: IDKeys.self, forKey: .id)
        id = try idContainer.decode(String.self, forKey: .oid)
        
        name = try container.decode(String.self, forKey: .name)
        surname = try container.decode(String.self, forKey: .surname)
        company = try container.decode(String.self, forKey: .company)
        bio = try container.decode(String.self, forKey: .bio)
        photo = try container.decode(URL.self, forKey: .photo)
        gender = try container.decode(String.self, forKey: .gender)

        if let barIdContainer = try? container.nestedContainer(keyedBy: IDKeys.self, forKey: .barId) {
            barId = try barIdContainer.decode(String.self, forKey: .oid)
        } else {
            barId = nil // For cases where bar_id is null
        }
    }
}
