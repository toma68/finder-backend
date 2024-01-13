//
//  BarService.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation
import SwiftUI

class BarService {
    // Function to fetch bars
    func fetchBars(completion: @escaping (Result<[BarWithUsers], Error>) -> Void) {
        guard let url = URL(string: API_URL + "/bars/users") else {
            completion(.failure(URLError(.badURL)))
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }
            
            do {
                let bars = try JSONDecoder().decode([BarWithUsers].self, from: data)
                completion(.success(bars))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    func getHour(date: Date) -> String {
        let hour: Int = Calendar.current.component(.hour, from: date)
        return String(format: "%02d", hour)
    }
    
    func getMinutes(date: Date) -> String {
        let min: Int = Calendar.current.component(.minute, from: date)
        return String(format: "%02d", min)
    }
    
    func timeStatus(openingHour: Date, closingHour: Date) -> String {
        let calendar = Calendar.current
        let timeZone = TimeZone(identifier: "Europe/Paris")!
        var components = DateComponents()
        components.timeZone = timeZone

        // Get today's date components
        let today = calendar.startOfDay(for: Date())
        components.year = calendar.component(.year, from: today)
        components.month = calendar.component(.month, from: today)
        components.day = calendar.component(.day, from: today)

        // Get the opening and closing times' hour and minute
        components.hour = calendar.component(.hour, from: openingHour)
        components.minute = calendar.component(.minute, from: openingHour)
        let todayOpeningDate = calendar.date(from: components)!

        components.hour = calendar.component(.hour, from: closingHour)
        components.minute = calendar.component(.minute, from: closingHour)
        var todayClosingDate = calendar.date(from: components)!

        // Adjust for closing time on the next day
        if todayClosingDate < todayOpeningDate {
            todayClosingDate = calendar.date(byAdding: .day, value: 1, to: todayClosingDate)!
        }

        // Check if current time is within the opening hours
        let now = Date()
        if now >= todayOpeningDate && now <= todayClosingDate {
            let difference = calendar.dateComponents([.hour, .minute], from: now, to: todayClosingDate)
            let hours = difference.hour ?? 0
            let minutes = difference.minute ?? 0
            return "Closing in \(hours)h \(minutes)min"
        } else {
            let nextOpeningHour = now < todayOpeningDate ? todayOpeningDate : calendar.date(byAdding: .day, value: 1, to: todayOpeningDate)!
            let difference = calendar.dateComponents([.hour, .minute], from: now, to: nextOpeningHour)
            let hours = difference.hour ?? 0
            let minutes = difference.minute ?? 0
            return "Opening in \(hours)h \(minutes)min"
        }
    }

    
    func timeText(openingHour: Date, closingHour: Date, currentDate: Date) -> (String, Color) {
        let calendar = Calendar.current
        let timeZone = TimeZone(identifier: "Europe/Paris")!
        
        // Get the opening and closing times' hour and minute
        let openingHourComponent = calendar.component(.hour, from: openingHour)
        let openingMinuteComponent = calendar.component(.minute, from: openingHour)
        let closingHourComponent = calendar.component(.hour, from: closingHour)
        let closingMinuteComponent = calendar.component(.minute, from: closingHour)
        
        // Create Dates for today with the opening and closing hours and minutes
        var components = DateComponents()
        components.timeZone = timeZone
        components.year = calendar.component(.year, from: Date())
        components.month = calendar.component(.month, from: Date())
        components.day = calendar.component(.day, from: Date())
        
        components.hour = openingHourComponent
        components.minute = openingMinuteComponent
        let todayOpeningDate = calendar.date(from: components)!
        
        components.hour = closingHourComponent
        components.minute = closingMinuteComponent
        var todayClosingDate = calendar.date(from: components)!
        
        // Adjust for closing time on the next day
        if todayClosingDate < todayOpeningDate {
            todayClosingDate = calendar.date(byAdding: .day, value: 1, to: todayClosingDate)!
        }
        
//        print(todayOpeningDate)
//        print(todayClosingDate)
        
        // Check if current time is within opening hours
        let now = currentDate
//        print(now)
        if now >= todayOpeningDate && now <= todayClosingDate {
//            print("Open")
            return ("Open", Color("DarkGreen"))
        } else {
//            print("Close")
            return ("Close", Color.red)
        }
    }
}
