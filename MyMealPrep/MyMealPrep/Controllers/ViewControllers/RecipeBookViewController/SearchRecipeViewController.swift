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
    var recipes: [Recipe] = []
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        searchRecipeSearchBar.delegate = self
    }
}

extension SearchRecipeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "", for: indexPath) as? RecipeBookTableViewCell else {return UITableViewCell()}
        let recipe = recipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
    
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let selectedRecipe = recipes[indexPath.row]
//        let storyboard = UIStoryboard(name: "Home", bundle: nil)
//        if let viewController = storyboard.instantiateViewController(identifier: "") as? RecipeDetailVC {
//        viewController.recipe = selectedRecipe
//        navigationController?.popToViewController(viewController, animated: true)
//    }
}

extension SearchRecipeViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let searchTerm = searchRecipeSearchBar.text, !searchTerm.isEmpty else {return}
        RecipeController.fetchRecipe(searchTerm: searchTerm) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    self.recipes = recipes
                    self.searchRecipeResultsTableView.reloadData()
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
}
