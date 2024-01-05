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
                            leaveBar(item: item)
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

    private func enterBar(item: BarWithUsers) {
        user?.barId = item.id
    }

    private func leaveBar(item: BarWithUsers) {
        user?.barId = nil
    }
}
