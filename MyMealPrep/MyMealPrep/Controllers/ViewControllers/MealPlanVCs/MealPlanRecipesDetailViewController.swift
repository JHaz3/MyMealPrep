//
//  MealPlanRecipesDetailViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 3/1/21.
//

import UIKit
import SafariServices

class MealPlanRecipesDetailViewController: UIViewController {

    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeYieldLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTableView: UITableView!
    @IBOutlet weak var seeDirectionsButton: UIButton!
    @IBOutlet weak var recipeNameAndYieldView: UIView!
    @IBOutlet weak var addToShoppingListButton: UIButton!
    
    
    // Mark: - Properties
    var mealPlan: MealPlan?
    var recipe: Recipe?
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
        addToShoppingListButton.layer.cornerRadius = 5
        fetchImageAndUpdateViews()
        recipeNameAndYieldView.layer.borderWidth = 0.5
        recipeNameAndYieldView.layer.cornerRadius = 5
        recipeIngredientsTableView.layer.borderWidth = 0.5
        recipeIngredientsTableView.layer.cornerRadius = 5
        recipeIngredientsTableView.separatorStyle = .none
        
    }
    
    // Mark: - Actions

    @IBAction func seeDirectionsButtonTapped(_ sender: Any) {
        recipeDirectionsWebView()
    }
    @IBAction func addToShoppingListButtonTapped(_ sender: Any) {
        guard let recipe = recipe else { return }
        ShoppingListController.shared.addRecipeIngredients(recipe: recipe)
        let alert = UIAlertController(title: "Success!", message: "Ingredients successfully added to your shopping list!", preferredStyle: .alert)
        let awesomeButton = UIAlertAction(title: "Awesome!", style: .default, handler: nil)
        alert.addAction(awesomeButton)
        self.present(alert, animated: true, completion: nil)
    }
    
    
    
    func fetchImageAndUpdateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.label
        recipeCookTimeLabel.text = "Cook Time: \(recipe.totalTime) min"
        recipeYieldLabel.text = "Serves: \(recipe.yield)"
        
        RecipeController.fetchImage(for: recipe) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    private func recipeDirectionsWebView() {
        guard let recipe = recipe else { return }
        let vc = SFSafariViewController(url: URL(string: "\(recipe.directions)")!)
        present(vc, animated: true)
    }
    
} //End of class


extension MealPlanRecipesDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe else { return 0 }
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredients = recipe?.ingredients[indexPath.row]
        cell.textLabel?.text = ingredients
        return cell
    }
}
