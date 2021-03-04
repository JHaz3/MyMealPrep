//
//  HomeViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeYieldLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var recipeNameAndYieldView: UIView!
    @IBOutlet weak var recentlySavedTableView: UITableView!
    
    // MARK: - Properties
    var randomRecipe: Recipe?
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.layer.cornerRadius = 5
        recipeNameAndYieldView.layer.borderWidth = 0.5
        recipeNameAndYieldView.layer.cornerRadius = 5
        recentlySavedTableView.rowHeight = 80
        setupHomeViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentlySavedTableView.reloadData()
    }
    
    func setupHomeViews() {
        RecipeController.fetchRandomRecipe(searchTerm: "random") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipe):
                    self.recipeNameLabel.text = recipe.label
                    self.recipeYieldLabel.text = "Servings: \(recipe.yield)"
                    self.recipeCookTimeLabel.text = "Cook Time: \(recipe.totalTime)"
                    self.randomRecipe = recipe
                    RecipeController.fetchImage(for: recipe) { (result) in
                        DispatchQueue.main.async {
                            switch result {
                            case .success(let image):
                                self.recipeImageView.image = image
                            case .failure(let error):
                                print(error.localizedDescription)
                            }
                        }
                    }
                case .failure(let error):
                    print(error.localizedDescription)
                }
            }
        }
    }
    
    // Mark: - Actions
    @IBAction func searchButtonTapped(_ sender: Any) {
        let viewController: UIViewController = UIStoryboard(name: "RecipeBook", bundle: nil).instantiateViewController(withIdentifier: "SearchRecipeVC") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenCell", for: indexPath) as? RecipeBookTableViewCell else {return UITableViewCell()}
        if RecipeController.shared.savedRecipes.count >= 3 {
            let arraySlice = RecipeController.shared.savedRecipes.suffix(3)
            let recentRecipes = Array(arraySlice)
            let recipe = recentRecipes[indexPath.row]
            cell.recipe = recipe
            cell.isUserInteractionEnabled = true
        } else {
            let mockRecipe = Recipe(label: "Your saved recipes will go here!", image: "Salad Icon 1x", directions: "", ingredients: [], yield: 0, totalTime: 0, users: nil, uid: nil, isChecked: false, dateToEat: Date())
            cell.mockRecipe = mockRecipe
            cell.isUserInteractionEnabled = false
        }
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "showRecipeDetails" {
            guard let indexPath = recentlySavedTableView.indexPathForSelectedRow,
                  let destination = segue.destination as? HomeRecipeDetailViewController else { return }
            let recipe = RecipeController.shared.savedRecipes[indexPath.row]
            destination.recipe = recipe
        }
    }
}// End of Extension
