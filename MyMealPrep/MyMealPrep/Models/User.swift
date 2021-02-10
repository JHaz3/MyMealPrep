//
//  User.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/9/21.
//

import Foundation
import Firebase

class User {
    var username: String
    var password: String
    var uuid: String
    
    init(username: String, password: String, uuid: String = UUID().uuidString) {
        self.username = username
        self.password = password
        self.uuid = uuid
    }
    
    convenience init?(document: DocumentSnapshot) {
        
        guard let username = document["username"] as? String,
              let password = document["password"] as? String else { return nil }
        
        self.init(username: username, password: password, uuid: document.documentID)
    }
    
}// End of Class
