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
    
    // MARK: - Properties
    var mealPlan: MealPlan?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    @IBAction func seeShoppingListButtonTapped(_ sender: Any) {
        
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

    // MARK: - Methods
    
    
}// End of Class 

    // MARK: - Extensions
extension MealPlanDetailViewController: MealPLanRecipesTableViewCellDelegate {
    func assignDateToEat(_ sender: MealPlanRecipesTableViewCell) {
        
    }
}
