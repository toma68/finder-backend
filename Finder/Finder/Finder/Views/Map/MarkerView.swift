//
//  MarkerView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import SwiftUI

struct MarkerView: View {
    var item: Bar
    @Binding var selectedItem: Bar?
    var onTap: () -> Void

    var body: some View {
        Image(systemName: selectedItem?.id == item.id ? "mappin.and.ellipse.circle.fill" : "mappin.circle.fill")
            .foregroundColor(selectedItem?.id == item.id ? Color("DarkBlue") : Color("Orange"))
            .font(.system(size: 30))
            .scaleEffect(selectedItem?.id == item.id ? 1.5 : 1)
            .onTapGesture {
                onTap()
            }
            .animation(.easeInOut, value: selectedItem)
    }
}
