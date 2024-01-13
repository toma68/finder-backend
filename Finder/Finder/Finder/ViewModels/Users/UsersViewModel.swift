//
//  UsersViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation
import SwiftUI

class UsersViewModel: ObservableObject {
    private var userService: UserService = UserService()
    @Published var users: [User] = []
    @Published var filteredUsers: [User] = []
    @Published var searchText: String = ""
    private var genderFilter: String? = nil

    func fetchUsers() {
        userService.fetchUsers { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let users):
                    self?.users = users
                    self?.filteredUsers = users
                case .failure(let error):
                    print("Error fetching users: \(error.localizedDescription)")
                    self?.users = []
                    self?.filteredUsers = []
                }
            }
        }
    }
    
    func setGenderFilter(_ gender: String?) {
            genderFilter = gender
            filterUsers()
        }

    func filterUsers() {
        if searchText.isEmpty && genderFilter == nil {
            filteredUsers = users
        } else {
            filteredUsers = users.filter {
                ($0.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty) &&
                (genderFilter == nil || $0.gender == genderFilter)
            }
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
    
    func gradientColor(for gender: String) -> LinearGradient {
        switch gender {
        case "m":
            return LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "w":
            return LinearGradient(gradient: Gradient(colors: [Color("Orange"), Color("Yellow")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "n":
            return LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
}
