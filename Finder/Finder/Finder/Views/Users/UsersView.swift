//
//  UsersView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 01/01/2024.
//

import SwiftUI

struct UsersView: View {
    @Binding var checkBoxItems: [CheckboxItem]
    @State private var searchText = ""
    @State var users: [User] = []
    @State private var filteredArray: [User] = []
    @State private var genderFilter: String? = nil

    var body: some View {
        NavigationView {
            if !users.isEmpty {
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
                            NavigationLink(destination: UserView(user: user, currentColor: gradientColor(for: user.gender), checkBoxItems: $checkBoxItems)) {
                                VStack(alignment: .center) {
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
                                            Text(user.name + " " + user.surname).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded))
                                            
                                            if let genderItem = checkBoxItems.first(where: { $0.value == user.gender }) {
                                                Label(genderItem.label, systemImage: genderItem.image)
                                            }
                                            
                                            Label(user.company, systemImage: "house.fill")
                                        }.frame(maxWidth: .infinity, alignment: .trailing).foregroundColor(Color("DarkBlue")).font(.system(size: 12, weight: .bold, design: .rounded))
                                    }
                                    .padding(.horizontal, 30)
                                    .padding(.vertical, 20)
             
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(backgroundColor(for: user.gender))
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
                    fetchUsers()
                    filteredArray = users
                }
            } else {
                VStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .onAppear {
                    fetchUsers()
                    filteredArray = users
                }
            }
        }
    }
    
    private func setGenderFilter(_ gender: String?) {
        genderFilter = gender
        filterUsers()
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
    
    func gradientColor(for gender: String) -> LinearGradient {
        switch gender {
        case "m":
            return LinearGradient(gradient: Gradient(colors: [Color("DarkGreen"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "w":
            return LinearGradient(gradient: Gradient(colors: [Color("Orange"), Color("Yellow")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        case "n":
            return LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue")]), startPoint: .topLeading, endPoint: .bottomTrailing)
        default:
            return LinearGradient(gradient: Gradient(colors: [Color.gray]), startPoint: .topLeading, endPoint: .bottomTrailing)
        }
    }
    
    private func fetchUsers() {
        guard let url = URL(string: "http://127.0.0.1:5000/users") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([User].self, from: data)
                    DispatchQueue.main.async {
                        self.users = decodedResponse
                        print("Fetched \(self.users.count) users")
                    }
                } catch {
                    self.users = []
                    self.filteredArray = []
                    print("Decoding error: \(error)")
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
