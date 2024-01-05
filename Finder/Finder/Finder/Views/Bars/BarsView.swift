//
//  BarView.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 31/12/2023.
//

import SwiftUI

struct BarsView: View {
    @State private var searchText = ""
    @State private var bars: [BarWithUsers] = []
    @State private var filteredArray: [BarWithUsers] = []

    var body: some View {
        NavigationView {
            if !bars.isEmpty {
                VStack {
                    HStack{
                        AsyncImage(url: URL(string: "https://finder.thomas-dev.com/finderLogo.png")) {
                            image in image.resizable().aspectRatio(contentMode: .fit).frame(width: 150).padding(.horizontal, 30)
                        } placeholder: {
                            ProgressView()
                        }
                        
                        Spacer()
                        
                        Text("Bars").colorInvert().font(.system(size: 30, weight: .bold, design: .rounded)).padding(.trailing, 50).bold()
                    }
                    
                    Spacer()
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                        
                        Spacer()
                        
                        TextField("Search bar...", text: $searchText)
                            .onChange(of: searchText) { newValue in
                                filteredArray(with: newValue)
                            }
                    }
                    .foregroundColor(Color("DarkBlue")).font(.system(size: 17, weight: .bold, design: .rounded))
                    .padding(12)
                    .background(Color(.systemGray6))
                    .cornerRadius(8)
                    .padding(.top, 10)
                    .padding(.horizontal, 20)
                    
                    ScrollView {
                        ForEach(filteredArray) { bar in
                            NavigationLink(destination: EmptyView()) {
                                VStack(alignment: .center) {
                                    Text(bar.name).foregroundColor(.white).font(.system(size: 20, weight: .bold, design: .rounded)).padding(.vertical, 5)
                                    
                                    HStack {
                                        Image(systemName: "house.fill")
                                        Text(":")
                                        Text(bar.type)
                                        
                                        Spacer()
                                        
                                        Image(systemName: "person.3.fill")
                                        Text(":")
                                        Text(String(bar.usersInBar.count) + " / " + bar.capacity)
                                    }.padding(.horizontal, 10).padding(.vertical, 5)
                                    
                                    Text(bar.description).foregroundColor(Color("LightGreen")).padding(.horizontal, 10).padding(.vertical, 5)
                                }
                                .padding(12)
                                .frame(maxWidth: .infinity)
                                .background(Color("DarkBlue"))
                                .cornerRadius(10)
                                .shadow(radius: 5)
                            }
                        }
                    }
                    .foregroundColor(Color("LightBlue")).font(.system(size: 17, weight: .bold, design: .rounded))
                    .padding(20)
                }
                .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .onAppear {
                    fetchBars()
                    filteredArray = bars
                }
            } else {
                VStack {
                    ProgressView()
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(LinearGradient(gradient: Gradient(colors: [Color("Blue"), Color("LightBlue"), Color("Yellow"), Color("LightGreen")]), startPoint: .topLeading, endPoint: .bottomTrailing))
                .onAppear {
                    fetchBars()
                    filteredArray = bars
                }
            }
        }
    }

    private func filteredArray(with query: String) {
        if query.isEmpty {
            filteredArray = bars
        } else {
            filteredArray = bars.filter { $0.name.lowercased().contains(query.lowercased()) }
        }
    }
    
    private func fetchBars() {
        guard let url = URL(string: "http://127.0.0.1:5000/bars/users") else {
            print("Invalid URL")
            return
        }

        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                do {
                    let decodedResponse = try JSONDecoder().decode([BarWithUsers].self, from: data)
                    DispatchQueue.main.async {
                        self.bars = decodedResponse
                        print("Fetched \(self.bars.count) bars with users")
                    }
                } catch {
                    self.bars = []
                    self.filteredArray = []
                    print("Decoding error: \(error)")
                }
            } else {
                print("Fetch failed: \(error?.localizedDescription ?? "Unknown error")")
            }
        }
        task.resume()
    }
}
