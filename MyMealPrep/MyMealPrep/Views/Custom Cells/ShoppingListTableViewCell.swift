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
        itemTextField.isUserInteractionEnabled.toggle()
    }
    
    private func updateViews() {
        guard let item = item else { return }
        itemTextField.text = item.item
    }
    
}// End of Class
