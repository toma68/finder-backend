//
//  BarsViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation

class BarsViewModel: ObservableObject {
    private var barService: BarService = BarService()
    @Published var bars: [BarWithUsers] = []
    @Published var filteredBars: [BarWithUsers] = []
    @Published var searchText = ""

    func fetchBars() {
        barService.fetchBars { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let bars):
                    self?.bars = bars
                    self?.filteredBars = bars
                case .failure(let error):
                    print("Error fetching bars: \(error.localizedDescription)")
                    self?.bars = []
                    self?.filteredBars = []
                }
            }
        }
    }

    func filterBars(with query: String) {
        if query.isEmpty {
            filteredBars = bars
        } else {
            filteredBars = bars.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
}
