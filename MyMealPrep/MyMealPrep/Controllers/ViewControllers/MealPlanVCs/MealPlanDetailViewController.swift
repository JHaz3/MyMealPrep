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
        updateViews()
    }
    
     override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
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
    private func updateViews() {
        loadViewIfNeeded()
        self.navigationItem.setHidesBackButton(true, animated: true)
        mealPlanNameLabel.text = mealPlan?.mealPlanName
        endDateLabel.text = "\(mealPlan?.recipes.count ?? 0) recipes in your meal plan"
        mealPlanRecipesTV.delegate = self
        mealPlanRecipesTV.dataSource = self
        mealPlanRecipesTV.rowHeight = 100
        mealPlanRecipesTV.reloadData()
    }
    
}// End of Class 

    // MARK: - Extensions
extension MealPlanDetailViewController: MealPLanRecipesTableViewCellDelegate {
    func assignDateToEat(_ sender: MealPlanRecipesTableViewCell) {
        
    }
}
