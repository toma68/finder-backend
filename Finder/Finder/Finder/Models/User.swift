//
//  User.swift
//  Finder
//
//  Created by Hopy on 30/12/2023.
//

import Foundation

struct User: Identifiable {
    var id: String
    var name: String
    var surname: String
    var company: String
    var bio: String
    var photo: URL
    var gender: String
    var barId: String?

//    init(id: String, name: String, surname: String, company: String, bio: String, photo: URL, gender: String, barId: String?) {
//        self.id = id
//        self.name = name
//        self.surname = surname
//        self.company = company
//        self.bio = bio
//        self.photo = photo
//        self.gender = gender
//        self.barId = barId
//    }
}
