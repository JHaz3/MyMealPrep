//
//  UserError.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/9/21.
//

import Foundation

enum UserError: LocalizedError {
    case fireError(Error)
    case couldNotUnwrap
    
    var errorDescription: String {
        switch self {
        case .fireError(let error):
            return error.localizedDescription
        case .couldNotUnwrap:
            return "Unable to get a user from the data found."
        }
    }
}
