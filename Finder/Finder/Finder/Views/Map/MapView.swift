//
//  MapView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/24/23.
//

import MapKit
import SwiftUI

private var zoom : Double = 0.005

func calculateRegion(for items: [BarWithUsers]) -> MKCoordinateRegion {
    let latitudes = items.map { $0.coordinate.latitude }
    let longitudes = items.map { $0.coordinate.longitude }

    let maxLat = latitudes.max() ?? 0
    let minLat = latitudes.min() ?? 0
    let maxLong = longitudes.max() ?? 0
    let minLong = longitudes.min() ?? 0

    let center = CLLocationCoordinate2D(
        latitude: (minLat + maxLat) / 2,
        longitude: (minLong + maxLong) / 2
    )

    let span = MKCoordinateSpan(
        latitudeDelta: max(maxLat - minLat, zoom) * 1.2, // 20% extra for padding
        longitudeDelta: max(maxLong - minLong, zoom) * 1.2 // 20% extra for padding
    )

    return MKCoordinateRegion(center: center, span: span)
}


struct MapView: View {
    @Binding var selectedItem: BarWithUsers?
    @State private var bars: [BarWithUsers] = []
    @Binding var user: User?
    @Binding var selectedTab: Int
    
    private func goToLogin() {
        selectedTab = 0 
    }
    
    var body: some View {
        if !bars.isEmpty {
            MapContentView(items: bars, selectedItem: $selectedItem, user: $user, zoom: zoom, switchToLogin: goToLogin)
                .onAppear {
                    fetchBars()
                }
        } else {
            VStack {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .onAppear {
                fetchBars()
            }
        }
    }
    
    private func fetchBars() {
        guard let url = URL(string: "http://127.0.0.1:5000/bars/users") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([BarWithUsers].self, from: data)
                    DispatchQueue.main.async {
                        self.bars = decodedResponse
                        print("Fetched \(self.bars.count) bars with users")
                    }
                } catch {
                    self.bars = []
                    print("Decoding error: \(error)")
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
