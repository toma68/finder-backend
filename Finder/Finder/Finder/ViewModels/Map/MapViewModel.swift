//
//  MapViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/01/2024.
//

import Foundation
import MapKit

class MapViewModel: ObservableObject {
    private var mapService: MapService = MapService()
    private var barService: BarService = BarService()
    private var userService: UserService = UserService()
    @Published var bars: [BarWithUsers] = []
    @Published var selectedItem: BarWithUsers?
    @Published var zoom : Double = 0.005
    @Published var user: User? = nil
    
    var globalUser: GlobalUser?
    
    var annotationItems: [BarWithUsers] {
        return bars
    }

    func fetchBars() {
        barService.fetchBars { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bars):
                    self?.bars = bars
                case .failure(let error):
                    print("Error fetching bars: \(error.localizedDescription)")
                    self?.bars = []
                }
            }
        }
    }
    
    func setupGlobalUser(_ user: GlobalUser) {
        self.globalUser = user
        
        updateUser()
    }
    
    func updateUser() {
        if let globalUser = globalUser, let userInfos = globalUser.userId {
            userService.getInfosUser(userId: userInfos) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let updatedUser):
                    DispatchQueue.main.async {
                        self.user = updatedUser
                    }
                case .failure(let error):
                    print(error)
                }
            }
        }
        
        fetchBars()
    }

    func calculateRegion() -> MKCoordinateRegion {
        return mapService.calculateRegion(for: bars)
    }
}
