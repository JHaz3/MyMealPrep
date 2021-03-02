//
//  SignUpAndInViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/18/21.
//

import UIKit
import Firebase

class SignUpAndInViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var loginImageView: UIImageView!
    @IBOutlet weak var welcomeLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var logInButton: UIButton!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var userNamePasswordStackView: UIStackView!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var enterPasswordTextField: UITextField!
    @IBOutlet weak var confirmPasswordTextField: UITextField!
    @IBOutlet weak var helpButton: UIButton!
    @IBOutlet weak var signUpSignInButton: UIButton!
    
    
    // MARK: - Properties
    let db = Firestore.firestore()
    var viewsLaidOut = false
    var statusIsSignUp = true
    let defaults = UserDefaults.standard
    
    // MARK: - Lifecycle Methods
    override func viewDidLoad() {
        super.viewDidLoad()
        enterPasswordTextField.delegate = self
        confirmPasswordTextField.delegate = self
        usernameTextField.delegate = self
        
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            self.setupViews()
            viewsLaidOut = true
            self.checkForUser()
        }
    }
    
    // MARK: - Actons
    @IBAction func logInButtonTapped(_ sender: Any) {
        if let username = defaults.value(forKey: "savedUsername") as? String {
            toggleToLogin(username: username)
        } else {
            toggleToLogin(username: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
    }
    
    @IBAction func signUpSignInButtonTapped(_ sender: Any) {
        guard let usernameText = usernameTextField.text, !usernameText.isEmpty,
              let passwordText = enterPasswordTextField.text, !passwordText.isEmpty else { return }
        
        if statusIsSignUp == true {
            guard let confirmPasswordText = confirmPasswordTextField.text,
                  passwordText == confirmPasswordText else { return }
            UserController.shared.createAndSaveUser(username: usernameText, password: passwordText) { (result) in
                switch result {
                case.success(let user):
                    UserController.shared.currentUser = user
                    self.defaults.setValue(UserController.shared.currentUser?.username, forKey: "savedUsername")
                    self.tabBarSetUp()
                case .failure(let userError):
                    print(userError.errorDescription)
                }
            }
        } else {
            UserController.shared.fetchUser(username: usernameText, password: passwordText) { (result) in
                switch result {
                case .success(let fetchedUser):
                    UserController.shared.currentUser = fetchedUser
                    self.defaults.set(UserController.shared.currentUser?.username, forKey: "savedUsername")
                    self.tabBarSetUp()
                case .failure(let userError):
                    print(userError.errorDescription)
                    
                }
            }
        }
    }
    
    // MARK: - Methods
    private func checkForUser() {
        guard let username = defaults.value(forKey: "savedUsername") as? String else { return }
        
        toggleToLogin(username: username)
    }
    
    private func toggleToLogin(username: String?) {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.statusIsSignUp = false
                self.confirmPasswordTextField.isHidden = true
                self.userNamePasswordStackView.spacing = 24
                self.signUpSignInButton.setTitle("Sign In", for: .normal)
                self.usernameTextField.text = ""
                self.enterPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
                self.usernameTextField.becomeFirstResponder()
            }
        }
    }
    
    private func toggleToSignUp() {
        DispatchQueue.main.async {
            UIView.animate(withDuration: 0.2) {
                self.statusIsSignUp = true
                self.userNamePasswordStackView.spacing = 8
                self.userNamePasswordStackView.alignment = .fill
                self.confirmPasswordTextField.isHidden = false
                self.signUpSignInButton.setTitle("Sign Up", for: .normal)
                self.usernameTextField.text = ""
                self.enterPasswordTextField.text = ""
                self.confirmPasswordTextField.text = ""
            }
        }
    }
    
    private func toHomeScreen() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "HomeScreen", bundle: nil)
            guard let viewController = storyboard.instantiateInitialViewController() else { return }
            viewController.modalPresentationStyle = .fullScreen
            self.present(viewController, animated: true, completion: nil)
        }
    }
    
    // MARK: -
    private func transitionToHome() {
        performSegue(withIdentifier: "tabBarController", sender: self)
    }
    
    private func tabBarSetUp() {
        let sb = UIStoryboard(name: "Main", bundle: nil)
        let tabBar = sb.instantiateViewController(identifier: "tabBarController")
        tabBar.modalPresentationStyle = .fullScreen
        present(tabBar, animated: true)
    }
    
    func setupViews() {
        loginImageView.clipsToBounds = true
        enterPasswordTextField.isSecureTextEntry = true
        confirmPasswordTextField.isSecureTextEntry = true
    }
    
}// End of Class

extension SignUpAndInViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
