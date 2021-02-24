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
    var checkedRecipes: Set<Recipe> = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        savedRecipesTableView.dataSource = self
        savedRecipesTableView.delegate = self
        savedRecipesTableView.rowHeight = 100
        savedRecipesTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func saveRecipesButtonTapped(_ sender: Any) {
        guard let mealPlan = mealPlan else { return }
        mealPlan.recipes.append(contentsOf: checkedRecipes)
        checkedRecipes.removeAll()
        
        if let vc = storyboard?.instantiateViewController(identifier: "mealPlanDetailVC") as? MealPlanDetailViewController {
            vc.mealPlan = mealPlan
            navigationController?.pushViewController(vc, animated: true)
        }
        
        //self.performSegue(withIdentifier: "showMealPlanDetails", sender: self)
    }
    
    // MARK: - Table view data source
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return RecipeController.shared.savedRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectRecipeCell", for: indexPath) as? RecipeSelectTableViewCell else { return UITableViewCell() }
        let recipe = RecipeController.shared.savedRecipes[indexPath.row]
        cell.recipe = recipe
        cell.delegate = self
        return cell
    }
    
    // MARK: - Methods
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if(segue.identifier == "showMealPlanDetails") {
            guard let mpToSend = MealPlanController.shared.mealPlans.last,
                  let destination = segue.destination as? MealPlanDetailViewController else { return }
            destination.mealPlan = mpToSend
        }
     }
    
}// End of Class

// MARK: - Delegate Extensions
extension SelectMealPlanRecipesViewController: RecipeSelectTableViewCellDelegate {
    func toggleRecipeChecked(_ sender: RecipeSelectTableViewCell) {
        guard let recipe = sender.recipe else { return }
        if checkedRecipes.contains(recipe) {
            checkedRecipes.remove(recipe)
        } else {
            checkedRecipes.insert(recipe)
        }
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
