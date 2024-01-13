//
//  LoginViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import SwiftUI
import Combine

class LoginViewModel: ObservableObject {
    private var userService: UserService = UserService()
    
    @Published var surname: String = "";
    @Published var name: String = "";
    
    @Published var loginStatusMessage: String = ""
    
    var items: [CheckboxItem]

    init(items: [CheckboxItem]) {
        self.items = items
    }
    
    func loginUser(with globalUser: GlobalUser) {
        userService.loginUser(name: name, surname: surname) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let loggedInUser):
                    globalUser.userId = UserId(id: loggedInUser.id)
                case .failure(let error):
                    switch error {
                    case let customError as CustomError:
                        DispatchQueue.main.async {
                            print("Error: \(customError.localizedDescription)")
                            self?.loginStatusMessage = customError.localizedDescription
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self?.loginStatusMessage = ""
                            }
                        }
                    default:
                        DispatchQueue.main.async {
                            print("Error: \(error.localizedDescription)")
                            self?.loginStatusMessage = error.localizedDescription
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                                self?.loginStatusMessage = ""
                            }
                        }
                    }
                }
            }
        }
    }
}
