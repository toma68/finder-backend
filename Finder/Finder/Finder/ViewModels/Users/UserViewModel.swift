//
//  UserViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation
import SwiftUI

class UserViewModel: ObservableObject {
    private var userService: UserService = UserService()
    @Published var barData: BarWithUsers?

    func fetchBarData(user: User) {
        guard let userId = user.barId else { return }

        userService.fetchBarData(forUserId: userId) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let barData):
                    self?.barData = barData
                case .failure(let error):
                    print("Error fetching bar data: \(error.localizedDescription)")
                }
            }
        }
    }
}
