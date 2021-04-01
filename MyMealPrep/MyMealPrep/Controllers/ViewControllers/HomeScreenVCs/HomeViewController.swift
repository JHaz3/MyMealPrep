//
//  HomeViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/15/21.
//

import UIKit

class HomeViewController: UIViewController {
    
    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeYieldLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var recipeNameAndYieldView: UIView!
    @IBOutlet weak var recentlySavedTableView: UITableView!
    
    // MARK: - Properties
    var randomRecipe: Recipe?
    var recentlySavedRecipes: [Recipe]?
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        loadUserData()
        recipeImageView.layer.cornerRadius = 5
        recipeNameAndYieldView.layer.borderWidth = 0.5
        recipeNameAndYieldView.layer.cornerRadius = 5
        recentlySavedTableView.rowHeight = 80
        setupHomeViews()
        recentlySavedTableView.isScrollEnabled = false
        checkForTraitCollection()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        recentlySavedTableView.reloadData()
    }
    
    @IBAction func randomRecipeTapped(_ gestureRecognizer : UITapGestureRecognizer) {
        guard gestureRecognizer.view != nil else { return }
        let sb = UIStoryboard(name: "RecipeBook", bundle: nil)
        guard let toDetail = sb.instantiateViewController(identifier: "recipeDetailVC") as? RecipeDetailViewController else {return}
        toDetail.recipe = self.randomRecipe
        self.navigationController?.pushViewController(toDetail, animated: true)
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
        DispatchQueue.main.async {
            UserController.shared.fetchRecipe { (result) in
                switch result {
                case .success(let fetchedRecipes):
                    RecipeController.shared.savedRecipes = fetchedRecipes
                    self.recentlySavedTableView.reloadData()
                case .failure(let recipeError):
                    print("\(String(describing: recipeError.errorDescription))")
                }
            }
            
            UserController.shared.fetchMealPlans { (result) in
                switch result {
                case .success(let fetchedMealPlans):
                    MealPlanController.shared.mealPlans = fetchedMealPlans
                case .failure(let mealPlanError):
                    print("\(String(describing: mealPlanError.errorDescription))")
                }
            }
        }
    }
    
    // MARK: - Actions
    @IBAction func searchButtonTapped(_ sender: Any) {
        let viewController: UIViewController = UIStoryboard(name: "RecipeBook", bundle: nil).instantiateViewController(withIdentifier: "SearchRecipeVC") as UIViewController
        self.present(viewController, animated: true, completion: nil)
    }
    
    func checkForTraitCollection() {
        switch traitCollection.userInterfaceStyle {
        case .dark:
            recipeNameLabel.backgroundColor = .secondarySystemBackground
            recipeYieldLabel.backgroundColor = .secondarySystemBackground
            recipeCookTimeLabel.backgroundColor = .secondarySystemBackground
            recipeNameAndYieldView.backgroundColor = .secondarySystemBackground
//            recentlySavedTableView.backgroundColor = .secondarySystemBackground
        case .light:
            print("Device is in light mode, no need to change!")
        default:
            print("Could not get specified interface style.")
        }
    }
}

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        let recipeCount = RecipeController.shared.savedRecipes.count
        if recipeCount <= 3 {
            return recipeCount
        } else {
            return 3
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        1
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let headerView = UIView()
        headerView.backgroundColor = view.backgroundColor
        return headerView
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 15
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenCell", for: indexPath) as? RecipeBookTableViewCell else {return UITableViewCell()}
        if RecipeController.shared.savedRecipes.count >= 1 {
            let array = RecipeController.shared.savedRecipes
            let arraySlice = array.suffix(3)
            let newArray = Array(arraySlice)
            let recipe = newArray[indexPath.section]
            recentlySavedRecipes = newArray
            cell.recipe = recipe
        } else {
            let mockRecipe = Recipe(label: "Your saved recipes will go here!", image: "Salad Icon 1x", directions: "", ingredients: [], yield: 0, totalTime: 0, isChecked: false, dateToEat: Date())
            cell.mockRecipe = mockRecipe
            cell.isUserInteractionEnabled = false
        }
        cell.layer.cornerRadius = 5.0
        cell.layer.borderWidth = 0.5
        cell.layer.borderColor = UIColor.lightGray.cgColor        
        cell.backgroundColor = .clear
        cell.layer.masksToBounds = false
        cell.layer.shadowOpacity = 0.5
        cell.layer.shadowRadius = 4
        cell.layer.shadowOffset = CGSize(width: 0, height: 0)
        cell.layer.shadowColor = UIColor.lightGray.cgColor
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let selectedRecipe = recentlySavedRecipes?[indexPath.section]
        let sb = UIStoryboard(name: "RecipeBook", bundle: nil)
        guard let toDetail = sb.instantiateViewController(identifier: "savedRecipeDetailVC") as? SavedRecipesDetailViewController else {return}
        toDetail.recipe = selectedRecipe
        self.navigationController?.pushViewController(toDetail, animated: true)
    }
}// End of Extension
