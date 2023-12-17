//
//  TextCustomField.swift
//  Finder
//
//  Created by user234363 on 12/17/23.
//

import SwiftUI

struct TextCustomField: View {
    @State var textLabel: String
    @State var textPlacehorder: String
    @Binding var text: String

    var body: some View {
        VStack{
            Text(textLabel).frame(maxWidth: /*@START_MENU_TOKEN@*/.infinity/*@END_MENU_TOKEN@*/, alignment: .leading).padding(.horizontal, 30).font(.headline).colorInvert()
            
            ZStack {
                if text.isEmpty{
                    Text(textPlacehorder).foregroundStyle(.white)
                }
                
                TextField(textPlacehorder, text: $text).multilineTextAlignment(.center).background(.clear).foregroundColor(.white).padding(.bottom, 5).padding(.horizontal, 30)
            }
        }
    }
}
