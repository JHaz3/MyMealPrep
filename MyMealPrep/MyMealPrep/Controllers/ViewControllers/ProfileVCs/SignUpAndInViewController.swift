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
        toggleToSignUp()
        if Auth.auth().currentUser != nil {
            guard let userEmail = Auth.auth().currentUser?.email else {return}
            UserController.shared.fetchUserWithEmail(withEmail: userEmail) { (result) in
                switch result {
                case .failure(let error):
                    print(error.localizedDescription)
                case .success(let user):
                    if let user = user {
                        UserController.shared.currentUser = user
                        self.toTabBar()
                    }
                }
            }
        }
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        if viewsLaidOut == false {
            self.setupViews()
            viewsLaidOut = true
            //            self.checkForUser()
        }
    }
    
    // MARK: - Actons
    @IBAction func logInButtonTapped(_ sender: Any) {
        //        isOnLogin = true
        if let username = defaults.value(forKey: "savedUsername") as? String {
            toggleToLogin(username: username)
        } else {
            toggleToLogin(username: nil)
        }
    }
    
    @IBAction func signUpButtonTapped(_ sender: Any) {
        toggleToSignUp()
        //        isOnLogin = false
    }
    
    @IBAction func signUpSignInButtonTapped(_ sender: Any) {
        guard let email = usernameTextField.text, !email.isEmpty,
              let password = enterPasswordTextField.text, !password.isEmpty else { return }
        
        if statusIsSignUp == false {
            if self.isValidEmail(email) {
                UserController.shared.fetchUserWithEmail(withEmail: email) { (result) in
                    switch result {
                    case .success(let user):
                        if let user = user {
                            if password == user.password {
                                if email == user.email {
                                    // There was a user in firebase
                                    UserController.shared.currentUser = user
                                    Auth.auth().signIn(withEmail: email, password: password) { (dataResult, error) in
                                        if let error = error {
                                            print("Error signing user in: \(error.localizedDescription)")
                                        } else {
                                            self.toTabBar()
                                        }
                                    }
                                } else {
                                    self.errorPopup(title: "Whoops", message: "Your email and password don't match. Try again.")
                                }
                            } else {
                                self.errorPopup(title: "Whoops", message: "Your email and password don't match. Try again.")
                            }
                        } else {
                            self.errorPopup(title: "Hold up!", message: "I couldn't find an account with that email. Try again or tap Sign Up")
                        }
                    case .failure(let error):
                        print("There was an error fetching a user: \(error.localizedDescription)")
                    }
                    
                }
            } else {
                self.errorPopup(title: "Whoops", message: "That isn't a valid email. Try again!")
            }
        } else {
            UserController.shared.fetchUserWithEmail(withEmail: email) { (result) in
                switch result {
                case .success(let user):
                    if let user = user {
                        self.errorPopup(title: "Whoops", message: "It looks like there is already an account with this email.")
                        print("\(user.email) already exists")
                    } else {
                        Auth.auth().createUser(withEmail: email, password: password) { (authResult, error) in
                            if let error = error {
                                print("Error creating user: \(error.localizedDescription)")
                                self.errorPopup(title: "Whoops", message: "Make sure your password is at least 6 characters.")
                            } else {
                                if self.isValidEmail(email) {
                                    if self.isValidPassword(password) {
                                        let user = User(email: email, password: password)
                                        UserController.shared.createUser(user: user) { (result) in
                                            switch result {
                                            case .success(let user):
                                                UserController.shared.currentUser = user
                                                self.toTabBar()
                                            case .failure(let error):
                                                print("Error creating a user in cloudFirestore: \(error.localizedDescription)")
                                            }
                                        }
                                    } else {
                                        self.errorPopup(title: "Whoops", message: "Make sure your password is at least 6 characters.")
                                    }
                                } else {
                                    self.errorPopup(title: "Whoops", message: "That isn't a valid email. Try again!")
                                }
                            }
                        }
                    }
                case .failure(let error):
                    print("Error fetching user in sign up: \(error.localizedDescription)")
                }
            }
        }
    }
    
    private func errorPopup(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func isValidEmail(_ email: String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPred = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailPred.evaluate(with: email)
    }
    
    func isValidPassword(_ password: String) -> Bool {
        let minPasswordLength = 6
        return password.count >= minPasswordLength
    }
    
    // MARK: - Methods
    //    private func checkForUser() {
    //        guard let username = defaults.value(forKey: "savedUsername") as? String else { return }
    //
    //        toggleToLogin(username: username)
    //    }
    
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
    
    private func toTabBar() {
        DispatchQueue.main.async {
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let tabBar = storyboard.instantiateViewController(identifier: "tabBarController")
            tabBar.modalPresentationStyle = .fullScreen
            self.present(tabBar, animated: true)
        }
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
