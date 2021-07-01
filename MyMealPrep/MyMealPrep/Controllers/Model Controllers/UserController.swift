//
//  UserController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/9/21.
//

import Foundation
import Firebase
import FirebaseStorage

class UserController {
    // MARK: - Properties
    static let shared = UserController()
    var currentUser: User?
    var recipe: Recipe?
    var mealPlan: MealPlan?
    let db = Firestore.firestore()
    
    // MARK: - CRUD
    func createUser(user: User, completion: @escaping (Result<User?, UserError>) -> Void) {
        let userDict: [String : Any] = [Constants.email : user.email,
                                        Constants.password : user.password
        ]
        
        db.collection(Constants.users).document(user.uuid).setData(userDict) { (error) in
            if let error = error {
                print("There was an error creating a user: \(error.localizedDescription)")
            } else {
                completion(.success(user))
            }
        }
        //        db.collection(Constants.users).document(user.uuid).addDocument(data: userDict) { (error) in
        //            if let error = error {
        //                print("There was an error creating a user: \(error.localizedDescription)")
        //            } else {
        //                let
        //                let user = User(email: email, password: password)
        //                completion(.success(user))
        //            }
        //        }
    }
    
    func fetchUserWithEmail(withEmail email: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        db.collection(Constants.users).whereField(Constants.email, isEqualTo: email).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching users: \(error.localizedDescription)")
            } else if let firstDocument = snapshot?.documents.first {
                guard let user = User(document: firstDocument ) else {return}
                completion(.success(user))
            } else {
                completion(.success(nil))
            }
        }
    }
    
    func fetchUserWithPassword(withPassword password: String, completion: @escaping (Result<User?, UserError>) -> Void) {
        db.collection(Constants.users).whereField(Constants.password, isEqualTo: password).getDocuments { (snapshot, error) in
            if let error = error {
                print("There was an error fetching users: \(error.localizedDescription)")
            } else if let firstDocument = snapshot?.documents.first {
                guard let user = User(document: firstDocument) else {return}
                completion(.success(user))
            }
        }
    }
    
    func updateEmail(withEmail email: String, completion: @escaping (String) -> Void) {
        guard let currentUser = self.currentUser else {return}
        self.fetchUserWithEmail(withEmail: currentUser.email) { (result) in
            switch result {
            case .failure(let error):
                print("There was an error fetching the user in Firestore: \(error.localizedDescription)")
            case .success(let user):
                guard let user = user else {return}
                self.db.collection(Constants.users).document(user.uuid).updateData([Constants.email : email])
            }
        }
    }
    
    func updatePassword(withPassword password: String, completion: @escaping (String) -> Void) {
        guard let currentUser = self.currentUser else {return}
        fetchUserWithEmail(withEmail: currentUser.email) { (result) in
            switch result {
            case .failure(let error):
                print("There was an error fetching the user in Firestore: \(error.localizedDescription)")
            case .success(let user):
                guard let user = user else {return}
                self.db.collection(Constants.users).document(user.uuid).updateData([Constants.password : password])
            }
        }
    }
    
    // MARK: - Create
    func saveRecipe(recipe: Recipe, completion: @escaping (Result<Recipe, RecipeError>) -> Void) {
        let recipeUID = UUID().uuidString ?? UUID().uuidString
        let recipeAuthorID = UserController.shared.currentUser?.uuid
        let recipeDictionary:[String: Any] = [
            Constants.recipeLabel : recipe.label,
            Constants.recipeImage : recipe.image ?? "",
            Constants.recipeDirections : recipe.directions,
            Constants.recipeIngredients : recipe.ingredients,
            Constants.recipeYield : recipe.yield,
            Constants.recipeTotalTime : recipe.totalTime,
            Constants.recipeUID : recipeUID,
            Constants.recipeIsChecked : recipe.isChecked,
            Constants.dateToEat : recipe.dateToEat,
            Constants.authorID : recipeAuthorID ?? ""
        ]
        
        db.collection(Constants.recipeContainer).document(recipeUID).setData(recipeDictionary) { (error) in
            if let error = error {
                print(RecipeError.badData, error.localizedDescription)
                completion(.failure(.badData))
            } else {
                print("Success! Recipe('s) created and stored!")
                self.recipe = recipe
                completion(.success(recipe))
            }
        }
    }
    
    func saveMealPlan(mealPlan: MealPlan, completion: @escaping (Result<MealPlan, MealPlanError>) -> Void) {
        let mealPlanUID = UUID().uuidString
        let mealPlanAuthorID = UserController.shared.currentUser?.uuid
        let mealPlanDictionary: [String: Any] = [
            Constants.mealPlanName : mealPlan.mealPlanName,
            Constants.startDate : mealPlan.startDate,
            Constants.endDate : mealPlan.endDate,
            Constants.mealPlanRecipes : mealPlan.encodedRecipes,
            Constants.authorID : mealPlanAuthorID ?? "",
            Constants.mealPlanUID : mealPlanUID
        ]
        
        db.collection(Constants.mealPlanContainer).document(mealPlanUID).setData(mealPlanDictionary) { (error) in
            if let error = error {
                print(MealPlanError.badData, error.localizedDescription)
                completion(.failure(.badData))
            } else {
                print("Success! Meal Plan created and stored")
                self.mealPlan = mealPlan
                completion(.success(mealPlan))
            }
        }
    }
    
    // MARK: - Fetch
    func fetchRecipe(completion: @escaping (Result<[Recipe], RecipeError>) -> Void) {
        RecipeController.shared.savedRecipes = []
        db.collection(Constants.recipeContainer).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                guard let query = querySnapshot else { return }
                var fetchedRecipes: [Recipe] = []
                for document in query.documents {
                    print("\(document.documentID) => \(document.data())")
                    guard let recipe = Recipe(document: document.data()) else
                    { return completion(.failure(.badData)) }
                    
                    fetchedRecipes.append(recipe)
                }
                let filteredRecipes = fetchedRecipes.filter {
                    $0.authorID == UserController.shared.currentUser?.uuid }
                RecipeController.shared.savedRecipes = fetchedRecipes
                return completion(.success(filteredRecipes))
            }
        }
    }
    
    func fetchMealPlans(completion: @escaping (Result<[MealPlan], MealPlanError>) -> Void) {
        MealPlanController.shared.mealPlans = []
        db.collection(Constants.mealPlanContainer).getDocuments { (querySnapshot, error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
                return completion(.failure(.fireError(error)))
            } else {
                guard let query = querySnapshot else { return }
                var fetchedMealPlans: [MealPlan] = []
                for document in query.documents {
                    print("\(document.documentID) => \(document.data())")
                    guard let mealPlan = MealPlan(document: document.data()) else
                    { return completion(.failure(.badData)) }
                    
                    fetchedMealPlans.append(mealPlan)
                }
                let filteredMealPlans = fetchedMealPlans.filter {
                    $0.authorID == UserController.shared.currentUser?.uuid }
                MealPlanController.shared.mealPlans = fetchedMealPlans
                return completion(.success(filteredMealPlans))
            }
        }
    }
    // MARK: - Delete
    func deleteRecipe(recipe: Recipe) {
        db.collection(Constants.recipeContainer).document(recipe.uid!).delete() { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
            } else {
                print("Deleted it! pogChampion")
            }
        }
    }
    
    func deleteMealPlan(mealPlan: MealPlan) {
        db.collection(Constants.mealPlanContainer).document(mealPlan.mealPlanUID!).delete() { (error) in
            if let error = error {
                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
            } else {
                print("Deleted it! pogChampion")
            }

        }
    }
    
    //    func deleteMealPlanRecipe(mealPlan: MealPlan, recipe: Recipe) {
    //        db.collection(Constants.mealPlanContainer).document(mealPlan.mealPlanUID!).updateData([Constants.mealPlanRecipes: FieldValue.delete()]) { (error) in
    //            if let error = error {
    //                print("Error in \(#function) : \(error.localizedDescription) \n---/n \(error)")
    //            } else {
    //                print("Deleted it! pogChampion")
    //            }
    //        }
    //    }

    
} // End of Class
