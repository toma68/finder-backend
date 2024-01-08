//
//  SignupView.swift
//  Finder
//
//  Created by becher thomas on 15/12/2023.
// .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))


import SwiftUI

struct SignupView: View {
    @Binding var user: User?
    @Binding var items: [CheckboxItem]
    @State var surname: String = "";
    @State var name: String = "";
    @State var company: String = "";
    @State var bio: String = "";
    @State var photo: String = "";
    @State var gender: Int = 1;
    @State private var loginStatusMessage: String = ""
    var textColor: Color = Color("DarkBlue")
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    
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
                    
                    Text("Signup").colorInvert().font(.system(size: 30, weight: .bold, design: .rounded)).padding(.trailing, 50).bold()
                }
                
                Spacer()
                
                TextCustomField(textLabel: "Enter a surname", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "Surname", currentColor: textColor, text: $surname)
                
                TextCustomField(textLabel: "Enter a name", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "Name", currentColor: textColor, text: $name)
                
                TextCustomField(textLabel: "Enter a company", imageLabel: "house.fill", textPlacehorder: "Company", currentColor: textColor, text: $company)
                
                TextCustomField(textLabel: "Enter a bio", imageLabel: "scroll.fill", textPlacehorder: "Bio...", currentColor: textColor, text: $bio)
                
                TextCustomField(textLabel: "Enter a photo URL", imageLabel: "photo.fill", textPlacehorder: "photo.com", currentColor: textColor, text: $photo)
                
                VStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items) { item in
                            CheckboxView(item: item, currentColor: Color("DarkBlue"), selectedID: $gender)
                        }
                    }.padding(.horizontal, 5).padding(.vertical).padding(.horizontal, 30)
                }.padding(.vertical, 5)
                
                if !loginStatusMessage.isEmpty {
                    Text(loginStatusMessage).frame(width: 250, height: 50).foregroundColor(.red)
                } else {
                    Button(action: signup) {
                        HStack {
                            Image(systemName: "person.crop.circle.badge.plus")
                            Text("Become a finder")
                        }
                    }.frame(width: 250, height: 50).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).font(.system(size: 20, weight: .bold, design: .rounded))
                }
                
                Spacer()
                
            }.background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
    
    func signup() {
            guard let url = URL(string: API_URL + "/users/signup") else {
                print("Invalid URL")
                return
            }

            let userData = [
                "surname": surname,
                "name": name,
                "company": company,
                "bio": bio,
                "photo": photo,
                "gender": items[gender - 1].value
            ]

            guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
                print("Failed to encode user data")
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            request.httpBody = jsonData

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    print("HTTP Request Failed \(error)")
                    return
                }

                if let httpResponse = response as? HTTPURLResponse {
                    if httpResponse.statusCode != 200 {
                        if let data = data {
                            let decoder = JSONDecoder()
                            if let apiResponse = try? decoder.decode(ApiResponse.self, from: data) {
                                DispatchQueue.main.async {
                                    self.loginStatusMessage = apiResponse.message ?? "Unknown error"
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.loginStatusMessage = ""
                                    }
                                }
                                print("Error Message: \(apiResponse.message ?? "Unknown error")")
                            } else {
                                DispatchQueue.main.async {
                                    self.loginStatusMessage = "Failed to decode response"
                                    
                                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                        self.loginStatusMessage = ""
                                    }
                                }
                                print("Failed to decode response")
                            }
                        }
                        return
                    }
                }

                if let data = data, let responseString = String(data: data, encoding: .utf8) {
                    print("Response: \(responseString)")
                    do {
                        let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                        DispatchQueue.main.async {
                            self.user = loggedInUser
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
            }.resume()
        }
}
