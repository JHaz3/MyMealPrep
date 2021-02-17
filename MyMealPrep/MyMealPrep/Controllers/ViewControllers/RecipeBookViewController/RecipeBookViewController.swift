//
//  RecipeBookViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 2/17/21.
//

import UIKit

class RecipeBookViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var backgroundSalad: UIImageView!
    @IBOutlet weak var savedRecipesButton: UIButton!
    @IBOutlet weak var savedRecipesTV: UITableView!
    // Mark: - Properties
    var showTV = false
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        savedRecipesTV.isHidden = true
        savedRecipesButton.layer.borderColor = UIColor.darkGray.cgColor
        savedRecipesButton.layer.borderWidth = 0.8
        savedRecipesTV.layer.borderWidth = 0.8
        savedRecipesTV.layer.borderColor = UIColor.darkGray.cgColor
    }
    
    // Mark: - Actions
    @IBAction func savedRecipesButtonTapped(_ sender: Any) {
       showTV = !showTV
        
        if showTV {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.savedRecipesTV.isHidden = false
            }, completion: nil)
        } else {
            savedRecipesTV.isHidden = true
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension RecipeBookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipeController.recipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? DropDownTableViewCell else {return UITableViewCell()}
        let recipe = RecipeController.recipes[indexPath.row]
        cell.configure(with: recipe)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(RecipeController.recipes[indexPath.row])
    }
}
