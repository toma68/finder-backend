//
//  BarViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation
import SwiftUI

class BarViewModel: ObservableObject {
    @Published var selectedBar: BarWithUsers?
    @Published var users: [User] = []
    @Published var filteredUsers: [User] = []
    
    init(selectedBar: BarWithUsers?) {
        self.selectedBar = selectedBar
        self.users = selectedBar?.usersInBar ?? []
        self.filteredUsers = selectedBar?.usersInBar ?? []
    }

    func setBar(_ bar: BarWithUsers) {
        selectedBar = bar
        users = bar.usersInBar
        filteredUsers = bar.usersInBar
    }

    func filterUsers(with query: String) {
        if query.isEmpty {
            filteredUsers = users
        } else {
            filteredUsers = users.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }

    func backgroundColor(for gender: String) -> AnyView {
        switch gender {
        case "m":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        case "w":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color("Orange"), Color("Yellow")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        case "n":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        default:
            return AnyView(Color.gray)
        }
    }
}
