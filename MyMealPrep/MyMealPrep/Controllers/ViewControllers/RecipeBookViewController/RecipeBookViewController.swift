//
//  RecipeBookViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 2/17/21.
//

import UIKit

class RecipeBookViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var backgroundSalad: UIImageView!
    @IBOutlet weak var savedRecipesButton: UIButton!
    @IBOutlet weak var savedRecipesTV: UITableView!
    @IBOutlet weak var arrowImageView: UIImageView!
    
    //  MARK: - Properties
    var showTV = false
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        savedRecipesTV.dataSource = self
        savedRecipesTV.delegate = self
        savedRecipesButton.layer.borderColor = UIColor.darkGray.cgColor
        savedRecipesButton.layer.borderWidth = 0.2
        savedRecipesTV.layer.borderWidth = 0.5
        savedRecipesTV.layer.borderColor = UIColor.darkGray.cgColor
        savedRecipesTV.rowHeight = 100
        savedRecipesTV.isScrollEnabled = true
        savedRecipesTV.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        savedRecipesTV.reloadData()
        RecipeController.shared.loadFromPersistence()
        checkForTraitCollection()
    }
    
    // MARK: - Actions
    @IBAction func savedRecipesButtonTapped(_ sender: Any) {
        showTV = !showTV
        
        if showTV {
            UIView.animate(withDuration: 0.1, delay: 0, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                self.savedRecipesTV.isHidden = false
            }, completion: nil)
            
            UIView.animate(withDuration: 0.2) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: (90.0 * .pi) / 180.0)
            }
        } else {
            savedRecipesTV.isHidden = true
            UIView.animate(withDuration: 0.2) {
                self.arrowImageView.transform = CGAffineTransform(rotationAngle: (0.0 * .pi) / 180.0)
            }
            savedRecipesTV.reloadData()
        }
    }
    
    @IBAction func backButtonTapped(_ sender: Any) {
        navigationController?.popViewController(animated: true)
    }
    
    func checkForTraitCollection() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            savedRecipesButton.backgroundColor = .secondarySystemBackground
//            savedRecipesTV.backgroundColor = .secondarySystemBackground
        case .light:
            print("Device is in light mode, no need to change!")
        default:
            print("Could not get specified interface style.")
        }
    }
}// End of Class

extension RecipeBookViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        RecipeController.shared.savedRecipes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "savedRecipeCell", for: indexPath) as? RecipeBookTableViewCell else { return UITableViewCell() }
        let savedRecipes = RecipeController.shared.savedRecipes[indexPath.row]
        cell.recipe = savedRecipes
        return cell
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            let recipe = RecipeController.shared.savedRecipes[indexPath.row]
            RecipeController.shared.deleteRecipe(recipe: recipe)
            tableView.deleteRows(at: [indexPath], with: .fade)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            guard let indexPath = savedRecipesTV.indexPathForSelectedRow,
                  let destination = segue.destination as? SavedRecipesDetailViewController else { return }
            let recipe = RecipeController.shared.savedRecipes[indexPath.row]
            destination.recipe = recipe
        }
    }
}// End of Extension

//extension UITextField {
//
//    var isEmpty: Bool {
//        if let text = textField.text, !text.isEmpty {
//             return false
//        }
//        return true
//    }
//}
