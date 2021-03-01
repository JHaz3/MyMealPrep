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
    
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        mealPlanListTableView.delegate = self
        mealPlanListTableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        updateViews()
    }
    
    // MARK: - Actions
    @IBAction func startNewMealPlanButtonTapped(_ sender: Any) {
        guard let vc = storyboard?.instantiateViewController(identifier: "SelectMealPlanDate") as? SelectMealPlanDateViewController else { return }
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // MARK: - TableView Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return MealPlanController.shared.mealPlans.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "mealPlanCell", for: indexPath ) as?
                MealPlanListTableViewCell else { return UITableViewCell() }
        let mealPlan = MealPlanController.shared.mealPlans[indexPath.row]
        cell.mealPlan = mealPlan
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let mealPlan = MealPlanController.shared.mealPlans[indexPath.row]
            MealPlanController.shared.deleteMealPlan(mealPlan: mealPlan)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    // MARK: - Methods
    private func updateViews() {
        mealPlanListTableView.rowHeight = 80
        mealPlanListTableView.reloadData()
    }
    
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showMealPlan" {
            guard let index = mealPlanListTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? MealPlanOnlyDetailViewController else { return }
            let mealPlan = MealPlanController.shared.mealPlans[index.row]
            destination.mealPlan = mealPlan
        }
    }
    
}// End of Class
