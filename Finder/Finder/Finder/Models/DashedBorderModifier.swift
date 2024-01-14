//
//  DashedBorderModifier.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 14/01/2024.
//

import SwiftUI

struct DashedBorderModifier: ViewModifier {
    @State private var strokeStart: CGFloat = 0.0
    @State private var strokeEnd: CGFloat = 0.0
    @State private var currentTime: Date = Date()
    
    let color: Color
    let start: CGFloat
    let end: CGFloat
    
    init(color: Color, start: CGFloat = 0.0, end: CGFloat = 1.0) {
        self.color = color
        self.start = start
        self.end = end
    }
    
    func body(content: Content) -> some View {
        content
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .trim(from: start, to: strokeEnd)
                    .stroke(
                        color,
                        style: StrokeStyle(lineWidth: 3, lineCap: .round, dash: [10, 5])
                    )
            )
            .onAppear {
                withAnimation(Animation.easeInOut(duration: 2).repeatForever()) {
                    strokeEnd = end 
                }
                
                Timer.scheduledTimer(withTimeInterval: 60, repeats: true) { _ in
                    currentTime = Date()
                }
            }
    }
}
