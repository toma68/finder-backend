//
//  BarView.swift
//  Finder
//
//  Created by Hopy on 05/01/2024.
//

import SwiftUI

struct BarView: View {
    @State var selectedBar: BarWithUsers?
    @State private var searchText = ""
    @State var users: [User] = []
    @State private var filteredArray: [User] = []
    @State private var genderFilter: String? = nil
    
    var body: some View {
        VStack {
            if let currentBar = selectedBar {
                Text(currentBar.name).foregroundStyle(Color.white).font(.system(size: 30, weight: .bold, design: .rounded)).padding(.vertical, 20)
                
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
                
                Spacer()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    Spacer()
                    
                    TextField("Search user...", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            filteredArray(with: newValue)
                        }
                    
                    Spacer()
                    
                    Menu {
                        Button("Man", action: { setGenderFilter("m") })
                        Button("Woman", action: { setGenderFilter("w") })
                        Button("Neutral", action: { setGenderFilter("n") })
                        Button("Reset", action: { setGenderFilter(nil) })
                    } label: {
                        Image(systemName: "line.horizontal.3.decrease.circle").font(.system(size: 20, weight: .bold, design: .rounded))
                    }
                }
                .foregroundColor(Color("DarkBlue")).font(.system(size: 17, weight: .bold, design: .rounded))
                .padding(12)
                .background(Color(.systemGray6))
                .cornerRadius(8)
                .padding(.top, 10)
                .padding(.horizontal, 20)
                
                ScrollView {
                    ForEach(filteredArray) { user in
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
                                
    //                            if let genderItem = checkBoxItems.first(where: { $0.value == user.gender }) {
    //                                Label(genderItem.label, systemImage: genderItem.image)
    //                            }

                                Label(user.company, systemImage: "house.fill")
                            }
                            .frame(maxWidth: .infinity, alignment: .trailing)
                            .foregroundColor(Color("DarkBlue"))
                            .font(.system(size: 12, weight: .bold, design: .rounded))
                        }
                        .padding(.horizontal, 30)
                        .padding(.vertical, 20)
                        .padding(.vertical, 10)
                        .background(Color.gray)
                        .cornerRadius(10)
                        .shadow(radius: 2)
                    }
                }
                .padding(20)
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .onAppear(){
            if let usersCurrentBar = selectedBar?.usersInBar {
                users = usersCurrentBar
                filteredArray = users
            }
        }
    }
    
    private func filterUsers() {
        if searchText.isEmpty && genderFilter == nil {
            filteredArray = users
        } else {
            filteredArray = users.filter {
                ($0.name.lowercased().contains(searchText.lowercased()) || searchText.isEmpty) &&
                (genderFilter == nil || $0.gender == genderFilter)
            }
        }
    }
    
    private func filteredArray(with query: String) {
        if query.isEmpty {
            filteredArray = users
        } else {
            filteredArray = users.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    private func setGenderFilter(_ gender: String?) {
        genderFilter = gender
        filterUsers()
    }
}
