//
//  EditLoginInfoViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 3/2/21.
//

import UIKit
import Firebase

class EditLoginInfoViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var editEmailView: UIView!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editPasswordView: UIView!
    @IBOutlet weak var reEnterPasswordView: UIView!
    @IBOutlet weak var editPasswordTextField: UITextField!
    @IBOutlet weak var reEnterTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // MARK: - Properties
    let db = Firestore.firestore()
    var reAuthEmail: String?
    var reAuthPass: String?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        editEmailView.layer.borderWidth = 0.5
        editEmailView.layer.borderColor = UIColor.lightGray.cgColor
        editEmailView.layer.cornerRadius = 25
        editPasswordView.layer.borderWidth = 0.5
        editPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        editPasswordView.layer.cornerRadius = 25
        reEnterPasswordView.layer.borderWidth = 0.5
        reEnterPasswordView.layer.borderColor = UIColor.lightGray.cgColor
        reEnterPasswordView.layer.cornerRadius = 25
        saveButton.layer.cornerRadius = 15
    }
    
    func updateUsersEmail() {
        guard let newEmail = editEmailTextField.text else {return}
        if !newEmail.isEmpty {
            Auth.auth().currentUser?.updateEmail(to: newEmail, completion: { (error) in
                if let error = error {
                    print("There was an error updating user's email: \(error.localizedDescription)")
                    self.reAuthUser()
                } else {
                    self.editInfoPopup(title: "Success!", message: "You successfully updated your email", actionTitle: "OK")
                    self.editEmailTextField.text = ""
                    UserController.shared.updateEmail(withEmail: newEmail) { (_) in
                        print("Successful email update!")
                    }
                }
            })
        }
    }
    
    private func updateUsersPassword() {
        guard let newPassword = editPasswordTextField.text,
              let reEnteredPassword = reEnterTextField.text else {return}
        
        if !newPassword.isEmpty && reEnteredPassword.isEmpty || newPassword.isEmpty && !reEnteredPassword.isEmpty {
            editInfoPopup(title: "Hold Up!", message: "Please make sure you have entered AND retyped a new password", actionTitle: "OK")
        } else if newPassword != reEnteredPassword {
            editInfoPopup(title: "Error", message: "Your passwords don't match. Try again.", actionTitle: "OK")
        } else if !newPassword.isEmpty && !reEnteredPassword.isEmpty {
            if newPassword == reEnteredPassword {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    if let error = error {
                        print("There was an error updating the user's password: \(error.localizedDescription)")
                        self.reAuthUser()
                    } else {
                        self.editInfoPopup(title: "Success!", message: "You successfully updated your password", actionTitle: "OK")
                        self.editPasswordTextField.text = ""
                        self.reEnterTextField.text = ""
                        UserController.shared.updatePassword(withPassword: newPassword) { (_) in
                            print("Successful password update!")
                        }
                    }
                })
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateUsersEmail()
        updateUsersPassword()
    }
    
    // MARK: - Popups
    private func editInfoPopup(title: String, message: String, actionTitle: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: actionTitle, style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func reAuthUser() {
        let alert = UIAlertController(title: "", message: "Please re-enter your login again so we can update your info.", preferredStyle: .alert)
        
        alert.addTextField { (emailTextField) in
            emailTextField.delegate = self
            emailTextField.placeholder = "Type email here..."
            self.reAuthEmail = emailTextField.text
        }
        
        alert.addTextField { (passwordTextField) in
            passwordTextField.delegate = self
            passwordTextField.placeholder = "Type password here..."
            self.reAuthPass = passwordTextField.text
        }
        
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            guard let email = alert.textFields?.first?.text, !email.isEmpty,
                  let password = alert.textFields?.last?.text, !password.isEmpty else {return}

            let credential: AuthCredential = EmailAuthProvider.credential(withEmail: email, password: password)
            Auth.auth().currentUser?.reauthenticate(with: credential, completion: { (result, error) in
                if let error = error {
                    print(error.localizedDescription)
                    self.editInfoPopup(title: "Error", message: "Are you sure those credentials are accurate?", actionTitle: "Try Again")
                    print("Password: \(password), Email: \(email)")
                } else {
                    print("Successfully re-authenticated user")
                }
            })
        }
        alert.addAction(okAction)
        present(alert, animated: true)
    }
}

extension EditLoginInfoViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}
