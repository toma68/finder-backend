//
//  UserView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 05/01/2024.
//

import SwiftUI

struct UserView: View {
    var user: User?
    var currentColor: LinearGradient
    var switchToMap: (BarWithUsers) -> Void
    @Binding var checkBoxItems: [CheckboxItem]
    @State private var barData: BarWithUsers?
    
    var body: some View {
        VStack {
            if let currentUser = user {
                AsyncImage(url: currentUser.photo) { image in
                    image.resizable()
                        .frame(width: 150, height: 150)
                        .clipShape(Circle())
                        .overlay(Circle().stroke(Color.white, lineWidth: 1))
                } placeholder: {
                    ProgressView()
                }.padding(.horizontal, 30)
                
                Text(currentUser.name + " " + currentUser.surname).foregroundStyle(Color.white).font(.system(size: 30, weight: .bold, design: .rounded)).padding(.vertical, 20)
                
                if let genderItem = checkBoxItems.first(where: { $0.value == currentUser.gender }) {
                    Label(genderItem.label, systemImage: genderItem.image).padding(.vertical, 10)
                }
                
                Label(currentUser.company, systemImage: "house.fill").padding(.vertical, 10)
                
                Label(currentUser.bio, systemImage: "text.bubble").padding(.vertical, 10)
                
                if let barData = barData {
                    Button (action: {
                        switchToMap(barData)
                    }) {
                        VStack(alignment: .center) {
                            Text("In " + barData.name).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded)).padding(.vertical, 5)
                            
                            HStack {
                                Image(systemName: "house.fill")
                                Text(":")
                                Text(barData.type)
                                
                                Spacer()
                                
                                Image(systemName: "person.3.fill")
                                Text(":")
                                Text(String(barData.usersInBar.count) + "/" + barData.capacity)
                            }.padding(.horizontal, 10).padding(.vertical, 5)
                            
                            Text(barData.description).foregroundColor(Color("LightGreen")).padding(.horizontal, 10).padding(.vertical, 5)
                        }
                        .foregroundColor(Color("LightBlue")).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.vertical, 5)
                        .padding(12)
                        .frame(maxWidth: .infinity)
                        .background(Color("DarkBlue"))
                        .cornerRadius(10)
                        .shadow(radius: 5)
                        .padding(20)
                    }
                }
                
                Spacer()
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(currentColor)
        .foregroundColor(Color("DarkBlue"))
        .font(.system(size: 18, weight: .bold, design: .rounded))
        .onAppear {
            fetchBarData()
        }
    }
    
    func fetchBarData() {
        guard let barId = user?.barId, let url = URL(string: API_URL + "/bars/users?_id=\(barId)") else {
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode(BarWithUsers.self, from: data)
                    DispatchQueue.main.async {
                        self.barData = decodedResponse
                        print("Fetched \(String(describing: self.barData?.name)) bars with users")
                    }
                } catch {
                    self.barData = nil
                    print("Decoding error: \(error)")
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
