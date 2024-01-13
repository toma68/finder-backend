//
//  BarView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import SwiftUI

struct BarsView: View {
    @StateObject private var viewModel = BarsViewModel()
    @Binding var selectedBar: BarWithUsers?
    @Binding var selectedMapBar: BarWithUsers?
    var switchToMap: (BarWithUsers) -> Void
    var switchToUser: (User) -> Void

    var body: some View {
        if let currentBar = selectedBar {
            VStack {
                HStack {
                    Button(action: {
                        selectedBar = nil
                    }) {
                        Label("Back", systemImage: "arrowshape.backward.fill")
                    }
                }
                .padding(.leading, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                BarView(selectedBar: currentBar, switchToMap: switchToMap, switchToUser: switchToUser, isClear: true)
            }.background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        } else {
            NavigationView {
                if !viewModel.bars.isEmpty {
                    VStack {
                        ImageTitleCustom(titleText: "Bars", imageWidth: 150)
                        
                        Spacer()
                        
                        HStack {
                            Image(systemName: "magnifyingglass")
                            
                            Spacer()
                            
                            TextField("Search bar...", text: $viewModel.searchText)
                                .onChange(of: viewModel.searchText) { newValue in
                                    viewModel.filterBars(with: newValue)
                                }
                        }
                        .foregroundColor(Color("DarkBlue")).font(.system(size: 17, weight: .bold, design: .rounded))
                        .padding(12)
                        .background(Color(.systemGray6))
                        .cornerRadius(8)
                        .padding(.top, 10)
                        .padding(.horizontal, 20)
                        
                        ScrollView {
                            ForEach(viewModel.filteredBars) { bar in
                                BarRowView(bar: bar, switchToMap: switchToMap, switchToUser: switchToUser)
                            }
                        }
                        .foregroundColor(Color("LightBlue")).font(.system(size: 17, weight: .bold, design: .rounded))
                        .padding(20)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .onAppear {
                        viewModel.fetchBars()
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
    }
}
