//
//  SelectMealPlanRecipesTableViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

class SelectMealPlanRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    // MARK: - Properties
    
    
    // MARK: - Outlets
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions

    // MARK: - Table view data source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return RecipeController.recipes.count
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 60
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectRecipeCell", for: indexPath) as? RecipeSelectTableViewCell else { return UITableViewCell() }
        let recipe = RecipeController.recipes[indexPath.row]
        cell.recipe = recipe
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}// End of Class

// MARK: - Delegate Extensions ToDo
extension SelectMealPlanRecipesViewController: RecipeSelectTableViewCellDelegate {
    func toggleRecipeChecked(_ sender: RecipeSelectTableViewCell) {
        guard var recipe = sender.recipe else { return }
        RecipeController.toggleBoxChecked(recipe: &recipe)
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
