//
//  RecipeSelectTableViewCell.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

// MARK: - Protocol
protocol RecipeSelectTableViewCellDelegate: class {
    func toggleRecipeChecked(_ Sender: RecipeSelectTableViewCell)
}

// MARK: - Custom Cell
class RecipeSelectTableViewCell: UITableViewCell {
    
    // MARK: - Outlets
    @IBOutlet weak var savedRecipeImage: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var cookTimeLabel: UILabel!
    @IBOutlet weak var recipeCheckboxButton: UIButton!
    
    // MARK: - Properties
    weak var delegate: RecipeSelectTableViewCellDelegate?
    // MARK: -ToDo
    // add recipe review(yield) here
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        checkBoxChecked(false)
        delegate?.toggleRecipeChecked(self)
    }
    
    
    // MARK: - Methods
    fileprivate func checkBoxChecked(_ isComplete: Bool) {
        recipeCheckboxButton.setImage(isComplete ? #imageLiteral(resourceName: "Checked Box 1x"): #imageLiteral(resourceName: "Empty Checkbox 1x"), for: .normal)
        
    }
    // if take in a recipe then dont need everything here 
    func updateViews() {
        guard let recipe = recipe else { return }
        checkBoxChecked(false)
        recipeNameLabel.text = recipe.label
        cookTimeLabel.text = "\(recipe.totalTime)"
        
        RecipeController.fetchImage(for: recipe) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.savedRecipeImage.image = image
                }
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}// End of Class
