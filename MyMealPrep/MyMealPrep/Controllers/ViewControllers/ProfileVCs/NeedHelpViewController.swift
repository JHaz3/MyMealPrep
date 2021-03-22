//
//  NeedHelpViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 3/10/21.
//

import UIKit
import Firebase

class NeedHelpViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var updateEmailButton: UIButton!
    @IBOutlet weak var passwordResetButton: UIButton!
    @IBOutlet weak var emailTextField: UITextField!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        updateEmailButton.layer.cornerRadius = 15
        passwordResetButton.layer.cornerRadius = 15
        emailTextField.layer.cornerRadius = 15
        emailTextField.layer.borderColor = UIColor.black.cgColor
        emailTextField.layer.borderWidth = 3
        emailTextField.isHidden = true
    }
    
    // MARK: - Actions
//    @IBAction func passwordResetTapped(_ sender: Any) {
//        emailTextField.isHidden = false
//        if let email = !emailTextField.text!.isEmpty {
//            Auth.auth().sendPasswordReset(withEmail: email) { error in
//                // ...
//            }
//        }
//    }
    
    @IBAction func updateEmailTapped(_ sender: Any) {
        emailTextField.isHidden = false
    }
}
