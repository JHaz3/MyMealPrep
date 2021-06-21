//
//  User.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/9/21.
//

import Foundation
import Firebase

class User {
    var email: String
    var password: String
    var uuid: String
    
    init(email: String, password: String, uuid: String = UUID().uuidString) {
        self.email = email
        self.password = password
        self.uuid = uuid
    }
    
    convenience init?(document: DocumentSnapshot) {
        
        guard let email = document["email"] as? String,
              let password = document["password"] as? String else { return nil }
        
        self.init(email: email, password: password, uuid: document.documentID)
    }
    
}// End of Class

extension User: Equatable {
    static func == (lhs: User, rhs: User) -> Bool {
        return lhs.email == rhs.email
            && lhs.password == rhs.password
            && lhs.uuid == lhs.uuid
    }
}

extension User {
    convenience init?(dictionary: [String : Any]) {
        guard let email = dictionary[Constants.email] as? String,
              let password = dictionary[Constants.password] as? String else { return nil }
        self.init(email: email, password: password)
    }
}
