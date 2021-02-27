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
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.menuContainerView.isHidden.toggle()
        }
    }
    
    @IBAction func addListItemButtonTapped(_ sender: Any) {
        ShoppingListController.shared.addItemToShoppingList(with: addItemTextField.text ?? "")
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
    
    // MARK: - Methods
    private func updateViews() {
        shoppingListTableView.reloadData()
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

