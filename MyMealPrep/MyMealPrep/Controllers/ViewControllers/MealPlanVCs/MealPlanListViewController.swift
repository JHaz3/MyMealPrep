//
//  MealPlanListViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit

class MealPlanListViewController: UIViewController {
    
    // MARK: - Outlets
    
    
    // MARK: -Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    // MARK: - Actions
    @IBAction func startNewMealPlanButtonTapped(_ sender: Any) {
        // TODO: -Instead add after recipes are selected down the line- Add alerts to create a meal plan name?
//        let alert = UIAlertController(title: "Name Meal Plan", message: "Name Meal Plan", preferredStyle: .alert)
//        alert.addTextField(configurationHandler: nil)
//        let cancelButton = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let addButton = UIAlertAction(title: "Create Meal Plan", style: .default) { (_) in
//            guard let mealPlanTitle = alert.textFields?[0].text, mealPlanTitle != "" else { return }
//            
//        }
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
