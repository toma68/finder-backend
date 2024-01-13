//
//  CustomError.swift
//  Finder
//
//  Created by Maxime CRAYSSAC on 11/01/2024.
//

import Foundation

enum CustomError: Error {
    case decodeError(String)
    case serverError(String)
    case encodeError
    case swiftError(String)

    var localizedDescription: String {
        switch self {
        case .decodeError(let message):
            return message
        case .serverError(let message):
            return message
        case .encodeError:
            return "Cannot encode data"
        case .swiftError(let message):
            return message
        }
    }
}
