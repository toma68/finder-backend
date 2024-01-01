//
//  SignupView.swift
//  Finder
//
//  Created by becher thomas on 15/12/2023.
// .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))


import SwiftUI

struct SignupView: View {
    
    @State var surname: String = "";
    @State var name: String = "";
    @State var company: String = "";
    @State var bio: String = "";
    @State var photo: String = "";
    @State var gender: Int = 1;
    var textColor: Color = Color("DarkBlue")
    
    private var items: [CheckboxItem] = [
        CheckboxItem(id: 1, label: "Man", image: "mustache.fill"),
        CheckboxItem(id: 2, label: "Woman", image: "mouth.fill"),
        CheckboxItem(id: 3, label: "Neutral", image: "figure.child")
    ]
    
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
                
                TextCustomField(textLabel: "Enter a surname", textPlacehorder: "Surname", currentColor: textColor, text: $surname)
                
                TextCustomField(textLabel: "Enter a name", textPlacehorder: "Name", currentColor: textColor, text: $name)
                
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
                
                Spacer()
                
                NavigationLink(destination: LoginView()) {
                    Image(systemName: "person.crop.circle.badge.plus")
                    Text("Become a finder")
                }.frame(width: 250, height: 50).background(Color("LightBlue")).foregroundColor(.white).cornerRadius(10).padding(.bottom, 60).font(.system(size: 20, weight: .bold, design: .rounded))
                
            }.background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
        }
    }
}

struct SignupView_Previews: PreviewProvider {
    static var previews: some View {
        SignupView()
    }
}
