//
//  LoginView.swift
//  Finder
//
//  Created by becher thomas on 15/12/2023.
//

import SwiftUI

struct LoginView: View {

    @State var surname: String = "";
    @State var name: String = "";
    @State private var loginStatusMessage: String = ""
    @Binding var user: User?
    @Binding var items: [CheckboxItem]
    var textColor: Color = Color("DarkBlue");
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                AsyncImage(url: URL(string: "https://finder.thomas-dev.com/finderLogo.png")) {
                    image in image.resizable().aspectRatio(contentMode: .fit).frame(width: 250)
                } placeholder: {
                    ProgressView()
                }
                
                TextCustomField(textLabel: "Enter a name", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "John...", currentColor: textColor, text: $name)
                
                TextCustomField(textLabel: "Enter a surname", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "Wick...", currentColor: textColor, text: $surname)
                
                Spacer()
                
                if !loginStatusMessage.isEmpty {
                    Text(loginStatusMessage).foregroundColor(.red).padding()
                } else {
                    Button(action: {
                        loginUser(name: name, surname: surname)
                    }) {
                        Image(systemName: "person.fill")
                        Text("Connect")
                    }.frame(width: 250, height: 45).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).font(.system(size: 20, weight: .bold, design: .rounded))
                }
                
                NavigationLink(destination: SignupView(items: $items)) {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Become a finder")
                }.frame(width: 250, height: 45).foregroundColor(Color("Blue")).cornerRadius(10).padding(.bottom, 30).font(.system(size: 20, weight: .bold, design: .rounded))
            }.background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
    
    private func loginUser(name: String, surname: String) {
        guard let url = URL(string: "http://127.0.0.1:5000/users/login") else {
            print("Invalid URL")
            return
        }

        let loginDetails = ["name": name, "surname": surname]
        guard let jsonData = try? JSONEncoder().encode(loginDetails) else {
            print("Error: Unable to encode login details")
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let httpResponse = response as? HTTPURLResponse {
                print("HTTP Status Code: \(httpResponse.statusCode)")
                
                if httpResponse.statusCode != 200 && httpResponse.statusCode != 401 {
                    DispatchQueue.main.async {
                        self.loginStatusMessage = "Internal error"
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loginStatusMessage = ""
                        }
                    }
                } else if let error = error {
                    print("Error: \(error.localizedDescription)")
                } else if let data = data {
                    if httpResponse.statusCode == 200 {
                        do {
                            let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                            DispatchQueue.main.async {
                                self.user = loggedInUser
                            }
                        } catch {
                            DispatchQueue.main.async {
                                self.loginStatusMessage = "Failed to decode user data"
                                
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                    self.loginStatusMessage = ""
                                }
                            }
                            print("Decoding error: \(error)")
                        }
                    } else {
                        DispatchQueue.main.async {
                            self.loginStatusMessage = "Wrong name or surname"
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                                self.loginStatusMessage = ""
                            }
                        }
                        
                    }
                }
            }
        }.resume()
    }
}
