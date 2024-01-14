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
    
    @State private var trackingMode: MapUserTrackingMode = .follow
    
    @State private var isUserLocationExpanded = false
    @State private var rotationUserLocationAngle: Double = 0
    
    @State private var isBarsLocationExpanded = false
    @State private var rotationBarsLocationAngle: Double = 0
    
    init(viewModel: MapViewModel, selectedBar: Binding<BarWithUsers?>, switchToBar: @escaping (BarWithUsers) -> Void, switchToLogin: @escaping () -> Void) {
        self._selectedBar = selectedBar
        self.switchToBar = switchToBar
        self.switchToLogin = switchToLogin
        self.viewModel = viewModel
        _viewContentModel = StateObject(wrappedValue: MapContentViewModel(items: viewModel.bars, zoom: viewModel.zoom))
    }

    var body: some View {
        ZStack {
            Map(coordinateRegion: $viewContentModel.region, showsUserLocation: true, userTrackingMode: $trackingMode, annotationItems: viewModel.annotationItems) { bar in
                MapAnnotation(coordinate: bar.coordinate) {
                    MarkerView(item: bar, selectedItem: $viewModel.selectedItem) {
//                        print(viewContentModel.calculateDistanceToSelectedItem(selectedItem: bar))
                        viewContentModel.distanceToUser = viewContentModel.calculateDistanceToSelectedItem(selectedItem: bar).distance
                        viewContentModel.distanceLabel = viewContentModel.calculateDistanceToSelectedItem(selectedItem: bar).unit
                        viewModel.selectedItem = bar
                        viewContentModel.setBarWithUsers(item: bar)
                        viewContentModel.centerMapOnLocation(location: bar)
                    }
                }
            }.edgesIgnoringSafeArea(.all)
            .overlay(
                Group {
                    if let selectedItem = viewModel.selectedItem {
                        Button(action: {
                            switchToBar(selectedItem)
                        }) {
                            LocationDetailView(viewMapModel: viewModel, viewContentModel: viewContentModel, onExit: { viewModel.selectedItem = nil }, switchToLogin: switchToLogin)
                        }.padding(.horizontal, 20)
                    }
                }.offset(y: -8),
                alignment: .bottom
                
            )
            
            Button(action: {
                withAnimation {
                    isUserLocationExpanded.toggle()
                    rotationUserLocationAngle += 360
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        isUserLocationExpanded = false
                    }
                }
                viewModel.selectedItem = nil
                viewContentModel.centerOnUserLocation()
            }) {
                Image(systemName: "location.circle.fill")
                    .foregroundColor(.primary)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .scaleEffect(isUserLocationExpanded ? 1.25 : 1.0)
                    .rotationEffect(Angle(degrees: rotationUserLocationAngle))
            }
            .padding(5)
            .position(x: UIScreen.main.bounds.width - 50, y: 50)
            
            Button(action: {
                withAnimation {
                    isBarsLocationExpanded.toggle()
                    rotationBarsLocationAngle += 360
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                    withAnimation {
                        isBarsLocationExpanded = false
                    }
                }
                viewModel.selectedItem = nil
                viewContentModel.centerOnBarsLocation()
            }) {
                Image(systemName: "wineglass.fill")
                    .foregroundColor(.primary)
                    .padding()
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .clipShape(Circle())
                    .shadow(radius: 5)
                    .scaleEffect(isBarsLocationExpanded ? 1.25 : 1.0)
                    .rotationEffect(Angle(degrees: rotationBarsLocationAngle))
            }
            .padding(5)
            .position(x: 50, y: 50)
        }
        .onAppear() {
            if let currentBar = selectedBar {
                viewModel.selectedItem = currentBar
                viewContentModel.centerMapOnLocation(location: currentBar)
            }
        }
    }
}
