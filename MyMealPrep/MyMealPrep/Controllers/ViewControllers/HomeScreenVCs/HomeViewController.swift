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
        loadUserData()
        recipeImageView.layer.cornerRadius = 5
        recipeNameAndYieldView.layer.borderWidth = 0.5
        recipeNameAndYieldView.layer.cornerRadius = 5
        recentlySavedTableView.rowHeight = 80
        setupHomeViews()
        let tap = UITapGestureRecognizer(target: self, action: #selector(randomRecipeTapped))
        view.addGestureRecognizer(tap)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentlySavedTableView.reloadData()
    }
    
    @objc func randomRecipeTapped() {
        let sb = UIStoryboard(name: "RecipeBook", bundle: nil)
        guard let toLogin = sb.instantiateViewController(identifier: "recipeDetailVC") as? RecipeDetailViewController else {return}
        toLogin.recipe = self.randomRecipe
        self.navigationController?.pushViewController(toLogin, animated: true)
    }
    
    
    // MARK: - Methods
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
    
    @objc func loadUserData() {
        UserController.shared.fetchRecipe { (result) in
            switch result {
            case .success(let fetchedRecipes):
                RecipeController.shared.savedRecipes = fetchedRecipes
                self.recentlySavedTableView.reloadData()
            case .failure(let recipeError):
                print("\(String(describing: recipeError.errorDescription))")
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
        let recipeCount = RecipeController.shared.savedRecipes.count
        if recipeCount <= 3 {
            return recipeCount
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenCell", for: indexPath) as? RecipeBookTableViewCell else {return UITableViewCell()}
        if RecipeController.shared.savedRecipes.count >= 1 {
            let array = RecipeController.shared.savedRecipes
            let arraySlice = array.suffix(3)
            let newArray = Array(arraySlice)
            let recipe = newArray[indexPath.row]
            cell.recipe = recipe
        } else {
            let mockRecipe = Recipe(label: "Your saved recipes will go here!", image: "Salad Icon 1x", directions: "", ingredients: [], yield: 0, totalTime: 0, isChecked: false, dateToEat: Date())
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
