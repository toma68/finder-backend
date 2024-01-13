//
//  SignupViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation

class SignupViewModel: ObservableObject {
    private var userService: UserService = UserService()
    
    @Published var surname: String = ""
    @Published var name: String = ""
    @Published var company: String = ""
    @Published var bio: String = ""
    @Published var photo: String = ""
    @Published var gender: Int = 1
    @Published var loginStatusMessage: String = ""
    
    var items: [CheckboxItem]

    init(items: [CheckboxItem]) {
        self.items = items
    }

    func signup(with globalUser: GlobalUser) {
        let userData = [
            "surname": surname,
            "name": name,
            "company": company,
            "bio": bio,
            "photo": photo,
            "gender": items[gender - 1].value
        ]

        userService.signupUser(userData: userData) { [weak self] result in
            DispatchQueue.main.async {
                switch result {
                case .success(let user):
                    globalUser.userId = UserId(id: user.id)
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
