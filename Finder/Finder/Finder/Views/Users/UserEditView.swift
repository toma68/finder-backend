//
//  UserView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 01/01/2024.
//

import SwiftUI

struct UserEditView: View {
    @StateObject private var viewModel = UserEditViewModel()
    
    @EnvironmentObject var globalUser: GlobalUser
    
    var currentColor: Color = Color("DarkBlue")
    
    var body: some View {
        VStack {
            HStack{
                AsyncImage(url: URL(string: viewModel.userData.photo)) { image in
                    image.resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                } placeholder: {
                    ProgressView()
                }.padding(.horizontal, 30)
                
                Spacer()
                
                Text("Profile editing").foregroundStyle(Color.white).font(.system(size: 30, weight: .bold, design: .rounded)).padding(.trailing, 50).bold()
            }.padding(.top, 20)
            
            Spacer()
            
            HStack {
                Image(systemName: "rectangle.and.pencil.and.ellipsis")
                
                TextCustomFieldWithoutLabel(textPlacehorder: viewModel.userData.name, currentColor: currentColor, text: $viewModel.userData.name)
                
                TextCustomFieldWithoutLabel(textPlacehorder: viewModel.userData.surname, currentColor: currentColor, text: $viewModel.userData.surname)
            }.padding(.horizontal, 40).padding(.vertical, 10)
            
            HStack {
                Image(systemName: "house.fill")
                
                TextCustomFieldWithoutLabel(textPlacehorder: viewModel.userData.company, currentColor: currentColor, text: $viewModel.userData.company)
            }.padding(.horizontal, 40).padding(.vertical, 10)
            
            HStack {
                Image(systemName: "text.bubble")
                
                Spacer()
            }.frame(maxWidth: .infinity).padding(.horizontal, 40)
            
            ZStack {
                if viewModel.userData.bio.isEmpty{
                    Text(viewModel.userData.bio)
                }
                
                TextEditor(text: $viewModel.userData.bio)
                    .frame(maxHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.userData.bio.isEmpty ? Color.clear : Color.gray, lineWidth: 1)
                    )
            }.opacity(viewModel.userData.bio.isEmpty ? 0.5 : 1).multilineTextAlignment(.center).background(.clear).padding(.bottom, 5).padding(.horizontal, 30).padding(.vertical, 10)
            
            HStack {
                Image(systemName: "photo.fill")
                
                Spacer()
            }.padding(.horizontal, 40)
            
            ZStack {
                if viewModel.userData.photo.isEmpty{
                    Text(viewModel.userData.photo)
                }
                
                TextEditor(text: $viewModel.userData.photo)
                    .frame(maxHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(viewModel.userData.photo.isEmpty ? Color.clear : Color.gray, lineWidth: 1)
                    )
            }.opacity(viewModel.userData.photo.isEmpty ? 0.5 : 1).multilineTextAlignment(.center).background(.clear).padding(.bottom, 5).padding(.horizontal, 30).padding(.vertical, 10)
            
            Spacer()
            
            HStack {
                if !viewModel.loginStatusMessage.isEmpty {
                    Text(viewModel.loginStatusMessage).frame(maxWidth: .infinity).foregroundColor(viewModel.loginStatusColor).padding(.horizontal, 50)
                } else {
                    Button(action: {
                        viewModel.updateUser()
                    }) {
                        Image(systemName: "book.pages.fill")
                        Text("Update infos")
                    }.frame(width: 175, height: 40).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.bottom, 10)
                    
                    Button(action: {
                        globalUser.userId = nil
                    }) {
                        Image(systemName: "person.slash.fill")
                        Text("Disconnect")
                    }.frame(width: 175, height: 40).background(Color("Orange")).foregroundColor(.white).cornerRadius(10).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.bottom, 10)
                }
            }.padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(currentColor)
        .font(.system(size: 16, weight: .bold, design: .rounded))
        .onAppear {
            viewModel.setup(globalUser: globalUser)
        }
    }
}
