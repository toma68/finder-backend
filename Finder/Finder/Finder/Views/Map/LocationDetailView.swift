//
//  LocationDetailView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import SwiftUI

struct LocationDetailView: View {
    @ObservedObject var viewContentModel: MapViewModel
    @StateObject var viewModel: LocationDetailViewModel
    var onExit: () -> Void
    var switchToLogin: () -> Void
    
    init(viewContentModel: MapViewModel, onExit: @escaping () -> Void, switchToLogin: @escaping () -> Void) {
        self.onExit = onExit
        self.switchToLogin = switchToLogin
        _viewContentModel = ObservedObject(wrappedValue: viewContentModel)
        _viewModel = StateObject(wrappedValue: LocationDetailViewModel())
    }

    var body: some View {
        VStack {
            if let item = viewContentModel.selectedItem {
                HStack {
                    Text(item.name).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded))
                    
                    Spacer()
                    
                    Button(action: onExit) {
                        Image(systemName: "xmark.circle.fill")
                    }
                    
                }.padding(5)
                
                HStack {
                    HStack {
                        Image(systemName: "person.3")
                        Text(":")
                        
                        Text(String(item.usersInBar.count) + " / " + item.capacity)
                        
                        Spacer()
                    }
                    
                    HStack {
                        Spacer()
                        
                        Image(systemName: "clock")
                        Text(":")
                    }
                }.padding(5)
                
                HStack(spacing: 0) {
                    ForEach(0..<item.payment_method.count, id: \.self) { elt in
                        Image(systemName: item.payment_method[elt])
                            .scaledToFill()
                            .clipped()
                    }
                    
                    Spacer()
                    
                    ForEach(0..<item.average_price, id: \.self) { _ in
                        Image(systemName: "eurosign")
                            .scaledToFill()
                            .clipped()
                    }
                    
                    if item.average_price < 5 {
                        ForEach(0..<(5 - item.average_price), id: \.self) { _ in
                            Image(systemName: "eurosign")
                                .scaledToFill()
                                .opacity(0.5)
                                .clipped()
                        }
                    }
                }.padding(5)
                
                ScrollView {
                    Text(item.description)
                }.frame(maxHeight: 150).padding(5)
                
                HStack {
                    if viewContentModel.globalUser != nil && viewContentModel.globalUser?.userId != nil {
                        if viewContentModel.user?.barId == item.id {
                            Button(action: {
                                viewModel.leaveBar(globalUser: viewContentModel.globalUser){
                                    viewContentModel.user?.barId = nil
                                    if let user = viewContentModel.user {
                                        if let index = self.viewContentModel.selectedItem?.usersInBar.firstIndex(where: { $0.id == user.id }) {
                                            self.viewContentModel.selectedItem?.usersInBar.remove(at: index)
                                        }
                                    }
                                    viewContentModel.updateUser()
                                }
                            }) {
                                Label("Leave the bar", systemImage: "figure.walk.departure").padding(10).frame(maxWidth: .infinity)
                            }.background(Color("Orange"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        } else {
                            Button(action: {
                                viewModel.enterBar(globalUser: viewContentModel.globalUser, item: item){
                                    viewContentModel.user?.barId = item.id
                                    if let user = viewContentModel.user {
                                        self.viewContentModel.selectedItem?.usersInBar.append(user)
                                    }
                                    viewContentModel.updateUser()
                                }
                            }) {
                                Label("Go to the bar", systemImage: "figure.walk.arrival").padding(10).frame(maxWidth: .infinity)
                            }.background(Color("DarkGreen"))
                                .foregroundColor(.white)
                                .cornerRadius(10)
                        }
                    } else {
                        Button(action: {
                            switchToLogin()
                        }) {
                            Label("Please login to continue", systemImage: "person.crop.circle.badge.plus").padding(10).frame(maxWidth: .infinity)
                        }.background(Color("LightBlue"))
                            .foregroundColor(.white)
                            .cornerRadius(10)
                            .font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                }
            }
        }.foregroundColor(Color("DarkBlue")).font(.system(size: 18, weight: .bold, design: .rounded))
            .padding()
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(radius: 5)
    }
}
