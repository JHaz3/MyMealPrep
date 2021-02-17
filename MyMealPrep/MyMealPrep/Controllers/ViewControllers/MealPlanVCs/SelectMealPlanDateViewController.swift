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
        guard endDate > startDate else { return } // add alert about error if user goes against logic
        
        MealPlanController.shared.createMealPlan(with: startDate, endDate: endDate)
        
        self.performSegue(withIdentifier: "showRecipeSelect", sender: nil)
        
    }
    
    // MARK: - Methods
    private func setUpPickerViews() {
        startDatePicker.minimumDate = Date()
        endDatePicker.minimumDate = Date()
    }
    

}// End of Class
