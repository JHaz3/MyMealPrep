//
//  SignInViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/10/21.
//

import UIKit
import Firebase

class SignInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    private let db = Firestore.firestore()
    var statusIsSignIn = true
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        errorLabel.isHidden = true
    }
    
    // MARK: - Actions
    @IBAction func signInButtonTapped(_ sender: Any) {
        guard let usernameText = emailTextField.text, !usernameText.isEmpty,
              let passwordText = passwordTextField.text, !passwordText.isEmpty else { return }
        
        if statusIsSignIn == true {
            UserController.shared.fetchUser(username: usernameText, password: passwordText) { (result) in
                switch result {
                case .success(let fetchedUser):
                    UserController.shared.currentUser = fetchedUser
                    self.defaults.set(UserController.shared.currentUser?.username, forKey: "savedUsername")
                    self.transitionToHome()
                case .failure(let userError):
                    print(userError.errorDescription)
                    
                }
            }
        }
    }
    // MARK: - Methods
    private func toHomeScreen() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        
    }
    private func transitionToHome() {
        performSegue(withIdentifier: "toTabBarController", sender: self)
    }
    
}// End of Class
