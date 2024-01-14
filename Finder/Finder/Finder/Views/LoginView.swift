//
//  LoginView.swift
//  Finder
//
//  Created by becher thomas on 15/12/2023.
//

import SwiftUI

struct LoginView: View {
    @Binding var items: [CheckboxItem]
    @StateObject private var viewModel: LoginViewModel
    
    @EnvironmentObject var globalUser: GlobalUser
    
    var textColor: Color = Color("DarkBlue");
    
    init(items: Binding<[CheckboxItem]>) {
        self._items = items
        _viewModel = StateObject(wrappedValue: LoginViewModel(items: items.wrappedValue))
    }
    
    var body: some View {
        NavigationView {
            VStack {
                Spacer()
                
                AsyncImage(url: URL(string: "https://finder.thomas-dev.com/finderLogo.png")) {
                    image in image.resizable().aspectRatio(contentMode: .fit).frame(width: 250)
                } placeholder: {
                    ProgressView().frame(width: 250, height: 250)
                }
                
                TextCustomField(textLabel: "Enter a name", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "John...", currentColor: textColor, text: $viewModel.name)
                
                TextCustomField(textLabel: "Enter a surname", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "Wick...", currentColor: textColor, text: $viewModel.surname)
                
                Spacer()
                
                if !viewModel.loginStatusMessage.isEmpty {
                    Text(viewModel.loginStatusMessage).frame(maxWidth: .infinity).foregroundColor(.red).font(.system(size: 16, weight: .bold, design: .rounded)).padding(.horizontal, 50)
                } else {
                    Button(action: {
                        viewModel.loginUser(with: globalUser)
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
}
