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
    
    // Mark: - Properties
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
        RecipeController.fetchRecipe(searchTerm: "random") { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let recipes):
                    let randomRecipe = recipes.randomElement()!
                    self.recipeNameLabel.text = randomRecipe.label
                    self.recipeYieldLabel.text = "Servings: \(randomRecipe.yield)"
                    self.recipeCookTimeLabel.text = "Cook Time: \(randomRecipe.totalTime)"
                    RecipeController.fetchImage(for: randomRecipe) { (result) in
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
        if RecipeController.shared.savedRecipes.isEmpty {
            let mockRecipe = Recipe(label: "Your saved recipes will go here!", image: "Salad Icon 1x", directions: "", ingredients: [], yield: 0, totalTime: 0, users: nil, uid: nil, isChecked: false, dateToEat: Date())
            cell.mockRecipe = mockRecipe
        } else {
            let arraySlice = RecipeController.shared.savedRecipes.suffix(3)
            let lastThreeArray = Array(arraySlice)
            let recipe = lastThreeArray[indexPath.row]
            cell.recipe = recipe
        }
        return cell
    }
}
