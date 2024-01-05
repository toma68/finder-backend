//
//  UserView.swift
//  Finder
//
//  Created by Hopy on 01/01/2024.
//

import SwiftUI

struct UserEditView: View {
    @Binding var user: User?
    
    var currentColor: Color = Color("DarkBlue")
    
    @State private var name: String = ""
    @State private var surname: String = ""
    @State private var company: String = ""
    @State private var bio: String = ""
    @State private var photoString: String = ""
    @State private var gender: String = ""
    
    var body: some View {
        VStack {
            HStack{
                AsyncImage(url: URL(string: photoString)) { image in
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
                
                TextCustomFieldWithoutLabel(textPlacehorder: name, currentColor: currentColor, text: $name)
                
                TextCustomFieldWithoutLabel(textPlacehorder: surname, currentColor: currentColor, text: $surname)
            }.padding(.horizontal, 40).padding(.vertical, 10)
            
            HStack {
                Image(systemName: "house.fill")
                
                TextCustomFieldWithoutLabel(textPlacehorder: company, currentColor: currentColor, text: $company)
            }.padding(.horizontal, 40).padding(.vertical, 10)
            
            HStack {
                Image(systemName: "text.bubble")
                
                Spacer()
            }.frame(maxWidth: .infinity).padding(.horizontal, 40)
            
            ZStack {
                if bio.isEmpty{
                    Text(bio)
                }
                
                TextEditor(text: $bio)
                    .frame(maxHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(bio.isEmpty ? Color.clear : Color.gray, lineWidth: 1)
                    )
            }.opacity(bio.isEmpty ? 0.5 : 1).multilineTextAlignment(.center).background(.clear).padding(.bottom, 5).padding(.horizontal, 30).padding(.vertical, 10)
            
            HStack {
                Image(systemName: "photo.fill")
                
                Spacer()
            }.padding(.horizontal, 40)
            
            ZStack {
                if photoString.isEmpty{
                    Text(photoString)
                }
                
                TextEditor(text: $photoString)
                    .frame(maxHeight: 100)
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(photoString.isEmpty ? Color.clear : Color.gray, lineWidth: 1)
                    )
            }.opacity(photoString.isEmpty ? 0.5 : 1).multilineTextAlignment(.center).background(.clear).padding(.bottom, 5).padding(.horizontal, 30).padding(.vertical, 10)
            
            Spacer()
            
            HStack {
                Button(action: {
                    updateUser(name: name, surname: surname, company: company, bio: bio, photoString: photoString)
                }) {
                    Image(systemName: "book.pages.fill")
                    Text("Update infos")
                }.frame(width: 175, height: 40).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.bottom, 10)
                
                Button(action: {
                    user = nil
                }) {
                    Image(systemName: "person.slash.fill")
                    Text("Disconnect")
                }.frame(width: 175, height: 40).background(Color("Orange")).foregroundColor(.white).cornerRadius(10).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.bottom, 10)
            }.padding(.bottom, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .foregroundColor(currentColor)
        .font(.system(size: 16, weight: .bold, design: .rounded))
        .onAppear {
            if let user = user {
                self.name = user.name
                self.surname = user.surname
                self.company = user.company
                self.bio = user.bio
                self.photoString = user.photo.absoluteString 
                self.gender = user.gender
            }
        }
    }
    
    private func updateUser(name: String, surname: String, company: String, bio: String, photoString: String) {
        user?.name = name
        user?.surname = surname
        user?.company = company
        user?.bio = bio
        let defaultPhotoURLString = "https://finder.thomas-dev.com/finderLogo.png"

        if let url = URL(string: photoString), !photoString.isEmpty {
            user?.photo = url
        } else {
            // If photoString is empty or invalid, use the default URL
            user?.photo = URL(string: defaultPhotoURLString)!
            // Update photoString to default URL string
            self.photoString = defaultPhotoURLString
        }
    }
}
