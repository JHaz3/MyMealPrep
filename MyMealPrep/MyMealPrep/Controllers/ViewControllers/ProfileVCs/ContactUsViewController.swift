//
//  ContactUsViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 3/22/21.
//

import UIKit
import MessageUI

class ContactUsViewController: UIViewController, MFMailComposeViewControllerDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var subjectLineTextField: UITextField!
    @IBOutlet weak var emailBodyTextView: UITextView!
    @IBOutlet weak var sendButton: UIButton!
    
    // MARK: - Properties
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        emailBodyTextView.layer.borderWidth = 1
        emailBodyTextView.layer.borderColor = UIColor.black.cgColor
        subjectLineTextField.layer.borderWidth = 1
        subjectLineTextField.layer.borderColor = UIColor.black.cgColor
        sendButton.layer.borderWidth = 1
        sendButton.layer.cornerRadius = 10
    }
    
    private func sendEmail() {
        if MFMailComposeViewController.canSendMail() {
            let mail = MFMailComposeViewController()
            mail.setToRecipients(["MyMealPrepApp@gmail.com"])
            mail.setSubject(subjectLineTextField.text ?? "")
            mail.setMessageBody(emailBodyTextView.text, isHTML: true)
            present(mail, animated: true)
        } else {
            failedToSendEmailPopup()
        }
    }
    
    func failedToSendEmailPopup() {
        let alert = UIAlertController(title: "Error", message: "There was an error sending your email. Please try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
        alert.addAction(okAction)
        present(alert, animated: true, completion: nil)
    }
    
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        controller.dismiss(animated: true)
    }
    
    // MARK: - Actions
    @IBAction func sendButtonTapped(_ sender: Any) {
        sendEmail()
    }
    
}
