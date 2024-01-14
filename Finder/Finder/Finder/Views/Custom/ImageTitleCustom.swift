//
//  ImageTitleCustom.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 06/01/2024.
//

import SwiftUI

struct ImageTitleCustom: View {
    @State var titleText: String
    @State var imageWidth: CGFloat
    
    var body: some View {
        HStack{
            AsyncImage(url: URL(string: "https://finder.thomas-dev.com/finderLogo.png")) {
                image in image.resizable().aspectRatio(contentMode: .fit).frame(width: imageWidth).padding(.horizontal, 30)
            } placeholder: {
                ProgressView().frame(width: imageWidth, height: imageWidth).padding(.horizontal, 30)
            }
            
            Spacer()
            
            Text(titleText).colorInvert().font(.system(size: 30, weight: .bold, design: .rounded)).padding(.trailing, 50).bold()
        }
    }
}
