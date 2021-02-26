//
//  ShoppingListViewController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/25/21.
//

import UIKit
import CoreGraphics

class ShoppingListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    

    // MARK: - Properties
    
    // MARK: - Outlets
    @IBOutlet weak var menueButton: UIButton!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var addItemTextField: UITextField!
    @IBOutlet weak var menueContainerView: UIView!
    @IBOutlet weak var shoppingListTableView: UITableView!
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        shoppingListTableView.delegate = self
        shoppingListTableView.dataSource = self
        menueContainerView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
    }
    
    // MARK: - Actions
    @IBAction func menuButtonTapped(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5) {
            self.menueContainerView.isHidden.toggle()
        }
    }
    
    @IBAction func addListItemButtonTapped(_ sender: Any) {
        
    }
    
    // MARK: - Tableview Data Source
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ShoppingListController.shared.listItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    // MARK: - Methods

    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
