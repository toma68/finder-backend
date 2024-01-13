//
//  MapContentView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import MapKit
import SwiftUI

struct MapContentView: View {
    @ObservedObject var viewModel: MapViewModel
    @StateObject var viewContentModel: MapContentViewModel
    @Binding var selectedBar: BarWithUsers?
    var switchToBar: (BarWithUsers) -> Void
    var switchToLogin: () -> Void
    
    init(viewModel: MapViewModel, selectedBar: Binding<BarWithUsers?>, switchToBar: @escaping (BarWithUsers) -> Void, switchToLogin: @escaping () -> Void) {
        self._selectedBar = selectedBar
        self.switchToBar = switchToBar
        self.switchToLogin = switchToLogin
        _viewModel = ObservedObject(wrappedValue: viewModel)
        _viewContentModel = StateObject(wrappedValue: MapContentViewModel(items: viewModel.bars, zoom: viewModel.zoom))
    }

    var body: some View {
        Map(coordinateRegion: $viewContentModel.region, annotationItems: viewModel.bars) { item in
            MapAnnotation(coordinate: item.coordinate) {
                MarkerView(item: item, selectedItem: $viewModel.selectedItem) {
                    viewModel.selectedItem = item
                    viewContentModel.centerMapOnLocation(location: item)
                }
            }
        }.edgesIgnoringSafeArea(/*@START_MENU_TOKEN@*/.all/*@END_MENU_TOKEN@*/)
        .overlay(
            Group {
                if let selectedItem = viewModel.selectedItem {
                    Button(action: {
                        switchToBar(selectedItem)
                    }) {
                        LocationDetailView(viewContentModel: viewModel, onExit: { viewModel.selectedItem = nil }, switchToLogin: switchToLogin)
                    }.padding(.horizontal, 20)
                }
            }.offset(y: -8),
            alignment: .bottom
            
        )
        .onAppear(){
            print("Updated bar")
            if let currentBar = selectedBar {
                viewModel.selectedItem = currentBar
                viewContentModel.centerMapOnLocation(location: currentBar)
            }
        }
    }
}


//                        LocationDetailView(item: selectedItem, onExit: { self.selectedItem = nil }, switchToLogin: switchToLogin, user: $user)
