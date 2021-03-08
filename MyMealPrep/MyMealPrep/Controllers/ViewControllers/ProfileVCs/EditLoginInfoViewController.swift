//
//  EditLoginInfoViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 3/2/21.
//

import UIKit
import Firebase

class EditLoginInfoViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var editEmailView: UIView!
    @IBOutlet weak var editEmailTextField: UITextField!
    @IBOutlet weak var editPasswordView: UIView!
    @IBOutlet weak var reEnterPasswordView: UIView!
    @IBOutlet weak var editPasswordTextField: UITextField!
    @IBOutlet weak var reEnterTextField: UITextField!
    @IBOutlet weak var saveButton: UIButton!
    
    // Mark: - Properties
    let db = Firestore.firestore()
    
    // Mark: - Lifecycle
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
                } else {
                    UserController.shared.updateEmail(withEmail: newEmail) { (_) in
                        self.successfulEmailUpdate()
                    }
                }
            })
        }
    }
    
    private func updateUsersPassword() {
        guard let newPassword = editPasswordTextField.text,
              let reEnteredPassword = reEnterTextField.text else {return}
        
        if !newPassword.isEmpty && !reEnteredPassword.isEmpty {
            if newPassword == reEnteredPassword {
                Auth.auth().currentUser?.updatePassword(to: newPassword, completion: { (error) in
                    if let error = error {
                        print("There was an error updating the user's password: \(error.localizedDescription)")
                    } else {
                        self.successfulPasswordUpdate()
                    }
                })
            } else {
                makeSurePasswordsMatchPopup()
            }
        } 
    }
    
    // Mark: - Actions
    @IBAction func saveButtonTapped(_ sender: Any) {
        updateUsersEmail()
        updateUsersPassword()
    }
    
    
    // Mark: - Popups
    private func fillOutAllFieldsPopup() {
        let alert = UIAlertController(title: "Wait!", message: "Make sure you have filled out all fields", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func makeSurePasswordsMatchPopup() {
        let alert = UIAlertController(title: "Hold up!", message: "Your passwords don't match", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Try again", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    private func successfulEmailUpdate() {
        let alert = UIAlertController(title: "Success!", message: "You successfully updated your username.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
    
    private func successfulPasswordUpdate() {
        let alert = UIAlertController(title: "Success!", message: "You successfully updated your password.", preferredStyle: .alert)
        present(alert, animated: true, completion: nil)
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            alert.dismiss(animated: true, completion: nil)
        }
        navigationController?.popViewController(animated: true)
    }
}
