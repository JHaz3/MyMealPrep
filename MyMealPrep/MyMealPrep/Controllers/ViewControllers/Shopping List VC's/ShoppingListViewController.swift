//
//  ShoppingListViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/25/21.
//

import UIKit
import CoreGraphics

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Properties
    var menuIsActive = false
    
    // MARK: - Outlets
    @IBOutlet weak var menueButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var menuContainerView: UIView!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        shoppingListTableView.rowHeight = 50
        menuContainerView.isHidden = true
        shoppingListTableView.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        shoppingListTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.menuContainerView.isHidden.toggle()
        }
    }
    
    @IBAction func addListItemButtonTapped(_ sender: Any) {
        ShoppingListController.shared.addItemToShoppingList(with: addItemTextField.text ?? "")
    }
    
    // MARK: - Tableview Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.shared.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = shoppingListTableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath)
                as? ShoppingListTableViewCell else { return UITableViewCell() }
        let item = ShoppingListController.shared.listItems[indexPath.row]
        cell.item = item
        cell.delegate = self
        
        return cell
    }
    
    // MARK: - Methods
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}// End of Class

// MARK: - Delegate Extensions
extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    func toggleItemChecked(_ sender: ShoppingListTableViewCell) {
        guard let index = shoppingListTableView.indexPath(for: sender) else { return }
        let item = ShoppingListController.shared.listItems[index.row]
        ShoppingListController.shared.toggleItemChecked(ingredient: item)
        sender.checkBoxButtonTapped(item)
    }
}

extension ShoppingListViewController: menuButtonSelectedDelegate {
    func selectedButtonTapped(button: UIButton) {
        menuContainerView.isHidden = true
        menuIsActive.toggle()
    }
}

