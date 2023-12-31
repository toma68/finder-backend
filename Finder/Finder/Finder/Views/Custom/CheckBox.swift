//
//  CheckBox.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

struct CheckboxItem: Identifiable {
    let id: Int
    var label: String
}

// Create a Checkbox View
struct CheckboxView: View {
    var item: CheckboxItem
    @Binding var selectedID: Int

    var body: some View {
        VStack {
            Text(item.label).padding(.vertical, 5).font(.headline)
            Image(systemName: self.selectedID == item.id ? "checkmark.square" : "square")
                .onTapGesture {
                    self.selectedID = item.id
                }
        }.colorInvert()
    }
}
