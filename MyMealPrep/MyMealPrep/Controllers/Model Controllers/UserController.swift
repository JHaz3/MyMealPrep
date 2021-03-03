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
    
    // MARK: - CRUD
    func createUser(email: String, password: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        let userDict: [String : Any] = [Constants.email : email,
                                        Constants.password : password]
        db.collection(Constants.users).addDocument(data: userDict) { (error) in
            if let error = error {
                print("There was an error creating a user: \(error.localizedDescription)")
            } else {
                let user = User(email: email, password: password)
                completion(.success(user))
            }
        }
    }
    
    func fetchUser(withEmail email: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        db.collection(Constants.users).whereField(Constants.email, isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching users: \(error.localizedDescription)")
            } else if let firstDocument = snapshot?.documents.first {
                guard let user = User(dictionary: firstDocument.data()) else {return}
                completion(.success(user))
            } else {
                completion(.success(nil))
            }
        }
    }
    
}// End of Class
