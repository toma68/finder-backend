//
//  UserService.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation

class UserService {
    // Function to update a user
    func updateUser(userId: String, updatedUserData: UserData, completion: @escaping (Result<User, Error>) -> Void) {
            guard let url = URL(string: API_URL + "/users/update") else {
                completion(.failure(URLError(.badURL)))
                return
            }

            var request = URLRequest(url: url)
            request.httpMethod = "PUT"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")

            do {
                let jsonData = try JSONEncoder().encode(updatedUserData)
                request.httpBody = jsonData
            } catch {
                completion(.failure(error))
                return
            }

            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    completion(.failure(CustomError.serverError("HTTP Request Failed \(error)")))
                }
    
                if let httpResponse = response as? HTTPURLResponse, let data = data {
                    let decoder = JSONDecoder()
                    if httpResponse.statusCode != 200 {
                        if let apiResponse = try? decoder.decode(ApiResponse.self, from: data) {
                            completion(.failure(CustomError.serverError("\(apiResponse.message ?? "Unknown error")")))
                            print("\(apiResponse.message ?? "Unknown error")")
                        } else {
                            completion(.failure(CustomError.decodeError("Failed to decode error response")))
                            print("Failed to decode error response")
                        }
                    } else {
                        do {
                            let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                            completion(.success(loggedInUser))
                        } catch {
                            completion(.failure(CustomError.decodeError("Failed to decode user data")))
                            print("Decoding error: \(error)")
                        }
                    }
                }
            }.resume()
        }
    
    // Function to get user infos
    func getInfosUser(userId: UserId, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: API_URL + "/users?user_id=\(userId.id)") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let data = data else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            do {
                let user = try JSONDecoder().decode(User.self, from: data)
                completion(.success(user))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Function to login a user
    func loginUser(name: String, surname: String, completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: API_URL + "/users/login") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        let loginDetails = ["name": name, "surname": surname]
        guard let jsonData = try? JSONEncoder().encode(loginDetails) else {
            completion(.failure(CustomError.encodeError))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(CustomError.swiftError("Error: \(error)")))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse, let data = data else {
                completion(.failure(CustomError.serverError("Internal error")))
                return
            }

            if httpResponse.statusCode == 200 {
                do {
                    let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(loggedInUser))
                } catch {
                    completion(.failure(CustomError.decodeError("Decode error")))
                }
            } else if httpResponse.statusCode == 401 {
                completion(.failure(CustomError.serverError("Wrong name or surname")))
            } else {
                completion(.failure(CustomError.serverError("Internal error")))
            }
        }.resume()
    }
    
    // Function to signup a user
    func signupUser(userData: [String: Any], completion: @escaping (Result<User, Error>) -> Void) {
        guard let url = URL(string: API_URL + "/users/signup") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        guard let jsonData = try? JSONSerialization.data(withJSONObject: userData, options: []) else {
            completion(.failure(CustomError.swiftError("Error in JSON serialization")))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = jsonData

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(CustomError.swiftError("HTTP Request Failed \(error)")))
                print("HTTP Request Failed \(error)")
                return
            }

            if let httpResponse = response as? HTTPURLResponse {
                if httpResponse.statusCode != 200 {
                    if let data = data {
                        let decoder = JSONDecoder()
                        if let apiResponse = try? decoder.decode(ApiResponse.self, from: data) {
                            completion(.failure(CustomError.serverError(apiResponse.message ?? "Unknown error")))
                            print("Error Message: \(apiResponse.message ?? "Unknown error")")
                        } else {
                            completion(.failure(CustomError.decodeError("Failed to decode response")))
                            print("Failed to decode response")
                        }
                    }
                    return
                }
            }

            if let data = data, let responseString = String(data: data, encoding: .utf8) {
                print("Response: \(responseString)")
                do {
                    let loggedInUser = try JSONDecoder().decode(User.self, from: data)
                    completion(.success(loggedInUser))
                } catch {
                    completion(.failure(CustomError.decodeError("Failed to decode user data")))
                    print("Decoding error: \(error)")
                }
            }
        }.resume()
    }
    
    // Function to fetch users
    func fetchUsers(completion: @escaping (Result<[User], Error>) -> Void) {
        guard let url = URL(string: API_URL + "/users") else {
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
                let users = try JSONDecoder().decode([User].self, from: data)
                completion(.success(users))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Function to fetch bar data from an user
    func fetchBarData(forUserId userId: String, completion: @escaping (Result<BarWithUsers, Error>) -> Void) {
        guard let url = URL(string: API_URL + "/bars/users?_id=\(userId)") else {
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
                let barData = try JSONDecoder().decode(BarWithUsers.self, from: data)
                completion(.success(barData))
            } catch {
                completion(.failure(error))
            }
        }.resume()
    }
    
    // Function to update a user bar
    func updateUserBarId(userId: String, barId: String?, completion: @escaping (Result<Bool, Error>) -> Void) {
        guard let url = URL(string: API_URL + "/users/update-bar") else {
            completion(.failure(URLError(.badURL)))
            return
        }

        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let body: [String: Any] = ["user_id": userId, "new_bar_id": barId as Any]
        request.httpBody = try? JSONSerialization.data(withJSONObject: body)

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
                completion(.failure(error))
                return
            }

            guard let httpResponse = response as? HTTPURLResponse else {
                completion(.failure(URLError(.badServerResponse)))
                return
            }

            if httpResponse.statusCode == 200 {
                completion(.success(true))
            } else {
                completion(.failure(URLError(.badServerResponse)))
            }
        }.resume()
    }
}
