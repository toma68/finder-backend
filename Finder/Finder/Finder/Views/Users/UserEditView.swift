//
//  UserView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 01/01/2024.
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
    @State private var loginStatusMessage: String = ""
    @State private var loginStatusColor: Color = .red
    
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
                if !loginStatusMessage.isEmpty {
                    Text(loginStatusMessage).frame(width: 175, height: 40).foregroundColor(loginStatusColor)
                } else {
                    Button(action: {
                        updateUser(name: name, surname: surname, company: company, bio: bio, photoString: photoString)
                    }) {
                        Image(systemName: "book.pages.fill")
                        Text("Update infos")
                    }.frame(width: 175, height: 40).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.bottom, 10)
                }
                
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
    
    func updateUser(name: String, surname: String, company: String, bio: String, photoString: String) {
        guard let url = URL(string: API_URL + "/users/update") else {
            print("Invalid URL")
            return
        }
        
        let userData = [
            "user_id": user?.id,
            "surname": surname,
            "name": name,
            "company": company,
            "bio": bio,
            "photo": photoString.isEmpty ? "https://finder.thomas-dev.com/finderLogo.png" : photoString
        ]

        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            print("Failed to encode user data")
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData
        
        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.loginStatusMessage = "HTTP Request Failed \(error)"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.loginStatusMessage = ""
                    }
                }
                print("HTTP Request Failed \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse, let data = data {
                let decoder = JSONDecoder()
                if httpResponse.statusCode != 200 {
                    if let apiResponse = try? decoder.decode(ApiResponse.self, from: data) {
                        DispatchQueue.main.async {
                            self.loginStatusMessage = "\(apiResponse.message ?? "Unknown error")"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.loginStatusMessage = ""
                            }
                        }
                        print("\(apiResponse.message ?? "Unknown error")")
                    } else {
                        DispatchQueue.main.async {
                            self.loginStatusMessage = "Failed to decode error response"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.loginStatusMessage = ""
                            }
                        }
                        print("Failed to decode error response")
                    }
                } else {
                    do {
                        let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                        DispatchQueue.main.async {
                            self.user = loggedInUser
                            self.loginStatusColor = Color("DarkBlue")
                            self.loginStatusMessage = "Updated successfully"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.loginStatusMessage = ""
                                self.loginStatusColor = .red
                            }
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.loginStatusMessage = "Failed to decode user data"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self.loginStatusMessage = ""
                            }
                        }
                        print("Decoding error: \(error)")
                    }
                }
            }
        }.resume()
    }
}
