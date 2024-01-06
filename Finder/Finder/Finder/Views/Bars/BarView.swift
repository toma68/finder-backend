//
//  BarView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 05/01/2024.
//

import SwiftUI

struct BarView: View {
    @State var selectedBar: BarWithUsers?
    @State var users: [User] = []
    @State private var filteredArray: [User] = []
    var switchToMap: (BarWithUsers) -> Void
    var switchToUser: (User) -> Void
    var isClear: Bool = false
    
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
                        
                        Text(currentBar.description).foregroundColor(Color("LightGreen")).padding(.horizontal, 10).padding(.vertical, 5)
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

                UsersProcess(filteredArray: $filteredArray, users: $users, funcFilteredArray: filterUsers)
                
                ScrollView {
                    ForEach(filteredArray) { user in
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
                            .background(backgroundColor(for: user.gender))
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
                users = usersCurrentBar
                filteredArray = users
            }
        }
    }
    
    private func filterUsers(with query: String) {
        if query.isEmpty {
            filteredArray = users
        } else {
            filteredArray = users.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    func backgroundColor(for gender: String) -> AnyView {
        switch gender {
        case "m":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        case "w":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color("Orange"), Color("Yellow")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        case "n":
            return AnyView(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        default:
            return AnyView(Color.gray)
        }
    }
}
