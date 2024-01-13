//
//  UsersView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 01/01/2024.
//

import SwiftUI

struct UserRowView: View {
    let user: User
    let checkBoxItems: [CheckboxItem]

    var body: some View {
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

            UserInfoView(user: user, checkBoxItems: checkBoxItems)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 20)
    }
}

struct UserInfoView: View {
    let user: User
    let checkBoxItems: [CheckboxItem]

    var body: some View {
        VStack (alignment: .trailing, spacing: 1) {
            Text(user.name + " " + user.surname)
                .foregroundColor(.white)
                .font(.system(size: 20, weight: .bold, design: .rounded))
            
            if let genderItem = checkBoxItems.first(where: { $0.value == user.gender }) {
                Label(genderItem.label, systemImage: genderItem.image)
            }

            Label(user.company, systemImage: "house.fill")
        }
        .frame(maxWidth: .infinity, alignment: .trailing)
        .foregroundColor(Color("DarkBlue"))
        .font(.system(size: 12, weight: .bold, design: .rounded))
    }
}

struct UserEltView: View {
    @ObservedObject var viewModel: UsersViewModel
    @Binding var checkBoxItems: [CheckboxItem]
    var switchToMap: (BarWithUsers) -> Void
    
    var body: some View {
        ScrollView {
            ForEach(viewModel.filteredUsers) { user in
                NavigationLink(destination: UserView(user: user, currentColor: viewModel.gradientColor(for: user.gender), switchToMap: switchToMap, checkBoxItems: $checkBoxItems)) {
                    UserRowView(user: user, checkBoxItems: checkBoxItems)
                        .background(viewModel.backgroundColor(for: user.gender))
                        .cornerRadius(10)
                        .shadow(radius: 2)
                }
            }
        }
        .padding(20)
    }
}

struct UsersProcess: View {
    @ObservedObject var viewModel: UsersViewModel
    
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
            
            Spacer()
            
            TextField("Search user...", text: $viewModel.searchText)
                .onChange(of: viewModel.searchText) { newValue in
                    viewModel.filterUsers()
                }
            
            Spacer()
            
            Menu {
                Button("Man", action: { viewModel.setGenderFilter("m") })
                Button("Woman", action: { viewModel.setGenderFilter("w") })
                Button("Neutral", action: { viewModel.setGenderFilter("n") })
                Button("Reset", action: { viewModel.setGenderFilter(nil) })
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
    }
}

struct UsersView: View {
    @StateObject private var viewModel = UsersViewModel()
    @Binding var selectedUser: User?
    @Binding var checkBoxItems: [CheckboxItem]
    @Binding var selectedTab: Int
    @Binding var selectedBar: BarWithUsers?
    var switchToMap: (BarWithUsers) -> Void

    var body: some View {
        if let currentUser = selectedUser {
            VStack {
                HStack {
                    Button(action: {
                        selectedUser = nil
                    }) {
                        Label("Back", systemImage: "arrowshape.backward.fill")
                    }
                }
                .padding(.leading, 10)
                .frame(maxWidth: .infinity, alignment: .leading)
                
                UserView(user: currentUser, currentColor: viewModel.gradientColor(for: currentUser.gender), switchToMap: switchToMap, checkBoxItems: $checkBoxItems)
            }.background(viewModel.gradientColor(for: currentUser.gender))
        } else {
            NavigationView {
                if !viewModel.users.isEmpty {
                    VStack {
                        ImageTitleCustom(titleText: "Users", imageWidth: 150)
                        
                        Spacer()
                        
                        UsersProcess(viewModel: viewModel)
                        
                        UserEltView(viewModel: viewModel, checkBoxItems: $checkBoxItems, switchToMap: switchToMap)
                    }
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .onAppear {
                        viewModel.fetchUsers()
                    }
                } else {
                    VStack {
                        ProgressView()
                    }
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                    .onAppear {
                        viewModel.fetchUsers()
                    }
                }
            }
        }
    }
}
