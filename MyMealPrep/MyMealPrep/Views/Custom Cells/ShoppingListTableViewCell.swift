//
//  ShoppingListTableViewCell.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/26/21.
//

import UIKit

// MARK: - Protocols
protocol ShoppingListTableViewCellDelegate: class {
    func toggleItemChecked(_ sender: ShoppingListTableViewCell)
}

class ShoppingListTableViewCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet var checkboxButton: UIButton!
    @IBOutlet var itemTextField: UITextField!
    @IBOutlet var editItemButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: ShoppingListTableViewCellDelegate?
    var isToggled: Bool = false
    var item: ShoppingList? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        delegate?.toggleItemChecked(self)
        isToggled.toggle()
        checkboxButton.setImage(isToggled ? #imageLiteral(resourceName: "Checked Box 1x"): #imageLiteral(resourceName: "Empty Checkbox 1x"), for: .normal)
    }
    
    @IBAction func editItemButtonTapped(_ sender: Any) {
        if itemTextField.isUserInteractionEnabled == false {
            itemTextField.isUserInteractionEnabled.toggle()
            editItemButton.setImage(UIImage(named: "checkMark"), for: .normal)
        } else if itemTextField.isUserInteractionEnabled == true {
            guard let item = item else { return }
            ShoppingListController.shared.updateListItem(listItem: item, itemName: itemTextField.text ?? "")
            itemTextField.isUserInteractionEnabled.toggle()
            editItemButton.setImage(UIImage(named: "EditButton"), for: .normal)
        }
    }
    
    private func updateViews() {
        guard let item = item else { return }
        if !item.item.contains(",") {
            itemTextField.text = item.item
        } else {
            let itemToSubString = item.item
            guard let endOfItem = itemToSubString.firstIndex(of: ",") else { return }
            let startOfItem = itemToSubString[..<endOfItem]
            itemTextField.text = "\(startOfItem)"
        }
    }
    
}// End of Class
