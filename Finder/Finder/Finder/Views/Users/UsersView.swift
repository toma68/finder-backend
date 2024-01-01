//
//  UsersView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 01/01/2024.
//

import SwiftUI

struct UsersView: View {
    @State private var searchText = ""
    @State var users: [User]
    @State private var filteredArray: [User] = []

    var body: some View {
        NavigationView {
            VStack {
                HStack{
                    AsyncImage(url: URL(string: "https://finder.thomas-dev.com/finderLogo.png")) {
                        image in image.resizable().aspectRatio(contentMode: .fit).frame(width: 150).padding(.horizontal, 30)
                    } placeholder: {
                        ProgressView()
                    }
                    
                    Spacer()
                    
                    Text("Users").colorInvert().font(.system(size: 30, weight: .bold, design: .rounded)).padding(.trailing, 50).bold()
                }
                
                Spacer()
                
                HStack {
                    Image(systemName: "magnifyingglass")
                    
                    Spacer()
                    
                    TextField("Search user...", text: $searchText)
                        .onChange(of: searchText) { newValue in
                            filteredArray(with: newValue)
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
                        NavigationLink(destination: SignupView()) {
                            VStack(alignment: .center) {
                                Text(user.name + " " + user.surname).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded)).padding(.vertical, 5)
                                
//                                HStack {
//                                    Image(systemName: "house.fill")
//                                    Text(":")
//                                    Text(bar.type)
//                                    
//                                    Spacer()
//                                    
//                                    Image(systemName: "person.3.fill")
//                                    Text(":")
//                                    Text("0" + " / " + bar.capacity)
//                                }.padding(.horizontal, 10).padding(.vertical, 5)
//                                
//                                Text(bar.description).foregroundColor(Color("LightGreen")).padding(.horizontal, 10).padding(.vertical, 5)
                            }
                            .padding(12)
                            .frame(maxWidth: .infinity)
                            .background(Color("DarkBlue"))
                            .cornerRadius(10)
                            .shadow(radius: 5)
                        }
                    }
                }
                .foregroundColor(Color("LightBlue")).font(.system(size: 17, weight: .bold, design: .rounded))
                .padding(20)
            }
            .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
            .onAppear {
                filteredArray = users
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
}
