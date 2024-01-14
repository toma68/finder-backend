//
//  LocationDetailView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import SwiftUI


struct LocationDetailView: View {
    @ObservedObject var viewMapModel: MapViewModel
    @ObservedObject var viewContentModel: MapContentViewModel
    @StateObject var viewModel = LocationDetailViewModel()
    var onExit: () -> Void
    var switchToLogin: () -> Void
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    @State private var isShowing = false
    
    init(viewMapModel: MapViewModel, viewContentModel: MapContentViewModel, onExit: @escaping () -> Void, switchToLogin: @escaping () -> Void) {
        self.onExit = onExit
        self.switchToLogin = switchToLogin
        _viewContentModel = ObservedObject(initialValue: viewContentModel)
        _viewMapModel = ObservedObject(wrappedValue: viewMapModel)
    }

    var body: some View {
        if let item = viewMapModel.selectedItem {
            VStack {
                if isShowing {
                    HStack {
                        Text(item.name).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded))
                        
                        Spacer()
                        
                        Button(action: onExit) {
                            Image(systemName: "xmark.circle.fill")
                        }
                        
                    }.padding(.top, 5)
                    
                    HStack {
                        Label(item.type, systemImage: "house.fill")
                        
                        Spacer()
                        
                        Label("\(item.usersInBar.count) / \(item.capacity)", systemImage: "person.3.fill")
                    }
                    .padding(.top, 5)
                    
                    HStack {
                        HStack {
                            Label("\(viewModel.getHour(date: item.opening_hour))h\(viewModel.getMinutes(date: item.opening_hour)) - \(viewModel.getHour(date: item.closing_hour))h\(viewModel.getMinutes(date: item.closing_hour))", systemImage: "clock")
                            Spacer()
                        }
                        
                        Spacer()
                        
                        HStack {
                            Text("\(viewModel.timeText(openingHour: item.opening_hour, closingHour: item.closing_hour, currentDate: currentTime).text)")
                        }.foregroundColor(viewModel.timeText(openingHour: item.opening_hour, closingHour: item.closing_hour, currentDate: currentTime).color)
                    }
                    .padding(.top, 5)
                    .onReceive(timer) { _ in
                        currentTime = Date()
                    }
                    .onAppear {
                        currentTime = Date()
                    }
                    
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
                    }.padding(.top, 5)
                    
                    HStack {
                        if let currentDistanceToUser = viewContentModel.distanceToUser {
                            if let currentDistanceToUserLabel = viewContentModel.distanceLabel {
                                Label("\(currentDistanceToUser) \(currentDistanceToUserLabel)", systemImage: "figure.walk.motion")
                            }
                        }
                        
                        Spacer()
                        
                        Label("\(viewModel.timeStatus(openingHour: item.opening_hour, closingHour: item.closing_hour))", systemImage: "hourglass")
                    }
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .frame(maxWidth: .infinity)
                    .padding(.top, 5)
                    
                    ScrollView {
                        Text(item.description)
                    }.frame(maxHeight: 150).padding(5)
                    
                    if viewModel.timeText(openingHour: item.opening_hour, closingHour: item.closing_hour, currentDate: currentTime).color != .red {
                        HStack {
                            if viewMapModel.globalUser != nil && viewMapModel.globalUser?.userId != nil {
                                if viewMapModel.user?.barId == item.id {
                                    Button(action: {
                                        viewModel.leaveBar(globalUser: viewMapModel.globalUser){
                                            viewMapModel.user?.barId = nil
                                            if let user = viewMapModel.user {
                                                if let index = self.viewMapModel.selectedItem?.usersInBar.firstIndex(where: { $0.id == user.id }) {
                                                    self.viewMapModel.selectedItem?.usersInBar.remove(at: index)
                                                }
                                            }
                                            viewMapModel.updateUser()
                                        }
                                    }) {
                                        Label("Leave the bar", systemImage: "figure.walk.departure").padding(10).frame(maxWidth: .infinity)
                                    }.background(Color("Orange"))
                                        .foregroundColor(.white)
                                        .cornerRadius(10)
                                } else {
                                    Button(action: {
                                        viewModel.enterBar(globalUser: viewMapModel.globalUser, item: item){
                                            viewMapModel.user?.barId = item.id
                                            if let user = viewMapModel.user {
                                                self.viewMapModel.selectedItem?.usersInBar.append(user)
                                            }
                                            viewMapModel.updateUser()
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
                }
            }.foregroundColor(Color("DarkBlue")).font(.system(size: 18, weight: .bold, design: .rounded))
            .padding()
            .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .cornerRadius(10)
            .shadow(radius: 5)
            .dashedBorderAnimation(color: viewModel.timeText(openingHour: item.opening_hour, closingHour: item.closing_hour, currentDate: currentTime).color)
            .onAppear() {
                withAnimation(.easeInOut(duration: 0.5)){
                    self.isShowing = true
                }
            }
        }
    }
}

extension View {
    func dashedBorderAnimation(color: Color) -> some View {
        self.modifier(DashedBorderModifier(color: color))
    }
}
