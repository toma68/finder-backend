//
//  LocationDetailViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation
import SwiftUI

class LocationDetailViewModel: ObservableObject {
    private var userService: UserService = UserService()
    private var barService: BarService = BarService()

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
    
    func timeStatus(openingHour: Date, closingHour: Date) -> String {
        return barService.timeStatus(openingHour: openingHour, closingHour: closingHour)
    }
    
    func timeText(openingHour: Date, closingHour: Date, currentDate: Date) -> (text: String, color: Color) {
        return barService.timeText(openingHour: openingHour, closingHour: closingHour, currentDate: currentDate)
    }
    
    func getHour(date: Date) -> String {
        return barService.getHour(date: date)
    }
    
    func getMinutes(date: Date) -> String {
        return barService.getMinutes(date: date)
    }
}
