//
//  RecipeDetailViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/17/21.
//

import UIKit

class RecipeDetailViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeStarRatingImageView: UIImageView!
    @IBOutlet weak var recipeReviewCountLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTableView: UITableView!
    @IBOutlet weak var seeDirectionsButton: UIButton!
    @IBOutlet weak var addToRecipeBookButton: UIButton!
    
    // Mark: - Properties
    var recipe: Recipe?
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addToRecipeBookButton.layer.cornerRadius = 5
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
    }
    
    // Mark: - Actions
    @IBAction func addToRecipeBookButtonTapped(_ sender: Any) {
        guard let recipe = recipe else {return}
        RecipeController.savedRecipes.append(recipe)
        navigationController?.popViewController(animated: true)
    }
    
    // TODO! Fetch images for searched recipes

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe else {return 0}
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredients = recipe?.ingredients[indexPath.row]
        cell.textLabel?.text = ingredients
        return cell
    }
}
