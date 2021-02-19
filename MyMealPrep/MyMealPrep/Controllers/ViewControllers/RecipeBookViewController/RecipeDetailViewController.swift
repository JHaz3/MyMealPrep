//
//  RecipeDetailViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/17/21.
//

import UIKit
import WebKit

class RecipeDetailViewController: UIViewController, WKUIDelegate {
    
    // Mark: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeYieldLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTableView: UITableView!
    @IBOutlet weak var seeDirectionsButton: UIButton!
    @IBOutlet weak var addToRecipeBookButton: UIButton!
    @IBOutlet weak var recipeNameAndYieldView: UIView!
    
    // Mark: - Properties
    var recipe: Recipe?
    var webView: WKWebView!
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        addToRecipeBookButton.layer.cornerRadius = 5
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
        guard let recipe = recipe else {return}
        fetchImageAndUpdateViews(recipe: recipe)
        let webConfig = WKWebViewConfiguration()
        webView = WKWebView(frame: .zero, configuration: webConfig)
        webView.uiDelegate = self
        recipeNameAndYieldView.layer.borderWidth = 0.5
        recipeNameAndYieldView.layer.cornerRadius = 5
        recipeIngredientsTableView.layer.borderWidth = 0.5
        recipeIngredientsTableView.layer.cornerRadius = 5
        recipeIngredientsTableView.separatorStyle = .none
    }
    
    // Mark: - Actions
    @IBAction func addToRecipeBookButtonTapped(_ sender: Any) {
        guard let recipe = recipe else {return}
        RecipeController.savedRecipes.append(recipe)
        navigationController?.popViewController(animated: true)
    }
    

    // TODO! Fetch images for searched recipes

    

}

    @IBAction func seeDirectionsButtonTapped(_ sender: Any) {
        loadWebView()
    }
    
    func fetchImageAndUpdateViews(recipe: Recipe) {
        RecipeController.fetchImage(for: recipe) { (result) in
            DispatchQueue.main.async {
                switch result {
                case .success(let image):
                    self.recipeImageView.image = image
                    self.recipeNameLabel.text = recipe.label
                    self.recipeCookTimeLabel.text = "\(recipe.totalTime) min"
                    self.recipeYieldLabel.text = "Yield: \(recipe.yield)"
                case .failure(let error):
                    print(error, error.localizedDescription)
                }
            }
        }
    }
    
    func loadWebView() {
        view = webView
        guard let recipe = recipe else {return}
        let myURL = URL(string: "\(recipe.directions)")!
        webView.load(URLRequest(url: myURL))
        webView.allowsBackForwardNavigationGestures = true
    }
} //End of class


extension RecipeDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe else {return 0}
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredients = recipe?.ingredients[indexPath.row]
        cell.textLabel?.text = ingredients
        return cell
    }
}
