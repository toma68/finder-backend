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
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                AsyncImage(url: URL(string: "https://finder.thomas-dev.com/finderLogo.png")) {
                    image in image.resizable().aspectRatio(contentMode: .fit).frame(width: 250)
                } placeholder: {
                    ProgressView()
                }
                
                TextCustomField(textLabel: "Enter a surname", textPlacehorder: "John...", text: $surname)
                
                TextCustomField(textLabel: "Enter a name", textPlacehorder: "Wick...", text: $name)
                
                Spacer()
                
                NavigationLink(destination: SignupView()) {
                    Text("Connect").frame(width: 250, height: 45).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).font(.system(size: 20, weight: .bold, design: .rounded))
                }
                
                NavigationLink(destination: SignupView()) {
                    Text("Signup").frame(width: 250, height: 45).foregroundColor(Color("Blue")).cornerRadius(10).padding(.bottom, 30).font(.system(size: 20, weight: .bold, design: .rounded))
                }
            }.background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}
