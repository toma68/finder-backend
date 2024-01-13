//
//  GlobalUser.swift
//  Finder
//
//  Created by Hopy on 11/01/2024.
//

import Foundation

class GlobalUser: ObservableObject {
    @Published var userId: UserId?

    init(userId: UserId? = nil) {
        self.userId = userId
    }
}
