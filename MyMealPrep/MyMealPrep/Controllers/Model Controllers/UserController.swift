//
//  UserController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/9/21.
//

import Foundation
import Firebase

class UserController {
    // MARK: - Properties
    static let shared = UserController()
    var currentUser: User?
    let db = Firestore.firestore()
    let userCollection = "users"
    
    // MARK: - CRUD
    func createAndSaveUser(username: String, password: String, completion: @escaping (Result<User,UserError>) -> Void ) {
        let newUser = User(username: username, password: password)
        
        let userRef = db.collection(userCollection)
        userRef.document("\(newUser.uuid)").setData([
            "username": "\(newUser.username)",
            "password": "\(newUser.password)"
        ]) { error in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                print("Document added with ID: \(newUser.uuid)")
                return completion(.success(newUser))
            }
        }
    }
    
    func fetchUser(username: String, password: String, completion: @escaping (Result<User, UserError>) -> Void) {
        let userRef = db.collection(userCollection)
        
        userRef.whereField("username", isEqualTo: username).whereField("password", isEqualTo: password).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error). - error getting user with username \(username))")
                return completion(.failure(.fireError(error)))
            } else {
                guard let doc = querySnapshot!.documents.first,
                      let fetchedUser = User(document: doc) else {
                    return completion(.failure(.couldNotUnwrap))
                }
                return completion(.success(fetchedUser))
            }
        }
    }
    
}// End of Class
