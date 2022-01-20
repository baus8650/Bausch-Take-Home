//
//  MealDetailViewModel.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit.UIImage

class MealDetailViewModel {
    
    let networkManager = NetworkManager()
    var loadingViewController: ActivityIndicator?
    
    var meal: Meal?
    var tableView: UITableView?
    var dataSource: UITableViewDataSource?
    
    init(for controller: UIViewController, table tableView: UITableView) {
        loadingViewController = ActivityIndicator()
        controller.add(loadingViewController!)
        self.tableView = tableView
        
    }
    
    func populateTable() {
        dataSource = IngredientsTableDataSource(data: self.recipe.value!)
        self.tableView?.dataSource = dataSource
        self.tableView?.reloadData()
    }
    
    var mealURL = Box("")
    var mealImage: Box<UIImage?> = Box(nil)
    var mealTitle = Box("")
    var instructionsText = Box("")
    var recipe: Box<[Int: [String: String]]?> = Box(nil)
    var instructionsLabel = Box("")
    var urlString: String?
    var sectionTitle = ""
    
    func getMealURL(url string: String) {
        self.mealURL.value = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(string)"
        fetchMeal(for: self.mealURL.value)
    }
    
    func fetchMeal(for string: String = "https://www.themealdb.com/api/json/v1/1/random.php") {
        self.networkManager.fetchMealDetail(with: string) { meal in
            self.meal = meal
            let image = meal.strMealThumb
            let imageURL = URL(string: image)
            if let imageData = try? Data(contentsOf: imageURL!) {
                self.mealImage.value = UIImage(data: imageData)
            }
            self.mealTitle.value = meal.strMeal
            self.instructionsText.value = meal.strInstructions
            self.recipe.value = meal.generateRecipe()
            self.instructionsLabel.value = "Instructions"
            self.populateTable()
            self.loadingViewController?.remove()
        }
    }
    
}
