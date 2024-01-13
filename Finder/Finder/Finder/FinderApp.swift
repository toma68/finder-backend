//
//  FinderApp.swift
//  Finder
//
//  Created by becher thomas on 15/12/2023.
//

import SwiftUI

@main
struct FinderApp: App {
    var globalUser = GlobalUser()
    
    var body: some Scene {
        WindowGroup {
            NavBarView().environmentObject(globalUser)
        }
    }
}
