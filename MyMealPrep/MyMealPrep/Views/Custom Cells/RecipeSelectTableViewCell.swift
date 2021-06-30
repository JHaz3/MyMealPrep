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
    var isToggled: Bool = false
    var recipe: Recipe? {
        didSet {
            updateViews()
        }
    }
    
    // MARK: - Actions
    @IBAction func checkBoxButtonTapped(_ sender: Any) {
        DispatchQueue.main.async {
            self.delegate?.toggleRecipeChecked(self)
            self.isToggled.toggle()
            self.recipeCheckboxButton.setImage(self.isToggled ? #imageLiteral(resourceName: "Checked Box 1x"): #imageLiteral(resourceName: "Empty Checkbox 1x"), for: .normal)
        }
    }
    
    
    // MARK: - Methods
    func updateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.label
        if recipe.totalTime == 0 {
            cookTimeLabel.text = "N/A"
        } else {
            cookTimeLabel.text = "Cook Time: \(recipe.totalTime) min"
        }
        
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
