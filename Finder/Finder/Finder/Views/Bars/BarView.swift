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
                Text(currentBar.name).foregroundStyle(Color.white).font(.system(size: 30, weight: .bold, design: .rounded)).padding(.vertical, 20)

                Button (action: {
                    switchToMap(currentBar)
                }) {
                    VStack(alignment: .center) {
                        HStack {
                            Image(systemName: "house.fill")
                            Text(":")
                            Text(currentBar.type)
                            
                            Spacer()
                            
                            Image(systemName: "person.3.fill")
                            Text(":")
                            Text(String(currentBar.usersInBar.count) + " / " + currentBar.capacity)
                        }.padding(.horizontal, 10).padding(.vertical, 5)
                        
                        ScrollView {
                            Text(currentBar.description).foregroundColor(Color("LightGreen")).padding(.horizontal, 10).padding(.vertical, 5)
                        }.frame(maxHeight: 200)
                    }
                    .padding(12)
                    .frame(maxWidth: .infinity)
                    .background(Color("DarkBlue"))
                    .foregroundStyle(Color("LightBlue"))
                    .font(.system(size: 18, weight: .bold, design: .rounded))
                    .cornerRadius(10)
                    .shadow(radius: 5)
                    .padding(20)
                }

                UsersProcess(viewModel: viewUserModel)
                
                ScrollView {
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
                            .padding(.vertical, 10)
                            .background(viewModel.backgroundColor(for: user.gender))
                            .cornerRadius(10)
                            .shadow(radius: 2)
                        }
                    }
                }
                .padding(20)
                
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
