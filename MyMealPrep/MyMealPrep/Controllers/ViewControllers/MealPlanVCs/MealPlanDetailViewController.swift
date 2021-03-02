//
//  MealPlanDetailViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit

class MealPlanDetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    // MARK: -Outlets
    @IBOutlet weak var mealPlanNameLabel: UILabel!
    @IBOutlet weak var startDateLabel: UILabel!
    @IBOutlet weak var endDateLabel: UILabel!
    @IBOutlet weak var mealPlanRecipesTV: UITableView!
    
    // MARK: - Properties
    var mealPlan: MealPlan?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mealPlanRecipesTV.delegate = self
        mealPlanRecipesTV.dataSource = self
        mealPlanRecipesTV.rowHeight = 100
        self.navigationItem.setHidesBackButton(true, animated: true)
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    // MARK: - Actions
    @IBAction func seeShoppingListButtonTapped(_ sender: Any) {
        guard let mealPan = mealPlan else { return }
        ShoppingListController.shared.addMealPlanRecipesIngredients(mealPlan: mealPan)
    }

    // MARK: - Table View Data Source 
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return mealPlan?.recipes.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "showRecipeCell", for: indexPath)
                as? MealPlanRecipesTableViewCell else { return UITableViewCell() }
        let recipe = mealPlan?.recipes[indexPath.row]
        cell.recipe = recipe
    
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            guard let mealPlan = mealPlan else { return }
            let recipe = mealPlan.recipes[indexPath.row]
            MealPlanController.shared.deleteMPRecipe(mealPlan: mealPlan, recipe: recipe)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Methods
    private func updateViews() {
        loadViewIfNeeded()
        mealPlanNameLabel.text = mealPlan?.mealPlanName
        startDateLabel.text = "Number of recipes: \(mealPlan?.recipes.count ?? 0)"
        mealPlanRecipesTV.reloadData()
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMealPlanRecipeDetails2" {
            guard let index = mealPlanRecipesTV.indexPathForSelectedRow,
                  let destination = segue.destination as? MealPlanRecipesDetailViewController else { return }
            let recipe = mealPlan?.recipes[index.row]
            destination.recipe = recipe
        }
    }
    
}// End of Class 

    // MARK: - Extensions
extension MealPlanDetailViewController: MealPLanRecipesTableViewCellDelegate {
    func assignDateToEat(_ sender: MealPlanRecipesTableViewCell) {
        
    }
}
