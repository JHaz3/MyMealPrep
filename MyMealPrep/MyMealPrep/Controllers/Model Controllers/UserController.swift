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
    func createUser(user: User, completion: @escaping (Result<User?, UserError>) -> Void) {
        let userDict: [String : Any] = [Constants.email : user.email,
                                        Constants.password : user.password]
        
        db.collection(Constants.users).document(user.uuid).setData(userDict) { (error) in
            if let error = error {
                print("There was an error creating a user: \(error.localizedDescription)")
            } else {
                completion(.success(user))
            }
        }
//        db.collection(Constants.users).document(user.uuid).addDocument(data: userDict) { (error) in
//            if let error = error {
//                print("There was an error creating a user: \(error.localizedDescription)")
//            } else {
//                let
//                let user = User(email: email, password: password)
//                completion(.success(user))
//            }
//        }
    }
    
    func fetchUserWithEmail(withEmail email: String, completion: @escaping (Result<User?, UserError>) -> Void) {
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
    
    func fetchUserWithPassword(withPassword password: String, completion: @escaping (Result<User, UserError>) -> Void) {
        db.collection(Constants.users).whereField(Constants.password, isEqualTo: password).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching users: \(error.localizedDescription)")
            } else if let firstDocument = snapshot?.documents.first {
                guard let user = User(dictionary: firstDocument.data()) else {return}
                completion(.success(user))
            }
        }
    }
    
    func updateEmail(withEmail email: String, completion: @escaping (String) -> Void) {
        guard let currentUser = self.currentUser else {return}
        self.fetchUserWithEmail(withEmail: currentUser.email) { (result) in
            switch result {
            case .failure(let error):
                print("There was an error fetching the user in Firestore: \(error.localizedDescription)")
            case .success(let user):
                guard let user = user else {return}
                self.db.collection(Constants.users).document(user.uuid).updateData([Constants.email : email])
            }
        }
    }
    
    func updatePassword(withPassword password: String, completion: @escaping (String) -> Void) {
        self.fetchUserWithPassword(withPassword: password) { (result) in
            switch result {
            case .failure(let error):
                print("There was an error fetching the user in Firestore: \(error.localizedDescription)")
            case .success(let user):
//                guard let user = user else {return}
                self.db.collection(Constants.users).document(user.uuid).updateData([Constants.password : password])
            }
        }
    }
    
}// End of Class
