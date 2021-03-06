//
//  RecipeError.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/10/21.
//

import Foundation

enum RecipeError: LocalizedError {
    case thrown(Error)
    case invalidURL
    case noData
    case badData
    case unableToDelete
    case fireError(Error)
    case couldNotUnwrap
    
    var errorDescription: String? {
        switch self {
        case .thrown(let error):
            return error.localizedDescription
        case .invalidURL:
            return "Unable to reach server"
        case .noData:
            return "Server responded with no data."
        case .badData:
            return "Server responded with bad data."
        case .unableToDelete:
            return "Mission Failed"
        case .fireError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get this Recipe."
        }
    }
}
