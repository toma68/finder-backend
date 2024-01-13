//
//  BarRowViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 13/01/2024.
//

import Foundation
import SwiftUI

class BarRowViewModel: ObservableObject {
    private var barService: BarService = BarService()
    
    func timeStatus(openingHour: Date, closingHour: Date) -> String {
        return barService.timeStatus(openingHour: openingHour, closingHour: closingHour)
    }
    
    func timeText(openingHour: Date, closingHour: Date, currentDate: Date) -> (text: String, color: Color) {
        return barService.timeText(openingHour: openingHour, closingHour: closingHour, currentDate: currentDate)
    }
    
    func getHour(date: Date) -> String {
        return barService.getHour(date: date)
    }
    
    func getMinutes(date: Date) -> String {
        return barService.getMinutes(date: date)
    }
}
