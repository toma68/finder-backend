//
//  UserEditViewModel.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import SwiftUI
import Combine

class UserEditViewModel: ObservableObject {
    private var userService: UserService = UserService()
    
    var globalUser: GlobalUser?
    
    @Published var user: User? = nil
    @Published var userData: UserData = UserData(userId: "", surname: "", name: "", company: "", bio: "", photo: "")
    
    @Published var loginStatusMessage: String = ""
    @Published var loginStatusColor: Color = .red
    
    func updateUser() {
        userService.updateUser(userId: userData.userId, updatedUserData: userData) { [weak self] result in
            guard let self = self else { return }
            
            switch result {
            case .success(let updatedUser):
                DispatchQueue.main.async {
                    self.userData.userId = updatedUser.id
                    self.userData.name = updatedUser.name
                    self.userData.surname = updatedUser.surname
                    self.userData.company = updatedUser.company
                    self.userData.bio = updatedUser.bio
                    
                    self.loginStatusColor = Color("DarkBlue")
                    self.loginStatusMessage = "Updated successfully"
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        self.loginStatusMessage = ""
                        self.loginStatusColor = .red
                    }
                }
            case .failure(let error):
                switch error {
                case let customError as CustomError:
                    DispatchQueue.main.async {
                        print("Error: \(customError.localizedDescription)")
                        self.loginStatusMessage = customError.localizedDescription
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loginStatusMessage = ""
                            self.loginStatusColor = .red
                        }
                    }
                default:
                    DispatchQueue.main.async {
                        print("Error: \(error.localizedDescription)")
                        self.loginStatusMessage = error.localizedDescription
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loginStatusMessage = ""
                            self.loginStatusColor = .red
                        }
                    }
                }
                
            }
        }
    }
    
    func setup(globalUser: GlobalUser) {
        self.globalUser = globalUser
        getUserInfos()
    }

    
    func getUserInfos() {
        if let globalUser = globalUser, let userInfos = globalUser.userId {
            userService.getInfosUser(userId: userInfos) { [weak self] result in
                guard let self = self else { return }

                switch result {
                case .success(let updatedUser):
                    DispatchQueue.main.async {
                        self.userData.userId = updatedUser.id
                        self.userData.name = updatedUser.name
                        self.userData.surname = updatedUser.surname
                        self.userData.company = updatedUser.company
                        self.userData.bio = updatedUser.bio
                    }
                case .failure(let error):
                    DispatchQueue.main.async {
                        self.loginStatusMessage = error.localizedDescription
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                            self.loginStatusMessage = ""
                            self.loginStatusColor = .red
                        }
                    }
                }
            }
        }
    }
}
