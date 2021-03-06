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
    static let shared = ShoppingListViewController()
    var menuIsActive = false
    var mealPlan: MealPlan?
    var recipe: Recipe?
    
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
        shoppingListTableView.isEditing = true
        menuContainerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
        ShoppingListController.shared.loadFromPersistence()
    }
    
    // MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        //        UIView.animate(withDuration: 0.5) {
        //            self.menuContainerView.isHidden.toggle()
        //        }
        let alert = UIAlertController(title: "Delete list?", message: "Are you sure you want to clear your shopping list?", preferredStyle: .alert)
        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let deleteButton = UIAlertAction(title: "Clear List", style: .default) { (_) in
            ShoppingListController.shared.clearListItems()
            self.shoppingListTableView.reloadData()
        }
        alert.addAction(cancelButton)
        alert.addAction(deleteButton)
        self.present(alert, animated: true)
        
    }
    
    @IBAction func addListItemButtonTapped(_ sender: Any) {
        ShoppingListController.shared.addItemToShoppingList(with: addItemTextField.text ?? "")
        addItemTextField.text = ""
        updateViews()
    }
    
    // MARK: - Tableview Data Source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return ShoppingListController.shared.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "shoppingListCell", for: indexPath) as? ShoppingListTableViewCell else { return UITableViewCell() }
        let item = ShoppingListController.shared.listItems[indexPath.row]
        cell.item = item
        cell.delegate = self
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let listItem = ShoppingListController.shared.listItems[indexPath.row]
            ShoppingListController.shared.deleteItem(item: listItem)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    func tableView(_ tableView: UITableView, moveRowAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        let movedListItem = ShoppingListController.shared.listItems[sourceIndexPath.row]
        ShoppingListController.shared.listItems.remove(at: sourceIndexPath.row)
        ShoppingListController.shared.listItems.insert(movedListItem, at: destinationIndexPath.row)
    }
    
    // MARK: - Methods
    private func updateViews() {
        shoppingListTableView.reloadData()
        shoppingListTableView.isEditing = false
    }
    
    
}// End of Class

// MARK: - Delegate Extensions
extension ShoppingListViewController: ShoppingListTableViewCellDelegate {
    func toggleItemChecked(_ sender: ShoppingListTableViewCell) {
        guard let item = sender.item else { return }
        item.isChecked.toggle()
    }
}

extension ShoppingListViewController: menuButtonSelectedDelegate {
    func selectedButtonTapped(button: UIButton) {
        menuContainerView.isHidden = true
        menuIsActive.toggle()
    }
}

