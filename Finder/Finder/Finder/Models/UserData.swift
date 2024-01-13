//
//  UserData.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation

struct UserData: Codable {
    var userId: String
    var surname: String
    var name: String
    var company: String
    var bio: String
    var photo: String

    enum CodingKeys: String, CodingKey {
        case userId = "user_id"
        case surname, name, company, bio, photo
    }

    init(userId: String, surname: String, name: String, company: String, bio: String, photo: String) {
        self.userId = userId
        self.surname = surname
        self.name = name
        self.company = company
        self.bio = bio
        self.photo = photo.isEmpty ? "https://finder.thomas-dev.com/finderLogo.png" : photo
    }
}
