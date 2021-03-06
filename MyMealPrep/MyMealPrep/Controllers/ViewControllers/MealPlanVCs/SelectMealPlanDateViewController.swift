//
//  SelectMealPlanDateViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import UIKit

class SelectMealPlanDateViewController: UIViewController {
    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var startDatePicker: UIDatePicker!
    @IBOutlet weak var endDatePicker: UIDatePicker!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpPickerViews()
    }
    
    // MARK: - Actions
    @IBAction func selectRecipeButtonTapped(_ sender: Any) {
        let startDate = startDatePicker.date
        let endDate = endDatePicker.date
        guard endDate > startDate else { return }
        
        MealPlanController.shared.createMealPlan(with: startDate, endDate: endDate)
        
        // MARK: - Better Way to do this?
        if let vc = storyboard?.instantiateViewController(identifier: "selectRecipesVC") as? SelectMealPlanRecipesViewController {
            vc.mealPlan = MealPlanController.shared.mealPlans.last
            navigationController?.pushViewController(vc, animated: true)
        }
        
    }
    
    // MARK: - Methods
    private func setUpPickerViews() {
        startDatePicker.isUserInteractionEnabled = true
        endDatePicker.isUserInteractionEnabled = true
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
    }
    
}// End of Class
