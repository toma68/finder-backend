//
//  LocationDetailViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation

class LocationDetailViewModel: ObservableObject {
    private var userService: UserService = UserService()

    func enterBar(globalUser: GlobalUser?, item: BarWithUsers, completion: @escaping () -> Void) {
        guard globalUser != nil, let userId = globalUser!.userId?.id else { return }
        userService.updateUserBarId(userId: userId, barId: item.id) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Successfully updated")
                    completion()
                case .failure(let error):
                    print("Error updating bar ID: \(error.localizedDescription)")
                }
            }
        }
    }

    func leaveBar(globalUser: GlobalUser?, completion: @escaping () -> Void) {
        guard globalUser != nil, let userId = globalUser!.userId?.id else { return }
        userService.updateUserBarId(userId: userId, barId: nil) { result in
            DispatchQueue.main.async {
                switch result {
                case .success:
                    print("Successfully updated")
                case .failure(let error):
                    print("Error updating bar ID: \(error.localizedDescription)")
                }
                completion()
            }
        }
    }
}
