//
//  NetworkAPI.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/6/22.
//

import Foundation

class NetworkManager {
    
    func fetchCategoryJSON() -> [String] {
        
        let urlString: String
        urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                var categories = [String]()
                let decoder = JSONDecoder()
                
                if let jsonCategory = try? decoder.decode(Categories.self, from: data) {
                    categories = jsonCategory.categories.map { $0.strCategory }.sorted()
                    return categories
                }
            }
        }
        return []
    }
    
    func fetchMealsJSON(with categories: [String]) -> [[MealsInCategory]] {
        var urlString: String
        var localCategory: String
        var meals = [[MealsInCategory]]()
        
        for i in 0..<categories.count {
            localCategory = categories[i]
            urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(localCategory)"
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    let decoder = JSONDecoder()
                    if let jsonMeal = try? decoder.decode(Meals.self, from: data) {
                        let localMeal = jsonMeal.meals
                        let sorted = localMeal.sorted{ $0.strMeal < $1.strMeal }
                        meals.append(sorted)
                        if meals.count == categories.count {
                            return meals
                        }
                    }
                }
            }
        }
        
        return [[]]
        
    }
    
}
