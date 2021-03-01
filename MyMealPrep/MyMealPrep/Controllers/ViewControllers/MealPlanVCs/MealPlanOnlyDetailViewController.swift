//
//  MealPlanOnlyDetailViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 3/1/21.
//

import UIKit

class MealPlanOnlyDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // MARK: - Outlets
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
        mealPlanRecipesTV.reloadData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
       super.viewWillAppear(true)
       updateViews()
   }
    
    // MARK: - Actions
    
    // MARK: - Tableview DataSource
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
    private func updateViews() {
        loadViewIfNeeded()
        mealPlanNameLabel.text = mealPlan?.mealPlanName
        endDateLabel.text = "\(mealPlan?.recipes.count ?? 0) recipes in your meal plan"
        mealPlanRecipesTV.reloadData()
    }
}// End of Class


// MARK: - Extensions
extension MealPlanOnlyDetailViewController: MealPLanRecipesTableViewCellDelegate {
    func assignDateToEat(_ sender: MealPlanRecipesTableViewCell) {
    }
}
