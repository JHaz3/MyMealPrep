//
//  ProfileViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit

class ProfileViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var editLoginButton: UIButton!
    @IBOutlet weak var contactUsButton: UIButton!
    @IBOutlet weak var shareButton: UIButton!
    @IBOutlet weak var logoutButton: UIButton!
    @IBOutlet weak var editLoginArrow: UIImageView!
    @IBOutlet weak var contactUsArrow: UIImageView!
    @IBOutlet weak var shareArrow: UIImageView!
    
    // Mark: - Properties
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
//        rotateArrows()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        rotateArrows()
    }
    
    private func rotateArrows() {
        editLoginArrow.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 90)
//        editLoginArrow.transform = CGAffineTransform(rotationAngle: (0.0 * .pi) / 90.0)
//        editLoginArrow.transform = editLoginArrow.transform.rotated(by: CGFloat(Double.pi / 180))
        contactUsArrow.transform = contactUsArrow.transform.rotated(by: CGFloat(Double.pi / 45))
        shareArrow.transform = shareArrow.transform.rotated(by: CGFloat(Double.pi / 45))
    }
    
    // Mark: - Actions
    @IBAction func logoutButtonTapped(_ sender: Any) {
    }
}
