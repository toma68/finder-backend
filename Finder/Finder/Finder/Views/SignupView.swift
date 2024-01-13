//
//  SignupView.swift
//  Finder
//
//  Created by becher thomas on 15/12/2023.


import SwiftUI

struct SignupView: View {
    @Binding var items: [CheckboxItem]
    @StateObject private var viewModel: SignupViewModel
    
    @EnvironmentObject var globalUser: GlobalUser
    
    var textColor: Color = Color("DarkBlue")
    
    var columns = [
        GridItem(.flexible()),
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    init(items: Binding<[CheckboxItem]>) {
        self._items = items
        _viewModel = StateObject(wrappedValue: SignupViewModel(items: items.wrappedValue))
    }
    
    
    var body: some View {
        NavigationView {
            VStack {
                
                ImageTitleCustom(titleText: "Signup", imageWidth: 150)
                
                Spacer()
                
                TextCustomField(textLabel: "Enter a surname", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "Surname", currentColor: textColor, text: $viewModel.surname)
                
                TextCustomField(textLabel: "Enter a name", imageLabel: "rectangle.and.pencil.and.ellipsis", textPlacehorder: "Name", currentColor: textColor, text: $viewModel.name)
                
                TextCustomField(textLabel: "Enter a company", imageLabel: "house.fill", textPlacehorder: "Company", currentColor: textColor, text: $viewModel.company)
                
                TextCustomField(textLabel: "Enter a bio", imageLabel: "scroll.fill", textPlacehorder: "Bio...", currentColor: textColor, text: $viewModel.bio)
                
                TextCustomField(textLabel: "Enter a photo URL", imageLabel: "photo.fill", textPlacehorder: "photo.com", currentColor: textColor, text: $viewModel.photo)
                
                VStack {
                    LazyVGrid(columns: columns, spacing: 20) {
                        ForEach(items) { item in
                            CheckboxView(item: item, currentColor: Color("DarkBlue"), selectedID: $viewModel.gender)
                        }
                    }.padding(.horizontal, 5).padding(.vertical).padding(.horizontal, 30)
                }.padding(.vertical, 5)
                
                if !viewModel.loginStatusMessage.isEmpty {
                    Text(viewModel.loginStatusMessage).frame(width: 250, height: 50).foregroundColor(.red)
                } else {
                    Button(action: {
                        viewModel.signup(with: globalUser)
                    }) {
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
}
