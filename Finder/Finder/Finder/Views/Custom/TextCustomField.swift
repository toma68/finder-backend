//
//  TextCustomField.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

struct TextCustomField: View {
    @State var textLabel: String
    @State var imageLabel: String? = nil
    @State var textPlacehorder: String
    @State var currentColor: Color
    @Binding var text: String

    var body: some View {
        VStack{
            HStack {
                Image(systemName: imageLabel ?? "arrowshape.forward.fill")
                
                Text(textLabel)
            }.frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.horizontal, 30)
            
            
            ZStack {
                if text.isEmpty{
                    Text(textPlacehorder)
                }
                
                TextField(textPlacehorder, text: $text)
            }.opacity(text.isEmpty ? 0.5 : 1).multilineTextAlignment(.center).background(.clear).padding(.bottom, 5).padding(.horizontal, 30)
        }.foregroundColor(currentColor).font(.system(size: 20, weight: .bold, design: .rounded))
    }
}

struct TextCustomFieldWithoutLabel: View {
    @State var textPlacehorder: String
    @State var currentColor: Color
    @Binding var text: String

    var body: some View {
        VStack{
            ZStack {
                if text.isEmpty{
                    Text(textPlacehorder)
                }
                
                TextField(textPlacehorder, text: $text)
            }.opacity(text.isEmpty ? 0.5 : 1).multilineTextAlignment(.center).background(.clear).padding(.bottom, 5).padding(.horizontal, 30)
        }.foregroundColor(currentColor).font(.system(size: 20, weight: .bold, design: .rounded))
    }
}
