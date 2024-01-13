//
//  BarRowViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 13/01/2024.
//

import SwiftUI

struct BarNameView: View {
    var bar: BarWithUsers

    var body: some View {
        Text(bar.name)
            .foregroundColor(.white)
            .font(.system(size: 20, weight: .bold, design: .rounded))
            .padding(.vertical, 5)
    }
}

struct BarInfoView: View {
    var bar: BarWithUsers
    
    var body: some View {
        HStack {
            Image(systemName: "house.fill")
            Text(":")
            Text(bar.type)
            
            Spacer()
            
            Image(systemName: "person.3.fill")
            Text(":")
            Text("\(bar.usersInBar.count) / \(bar.capacity)")
        }
        .padding(5)
    }
}

struct BarHoursView: View {
    var bar: BarWithUsers
    var viewModel: BarRowViewModel
    
    @State private var currentTime = Date()

    let timer = Timer.publish(every: 60, on: .main, in: .common).autoconnect()

    
    var body: some View {
        HStack {
            HStack {
                Image(systemName: "clock")
                Text(":")
                Text("\(viewModel.getHour(date: bar.opening_hour))h\(viewModel.getMinutes(date: bar.opening_hour)) - \(viewModel.getHour(date: bar.closing_hour))h\(viewModel.getMinutes(date: bar.closing_hour))")
                Spacer()
            }.foregroundColor(Color("LightGreen"))

            Spacer()

            HStack {
                Text("\(viewModel.timeText(openingHour: bar.opening_hour, closingHour: bar.closing_hour, currentDate: currentTime).text)")
            }.foregroundColor(viewModel.timeText(openingHour: bar.opening_hour, closingHour: bar.closing_hour, currentDate: currentTime).color)
        }
        .padding(5)
        .onReceive(timer) { _ in
            currentTime = Date()
        }
        .onAppear {
            currentTime = Date()
        }

        HStack {
            Spacer()
            Text("\(viewModel.timeStatus(openingHour: bar.opening_hour, closingHour: bar.closing_hour))")
            Spacer()
        }
        .foregroundColor(Color("Yellow"))
        .frame(maxWidth: .infinity)
        .padding(5)
    }
}

struct BarPaymentAndPriceView: View {
    var bar: BarWithUsers
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0..<bar.payment_method.count, id: \.self) { elt in
                Image(systemName: bar.payment_method[elt])
                    .scaledToFill()
                    .clipped()
            }
            
            Spacer()
            
            ForEach(0..<bar.average_price, id: \.self) { _ in
                Image(systemName: "eurosign")
                    .scaledToFill()
                    .clipped()
            }
            
            if bar.average_price < 5 {
                ForEach(0..<(5 - bar.average_price), id: \.self) { _ in
                    Image(systemName: "eurosign")
                        .scaledToFill()
                        .opacity(0.5)
                        .clipped()
                }
            }
        }
        .padding(5)
        .foregroundColor(Color("Orange"))
    }
}


struct BarRowView: View {
    @StateObject private var viewModel = BarRowViewModel()
    var bar: BarWithUsers
    var switchToMap: (BarWithUsers) -> Void
    var switchToUser: (User) -> Void

    var body: some View {
        NavigationLink(destination: BarView(selectedBar: bar, switchToMap: switchToMap, switchToUser: switchToUser, isClear: false)) {
            VStack(alignment: .center) {
                BarNameView(bar: bar)
                BarInfoView(bar: bar)
                BarHoursView(bar: bar, viewModel: viewModel)
                BarPaymentAndPriceView(bar: bar)
            }
            .padding(12)
            .frame(maxWidth: .infinity)
            .background(Color("DarkBlue"))
            .cornerRadius(10)
            .shadow(radius: 2)
        }
    }
}
