//
//  BarView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 05/01/2024.
//

import SwiftUI

struct BarView: View {
    @StateObject private var viewModel: BarViewModel
    @StateObject private var viewUserModel = UsersViewModel()
    var selectedBar: BarWithUsers?
    var switchToMap: (BarWithUsers) -> Void
    var switchToUser: (User) -> Void
    var isClear: Bool = false
    
    @State private var currentTime = Date()
    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()
    
    init(selectedBar: BarWithUsers?, switchToMap: @escaping (BarWithUsers) -> Void, switchToUser: @escaping (User) -> Void, isClear: Bool) {
        self.selectedBar = selectedBar
        self.switchToMap = switchToMap
        self.switchToUser = switchToUser
        self.isClear = isClear
        _viewModel = StateObject(wrappedValue: BarViewModel(selectedBar: selectedBar))
    }
    
    var body: some View {
        VStack {
            if let currentBar = selectedBar {
                Text(currentBar.name).foregroundStyle(Color.white).font(.system(size: 33, weight: .bold, design: .rounded)).padding(.bottom, 10)
                
                Button (action: {
                    switchToMap(currentBar)
                }) {
                    VStack(alignment: .center) {
                        HStack {
                            Label(currentBar.type, systemImage: "house.fill")
                            
                            Spacer()
                            
                            Label(String(currentBar.usersInBar.count) + " / " + currentBar.capacity, systemImage: "person.3.fill")
                        }.padding(.horizontal, 5).padding(.top, 5)
                        
                        HStack {
                            HStack {
                                Label("\(viewModel.getHour(date: currentBar.opening_hour))h\(viewModel.getMinutes(date: currentBar.opening_hour)) - \(viewModel.getHour(date: currentBar.closing_hour))h\(viewModel.getMinutes(date: currentBar.closing_hour))", systemImage: "clock")
                                Spacer()
                            }.foregroundColor(Color("LightGreen"))

                            Spacer()

                            HStack {
                                Text("\(viewModel.timeText(openingHour: currentBar.opening_hour, closingHour: currentBar.closing_hour, currentDate: currentTime).text)")
                            }.foregroundColor(viewModel.timeText(openingHour: currentBar.opening_hour, closingHour: currentBar.closing_hour, currentDate: currentTime).color)
                        }
                        .padding(.horizontal, 5).padding(.top, 5)
                        .onReceive(timer) { _ in
                            currentTime = Date()
                        }
                        .onAppear {
                            currentTime = Date()
                        }
                        
                        ScrollView {
                            Text(currentBar.description).foregroundColor(Color("LightGreen")).padding(.horizontal, 10).padding(.vertical, 5)
                        }.frame(maxHeight: .infinity)

                        HStack {
                            Spacer()
                            Text("\(viewModel.timeStatus(openingHour: currentBar.opening_hour, closingHour: currentBar.closing_hour))")
                            Spacer()
                        }
                        .foregroundColor(Color("Yellow"))
                        .frame(maxWidth: .infinity)
                        .padding(5)
                        
                        HStack(spacing: 0) {
                            ForEach(0..<currentBar.payment_method.count, id: \.self) { elt in
                                Image(systemName: currentBar.payment_method[elt])
                                    .scaledToFill()
                                    .clipped()
                            }
                            
                            Spacer()
                            
                            ForEach(0..<currentBar.average_price, id: \.self) { _ in
                                Image(systemName: "eurosign")
                                    .scaledToFill()
                                    .clipped()
                            }
                            
                            if currentBar.average_price < 5 {
                                ForEach(0..<(5 - currentBar.average_price), id: \.self) { _ in
                                    Image(systemName: "eurosign")
                                        .scaledToFill()
                                        .opacity(0.5)
                                        .clipped()
                                }
                            }
                        }.padding(.horizontal, 5).foregroundColor(Color("Orange"))
                        
                        HStack {
                            Label(currentBar.address, systemImage: "road.lanes")
                            
                            Spacer()
                            
                            Label(currentBar.postal_code, systemImage: "signpost.right")
                        }.font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white).padding(.horizontal, 10).padding(.top, 2)
                        
                        HStack {
                            Label(currentBar.phone, systemImage: "phone")
                            
                            Spacer()
                            
                            Label(currentBar.town, systemImage: "building.2")
                        }.font(.system(size: 15, weight: .bold, design: .rounded)).foregroundColor(.white).padding(.horizontal, 10)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkBlue"))
                    .foregroundStyle(Color("LightBlue"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(.horizontal, 20).padding(.vertical, 5)
                }
                
                UsersProcess(viewModel: viewUserModel)
                
                ScrollView {
                    VStack {
                        ForEach(viewUserModel.filteredUsers) { user in
                            Button (action: {
                                switchToUser(user)
                            }) {
                                HStack {
                                    AsyncImage(url: user.photo) { image in
                                        image.resizable()
                                            .frame(width: 50, height: 50)
                                            .clipShape(Circle())
                                            .overlay(Circle().stroke(Color.white, lineWidth: 1))
                                    } placeholder: {
                                        ProgressView()
                                    }
                                    
                                    Spacer()
                                    
                                    VStack (alignment: .trailing, spacing: 1) {
                                        Text(user.name + " " + user.surname)
                                            .foregroundColor(.white)
                                            .font(.system(size: 20, weight: .bold, design: .rounded))
                                        
                                        Label(user.company, systemImage: "house.fill")
                                    }
                                    .frame(maxWidth: .infinity, alignment: .trailing)
                                    .foregroundColor(Color("DarkBlue"))
                                    .font(.system(size: 12, weight: .bold, design: .rounded))
                                }
                                .padding(.horizontal, 30)
                                .padding(.vertical, 20)
                                .padding(.vertical, 5)
                                .background(viewModel.backgroundColor(for: user.gender))
                                .cornerRadius(10)
                                .shadow(radius: 2)
                            }
                        }
                    }
                }.frame(maxHeight: 200).padding(.horizontal, 20).padding(.vertical, 5)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(isClear ? LinearGradient(gradient: Gradient(colors: [.clear]), startPoint: .topLeading, endPoint: .bottomTrailing) : LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear(){
            if let usersCurrentBar = selectedBar?.usersInBar {
                viewUserModel.users = usersCurrentBar
                viewUserModel.filteredUsers = viewUserModel.users
            }
        }
    }
}
