//
//  CheckBox.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 12/17/23.
//

import SwiftUI

struct CheckboxView: View {
    var item: CheckboxItem
    var currentColor: Color
    @Binding var selectedID: Int

    var body: some View {
        VStack {
            Text(item.label).padding(.vertical, 5)
            
            HStack {
                Image(systemName: item.image)
                
                Image(systemName: self.selectedID == item.id ? "checkmark.square" : "square")
                    .onTapGesture {
                        self.selectedID = item.id
                    }
            }
        }.foregroundColor(currentColor).font(.system(size: 20, weight: .bold, design: .rounded))
    }
}
