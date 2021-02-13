//
//  RecipeBookViewController.swift
//  MyMealPrep
//
//  Created by Kelsey Sparkman on 2/11/21.
//

import UIKit

private let reuseIdentifier = "savedRecipeCell"

enum Recipes: Int, CaseIterable {
    case Saved
    case Uploaded
    
    var description: String {
        switch self {
        case .Saved: return "Saved"
        case .Uploaded: return "Uploaded"
        }
    }
    
    var color: UIColor {
        switch self {
        case .Saved: return RecipeController.shared.recipes
        case .Uploaded: return RecipeController.shared.recipes
        }
    }
}

class RecipeBookViewController: UIViewController {
    
    // Mark: - Outlets
    @IBOutlet weak var savedRecipeButton: UIButton!
    @IBOutlet weak var uploadedRecipeButton: UIButton!
    
    
    var tableView: UITableView!
    var showMenu = false
    
    // Mark: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
    
    // Mark: - Selectors
    @objc func handleDropdown() {
        
        showMenu = !showMenu
        
        var indexPaths = [IndexPath]()
        
        Recipes.allCases.forEach { (recipe) in
            let indexPath = IndexPath(row: recipe.rawValue, section: 0)
//            print("Recipe: \(recipe), Raw Value: \(recipe.rawValue)")
            indexPaths.append(indexPath)
        }
        
        if showMenu {
            tableView.insertRows(at: indexPaths, with: .fade)
        } else {
            tableView.deleteRows(at: indexPaths, with: .fade)
        }
    }
    
    // Mark: - Helper Functions
    func configureTableView() {
        tableView = UITableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.separatorStyle = .none
        tableView.rowHeight = 50
//        tableView.isScrollEnabled = false
        tableView.register(DropDownCell.self, forCellReuseIdentifier: reuseIdentifier)
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 44).isActive = true
        tableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        tableView.heightAnchor.constraint(equalToConstant: 100).isActive = true
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

extension RecipeBookViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let button = UIButton(type: .system)
        button.setTitle("Saved Recipes", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(handleDropdown), for: .touchUpInside)
        button.backgroundColor = .blue
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        return button
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return showMenu ? Recipes.allCases.count : 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as? DropDownCell else {return UITableViewCell}
        cell?.titleLabel.text = Recipes(rawValue: indexPath.row)?.description
        return cell
    }
}
