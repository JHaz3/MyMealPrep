//
//  SelectMealPlanRecipesTableViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

class SelectMealPlanRecipesViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeSearchBar: UISearchBar!
    @IBOutlet weak var savedRecipesTableView: UITableView!
    
    // MARK: - Properties
    var mealPlan: MealPlan?
    var checkedRecipes: [Recipe] = []
    var recipeSearchArray: [Recipe] = []
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated: true)
        savedRecipesTableView.dataSource = self
        savedRecipesTableView.delegate = self
        recipeSearchBar.delegate = self
        savedRecipesTableView.rowHeight = 100
        setUpViews()
        savedRecipesTableView.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        savedRecipesTableView.reloadData()
    }
    
    // MARK: - Actions
    @IBAction func saveRecipesButtonTapped(_ sender: Any) {
        guard let mealPlan = mealPlan else { return }
        mealPlan.recipes = checkedRecipes
        
        UserController.shared.saveMealPlan(mealPlan: mealPlan) { (result) in
            switch result {
            case .success(_):
                print("Meal Plan Saved!")
            case .failure(let error):
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
            }
        }
        
        if let vc = storyboard?.instantiateViewController(identifier: "mealPlanDetailVC") as?
            MealPlanDetailViewController {
            vc.mealPlan = mealPlan
            navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Table view data source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return recipeSearchArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "selectRecipeCell", for: indexPath) as? RecipeSelectTableViewCell else { return UITableViewCell() }
        let recipe = recipeSearchArray[indexPath.row]
        cell.recipe = recipe
        cell.delegate = self
        return cell
    }
    
    // MARK: - Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        guard !searchText.isEmpty else {
            recipeSearchArray = RecipeController.shared.savedRecipes
            savedRecipesTableView.reloadData()
            return
        }
        
        recipeSearchArray = RecipeController.shared.savedRecipes.filter({ (recipe) -> Bool in
            guard let text = searchBar.text else { return false }
            return recipe.label.lowercased().contains(text.lowercased())
        })
        savedRecipesTableView.reloadData()
    }
    
    private func setUpViews() {
        recipeSearchArray = RecipeController.shared.savedRecipes
    }
    
    // MARK: - Navigation
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
        if recipe.isChecked {
            guard let index = checkedRecipes.firstIndex(of: recipe) else { return }
            recipe.isChecked = false
            checkedRecipes.remove(at: index)
        } else {
            recipe.isChecked = true
            checkedRecipes.append(recipe)
        }
    }
}




