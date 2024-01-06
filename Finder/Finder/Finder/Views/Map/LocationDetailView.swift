//
//  LocationDetailView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import SwiftUI

struct LocationDetailView: View {
    var item: BarWithUsers
    var onExit: () -> Void
    var switchToLogin: () -> Void
    
    @Binding var user: User?

    var body: some View {
        VStack {
            HStack {
                Text(item.name).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded))
                
                Spacer()
                
                Button(action: onExit) {
                    Image(systemName: "xmark.circle.fill")
                }
                
            }.padding(5)
            
            HStack {
                Image(systemName: "person.3")
                Text(":")
                
                Spacer()
                
                Text(String(item.usersInBar.count) + " / " + item.capacity)
                
                Spacer()
                
                if user != nil {
                    if user?.barId == item.id {
                        Button(action: {
                            leaveBar()
                        }) {
                            Image(systemName: "figure.walk.departure").padding(10)
                        }.background(Color("Orange"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    } else {
                        Button(action: {
                            enterBar(item: item)
                        }) {
                            Image(systemName: "figure.walk.arrival").padding(10)
                        }.background(Color("DarkGreen"))
                        .foregroundColor(.white)
                        .cornerRadius(10)
                    }
                }
                else {
                    Button(action: {
                        switchToLogin()
                    }) {
                        Image(systemName: "person.crop.circle.badge.plus").padding(10)
                    }.background(Color("LightBlue"))
                    .foregroundColor(.white)
                    .cornerRadius(10)
                    .font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }.padding(5)
            
            HStack {
                Text(item.description)
            }.padding(5)
        }.foregroundColor(Color("DarkBlue")).font(.system(size: 18, weight: .bold, design: .rounded))
        .padding()
        .frame(width: 300)
        .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        .cornerRadius(10)
        .shadow(radius: 5)
    }

    func updateUserBarId(userId: String, barId: String?, completion: @escaping (Bool) -> Void) {
        guard let url = URL(string: "http://127.0.0.1:5000/users/update-bar") else {
            print("Error: Invalid URL")
            completion(false)
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["user_id": userId, "new_bar_id": barId as Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                print("Network request failed with error: \(error.localizedDescription)")
                completion(false)
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode == 200 {
                    completion(true)
                } else {
                    print("HTTP request failed with status code: \(httpResponse.statusCode)")
                    if let data = data, let responseString = String(data: data, encoding: .utf8) {
                        print("Response data: \(responseString)")
                    }
                    completion(false)
                }
            } else {
                print("Error: No valid HTTP response received")
                completion(false)
            }
        }
        task.resume()
    }

    
    private func enterBar(item: BarWithUsers) {
        guard let userId = user?.id else { return }
        let barId = item.id
        updateUserBarId(userId: userId, barId: barId) { success in
            if success {
                self.user?.barId = barId
            }
        }
    }

    private func leaveBar() {
        guard let userId = user?.id else { return }
        updateUserBarId(userId: userId, barId: nil) { success in
            if success {
                self.user?.barId = nil
            }
        }
    }
}
