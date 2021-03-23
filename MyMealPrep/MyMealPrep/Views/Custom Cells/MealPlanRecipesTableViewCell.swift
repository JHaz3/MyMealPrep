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
    @IBOutlet weak var dateToEatDatePicker: UIDatePicker!
    
    // MARK: - Properties
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    weak var delegate: MealPLanRecipesTableViewCellDelegate?
    
    // MARK: - Actions
    @IBAction func datePickerValueChanged(_ sender: Any) {
        guard let recipe = recipe else { return }
        let dateToEat = dateToEatDatePicker.date
        RecipeController.updateDateToEat(date: dateToEat, recipe: recipe)
        // right idea here needs some work
        UserController.shared.db.collection(Constants.mealPlanContainer).document(recipe.uid!).updateData([Constants.dateToEat : dateToEat])
    }
    
    
    
    // MARK: -Methods
    private func updateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.label
        dateToEatDatePicker.date = recipe.dateToEat

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
    
    
}// End of Class
