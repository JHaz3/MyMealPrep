//
//  ProfileViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit
import Firebase

class ProfileViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var editLoginButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    
    // Mark: - Properties
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        rotateArrows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Mark: - Actions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            let viewcontroller = SignInViewController()
            navigationController?.popToViewController(viewcontroller, animated: true)
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
}
