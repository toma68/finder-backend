//
//  MapView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/24/23.
//

import SwiftUI

struct MapView: View {
    @EnvironmentObject var globalUser: GlobalUser
    @StateObject private var viewModel = MapViewModel()
    @Binding var selectedBar: BarWithUsers?
    var switchToBar: (BarWithUsers) -> Void
    var switchToLogin: () -> Void
    
    var body: some View {
        if !viewModel.bars.isEmpty {
            MapContentView(viewModel: viewModel, selectedBar: $selectedBar, switchToBar: switchToBar, switchToLogin: switchToLogin)
                .onAppear {
                    viewModel.setupGlobalUser(globalUser)
                }
        } else {
            VStack {
                ProgressView()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .onAppear {
                viewModel.fetchBars()
            }
        }
    }
}
