//
//  ShoppingListMenueViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/26/21.
//

import UIKit

protocol menuButtonSelectedDelegate {
    func selectedButtonTapped(button: UIButton)
}

class ShoppingListMenuViewController: UIViewController {

    // MARK: - Properties
    var menuDelegate: menuButtonSelectedDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // MARK: - Actions
    @IBAction func addSectionButtonTapped(_ sender: Any) {
        
    }
    
    @IBAction func reorganizeListButtonTapped(_ sender: Any) {
        ShoppingListViewController.shared.shoppingListTableView.isEditing.toggle()
    }
    
    @IBAction func clearListButtonTapped(_ sender: Any) {
        ShoppingListController.shared.clearListItems()
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// End of Class
