//
//  SelectMealPlanRecipesTableViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

class SelectMealPlanRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    // MARK: - Properties
    var mealPlan: MealPlan?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        savedRecipesTableView.dataSource = self
        savedRecipesTableView.delegate = self
        savedRecipesTableView.rowHeight = 100
        savedRecipesTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func saveRecipesButtonTapped(_ sender: Any) {
        guard let mealPlan = mealPlan else { return }
        // Will I need to set all saved recipes isChecked value back to false?
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            let recipesChecked = RecipeController.shared.savedRecipes[indexPath.row]
            if recipesChecked.isChecked == true {
                mealPlan.recipes.append(recipesChecked)
            } else {
                return //add alert saying failed to save recipes?
            }
        }
        
    }
    
    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RecipeController.shared.savedRecipes.count
    }
    
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        return 60
//    }
    // MARK: - Does this work?
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectRecipeCell", for: indexPath) as? RecipeSelectTableViewCell else { return UITableViewCell() }
        let recipe = RecipeController.shared.savedRecipes[indexPath.row]
        cell.recipe = recipe
        
        return cell
    }
    
    // MARK: - Methods

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// End of Class

// MARK: - Delegate Extensions
extension SelectMealPlanRecipesViewController: RecipeSelectTableViewCellDelegate {
    func toggleRecipeChecked(_ sender: RecipeSelectTableViewCell) {
        guard var recipe = sender.recipe else { return }
        RecipeController.shared.toggleBoxChecked(recipe: &recipe)
        sender.updateViews()
    }
}

extension SelectMealPlanRecipesViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = recipeSearchBar.text, !searchTerm.isEmpty else { return }
        RecipeController.fetchRecipe(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    RecipeController.recipes = recipes
                    self.savedRecipesTableView.reloadData()
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
}
