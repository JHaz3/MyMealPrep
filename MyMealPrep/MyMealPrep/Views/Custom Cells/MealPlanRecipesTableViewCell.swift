//
//  MealPlanRecipesTableViewCell.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

// MARK: - Protocols
protocol MealPLanRecipesTableViewCellDelegate: class {
    func assignDateToEat(_ sender: MealPlanRecipesTableViewCell)
    
}


class MealPlanRecipesTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var assignDateButton: UIButton!
    
    // MARK: - Properties
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    let datePicker = UIDatePicker()
    
    
    // MARK: - Actions
    @IBAction func assignDateButtonTapped(_ sender: Any) {
        
    }
    
    
    // MARK: -Methods
    func updateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.label
        
        RecipeController.fetchImage(for: recipe) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - FIXES MAY BE REQUIRED 
    func createDatePicker() {
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneTapped))
        toolbar.setItems([doneBtn], animated: true)
//        assignDateButton.inputAccessoryView = toolbar
//        assignDateButton.inputView = datePicker
        datePicker.datePickerMode = .date
        
    }
    
    @objc func doneTapped() {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        
        assignDateButton.setTitle("\(formatter.string(from: datePicker.date))", for: .normal)
        self.inputView?.endEditing(true)
    }
    
}// End of Class
