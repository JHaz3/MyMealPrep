//
//  MealPlanListViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit

class MealPlanListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    // MARK: - Outlets
    @IBOutlet weak var mealPlanListTableView: UITableView!
    
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    @IBAction func startNewMealPlanButtonTapped(_ sender: Any) {
       
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return MealPlanController.shared.mealPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealPlanCell", for: indexPath ) as? MealPlanListTableViewCell else { return UITableViewCell() }
        let mealPlan = MealPlanController.shared.mealPlans[indexPath.row]
        cell.mealPlan = mealPlan
        
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
