//
//  SearchRecipeViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 2/17/21.
//

import UIKit

class SearchRecipeViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var searchRecipeSearchBar: UISearchBar!
    @IBOutlet weak var searchRecipeResultsTableView: UITableView!
    
    // Mark: - Properties
    // var recipes: [Recipe] = []
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipeSearchBar.delegate = self
        searchRecipeResultsTableView.rowHeight = 100
    }
}// End of Class

extension SearchRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipeController.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "recipeCell", for: indexPath) as? RecipeBookTableViewCell else { return UITableViewCell() }
        let recipe = RecipeController.recipes[indexPath.row]
        cell.recipe = recipe
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = RecipeController.recipes[indexPath.row]
        if let viewController = storyboard?.instantiateViewController(identifier: "recipeDetailVC") as? RecipeDetailViewController {
            viewController.recipe = selectedRecipe
            navigationController?.pushViewController(viewController, animated: true)
        }
    }
}

extension SearchRecipeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchRecipeSearchBar.text, !searchTerm.isEmpty else {return}
        RecipeController.fetchRecipe(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    RecipeController.recipes = recipes
                    self.searchRecipeResultsTableView.reloadData()
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
}
