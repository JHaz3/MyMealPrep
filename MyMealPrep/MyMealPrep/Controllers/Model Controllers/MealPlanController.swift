//
//  MealPlanController.swift
//  MyMealPrep
//
//  Created by Jake Haslam on 2/12/21.
//

import Foundation

class MealPlanController {
    // MARK: - Properties
    static let shared: MealPlanController = MealPlanController()
    var mealPlans: [MealPlan] = [] {
        didSet {
            saveToPersistentStorage()
        }
    }
    
    // MARK: - CRUD Methods
    func createMealPlan(with startDate: Date, endDate: Date) {
        let numberOfSecondsInDay: Double = 60 * 60 * 24
        let numberOfDays = daysBetween(startDate: startDate.startOfDay() ?? Date(),
                                       endDate: endDate.startOfDay() ?? Date())
        var dates: [Date] = [startDate.startOfDay() ?? Date()]
        for _ in 0...numberOfDays {
            guard let newDate = dates.last?.addingTimeInterval(numberOfSecondsInDay) else { continue }
            dates.append(newDate)
        }
        let mealPlan = MealPlan(mealPlanName: "\(formatDate(date: startDate) ) - \(formatDate(date: endDate))", startDate: startDate, endDate: endDate, recipes: [])
        mealPlans.append(mealPlan)
    }
    
    func updateMealPlanRecipes(mealPlan: MealPlan, recipes: [Recipe]) {
        mealPlan.recipes = recipes
        saveToPersistentStorage()
    }
    
    func updateMPDates(mealPlan: MealPlan, startDate: Date, endDate: Date) {
        mealPlan.startDate = startDate
        mealPlan.endDate = endDate
        saveToPersistentStorage()
    }
    
    func deleteMealPlan(mealPlan: MealPlan) {
        guard let index = mealPlans.firstIndex(of: mealPlan) else { return }
        mealPlans.remove(at: index)
        UserController.shared.deleteMealPlan(mealPlan: mealPlan)
        saveToPersistentStorage()
    }
    
    func deleteMPRecipe(mealPlan: MealPlan, recipe: Recipe) {
        guard let index = mealPlan.recipes.firstIndex(of: recipe) else { return }
        mealPlan.recipes.remove(at: index)
        saveToPersistentStorage()
    }
    
    // MARK: - Methods
    private func daysBetween(startDate: Date, endDate: Date) -> Int {
        let calendar = Calendar.current
        let components = calendar.dateComponents([.day], from: startDate, to: endDate)
        
        return components.day ?? 0
    }
    
    private func formatDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .none
        return formatter.string(from: date)
    }
    
    
    //MARK: - Persistence
    func fileURL() -> URL {
        let urls = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileName = "MyMealPrep.json"
        let documentDirectory = urls[0]
        let documentsDirectoryURL = documentDirectory.appendingPathComponent(fileName)
        return documentsDirectoryURL
    }
    func saveToPersistentStorage() {
        let encoder = JSONEncoder()
        do {
            let data = try encoder.encode(mealPlans)
            try data.write(to: fileURL())
        } catch let error {
            print("There was an error saving to persistent storage: \(error)")
        }
    }
    func loadFromPersistence() {
        let jsonDecoder = JSONDecoder()
        do {
            let data = try Data(contentsOf: fileURL())
            let decodedData = try jsonDecoder.decode([MealPlan].self, from: data)
            self.mealPlans = decodedData
        } catch let error {
            print("\(error.localizedDescription) -> \(error)")
        }
    }
}// End of Class

// MARK: - Extensions
fileprivate extension Date {
    func startOfDay() -> Date? {
        return Calendar.current.date(bySettingHour: 0, minute: 0, second: 0, of: self)
    }
}
