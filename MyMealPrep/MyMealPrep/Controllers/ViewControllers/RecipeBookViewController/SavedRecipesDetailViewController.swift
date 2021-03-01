//
//  SavedRecipesDetailViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/22/21.
//

import UIKit
import WebKit

class SavedRecipesDetailViewController: UIViewController, WKUIDelegate {

    // MARK: - Outlets
    @IBOutlet weak var recipeImageView: UIImageView!
    @IBOutlet weak var recipeNameLabel: UILabel!
    @IBOutlet weak var recipeYieldLabel: UILabel!
    @IBOutlet weak var recipeCookTimeLabel: UILabel!
    @IBOutlet weak var recipeIngredientsTableView: UITableView!
    @IBOutlet weak var seeDirectionsButton: UIButton!
    @IBOutlet weak var recipeNameAndYieldView: UIView!
    @IBOutlet weak var addToShoppingListButton: UIButton!
    
    
    // Mark: - Properties
    var recipe: Recipe?
    var webView: WKWebView!
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeIngredientsTableView.delegate = self
        recipeIngredientsTableView.dataSource = self
        addToShoppingListButton.layer.cornerRadius = 5
        fetchImageAndUpdateViews()
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

    @IBAction func seeDirectionsButtonTapped(_ sender: Any) {
        loadWebView()
    }
    @IBAction func addToShoppingListButtonTapped(_ sender: Any) {
        guard let recipe = recipe else { return }
        ShoppingListController.shared.addRecipeIngredients(recipe: recipe)
    }
    
    
    func fetchImageAndUpdateViews() {
        guard let recipe = recipe else { return }
        recipeNameLabel.text = recipe.label
        recipeCookTimeLabel.text = "\(recipe.totalTime) min"
        recipeYieldLabel.text = "Yield: \(recipe.yield)"
        
        RecipeController.fetchImage(for: recipe) { (result) in
            switch result {
            case .success(let image):
                DispatchQueue.main.async {
                    self.recipeImageView.image = image
                }
            case .failure(let error):
                print(error, error.localizedDescription)
            }
        }
    }
    
    func loadWebView() {
        view = webView
        guard let recipe = recipe else { return }
        guard let myURL = URL(string: "\(recipe.directions)") else { return }
        webView.load(URLRequest(url: myURL))
        webView.allowsBackForwardNavigationGestures = true
    }
} //End of class


extension SavedRecipesDetailViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let recipe = recipe else { return 0 }
        return recipe.ingredients.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ingredientCell", for: indexPath)
        let ingredients = recipe?.ingredients[indexPath.row]
        cell.textLabel?.text = ingredients
        return cell
    }
}
