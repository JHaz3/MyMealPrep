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
        editLoginButton.layer.borderWidth = 0.5
        contactUsButton.layer.borderWidth = 0.5
        shareButton.layer.borderWidth = 0.5
        logoutButton.layer.borderWidth = 0.5
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
    
    // Mark: - Actions
    @IBAction func logoutButtonTapped(_ sender: Any) {
        let firebaseAuth = Auth.auth()
        
        do {
            try firebaseAuth.signOut()
            self.presentLoginScreen()
        } catch let signOutError as NSError {
            print("Error signing out: %@", signOutError)
        }
    }
    
    private func presentLoginScreen() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let toLogin = sb.instantiateViewController(identifier: "signUpAndInVC")
        toLogin.modalPresentationStyle = .fullScreen
        present(toLogin, animated: true)
    }
    
}
