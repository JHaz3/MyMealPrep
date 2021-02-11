//
//  SignUpViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/10/21.
//

import UIKit
import Firebase
import FirebaseAuth

class SignUpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    
    // MARK: - Properties
    static let db = Firestore.firestore()
    var statusIsSignUp = true
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        passwordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        emailTextField.delegate = self
        errorLabel.isHidden = true
        
        if Auth.auth().currentUser != nil {
            self.performSegue(withIdentifier: "showHomeScreen", sender: nil)
        }
    }
    
    // MARK: - Actions
    @IBAction func signUpButtonTapped(_ sender: Any) {
        guard let emailText = emailTextField.text, !emailText.isEmpty,
              let passwordText = passwordTextField.text, !passwordText.isEmpty else { return }
        
        if statusIsSignUp == true {
            guard let confirmPasswordText = confirmPasswordTextField.text,
                  passwordText == confirmPasswordText else { return }
            UserController.shared.createAndSaveUser(username: emailText, password: passwordText) { (result) in
                switch result {
                case.success(let user):
                    UserController.shared.currentUser = user
                    self.defaults.setValue(UserController.shared.currentUser?.username, forKey: "savedUsername")
                    self.toHomeScreen()
                case .failure(let userError):
                    print(userError.errorDescription)
                }
            }
        }
    }
    
    
    // MARK: - Methods
    private func validateFields() -> String? {
        if emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            confirmPasswordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "Please make sure your password contains at least 8 characters with at least 1 number and 1 unique character."
        }
        return nil
    }
    
    private func toHomeScreen() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
        
    }
    
    func tempBypassOfLoginScreen() {
        UserController.shared.fetchUser(username: "WheelTurns", password: "AgesComeAndPass") { (result) in
            switch result {
            case .success(let fetchedUser):
                UserController.shared.currentUser = fetchedUser
                self.toHomeScreen()
            case .failure(let userError):
                print(userError.errorDescription)
            }
        }
    }
    
}// End of Class

// MARK: - Extentions

extension SignUpViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
