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
    
    // Mark: - Properties
    var recipe: Recipe? {
        didSet {
            guard let recipe = recipe else {return}
            DispatchQueue.main.async {
                self.recipeNameLabel.text = recipe.label
                self.recipeYieldLabel.text = "Yield: \(recipe.yield)"
                self.recipeCookTimeLabel.text = "\(recipe.totalTime) min"
                self.recipeImageView.layer.cornerRadius = 5
            }
            
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
    }
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        recipeImageView.layer.cornerRadius = 5
        recipeNameAndYieldView.layer.borderWidth = 0.5
        recipeNameAndYieldView.layer.cornerRadius = 5
        RecipeController.fetchRandomRecipe { (result) in
            switch result {
            case .success(let recipe):
                self.recipe = recipe
            case .failure(let error):
                print("Error fetching random recipe: \(error.localizedDescription)")
            }
        }
    }
    
    // Mark: - Actions
    @IBAction func searchButtonTapped(_ sender: Any) {
        let viewController: UIViewController = UIStoryboard(name: "RecipeBook", bundle: nil).instantiateViewController(withIdentifier: "SearchRecipeVC") as UIViewController
        self.present(viewController, animated: true, completion: nil)
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

extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        3
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "homeScreenCell", for: indexPath) as? RecipeBookTableViewCell else {return UITableViewCell()}
        return cell
    }
    
    
}
