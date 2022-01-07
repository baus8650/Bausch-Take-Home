//
//  NetworkAPI.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/6/22.
//

import Foundation

class NetworkManager {
    
    var buildMeals = [[MealsInCategory]]()
    
    func categoryRequest(with url: URL, completion: @escaping (Result<[String], Error>) -> Void) {
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            guard let jsonCategory = try? JSONDecoder().decode(Categories.self, from: data) else {
                return
            }
            let categories = jsonCategory.categories.map { $0.strCategory }.sorted()
            
            DispatchQueue.main.async {
                completion(.success(categories))
            }
        }
        task.resume()
    }
    
    func mealRequest (with url: URL, categories: [String], completion: @escaping(Result<[[MealsInCategory]], Error>) -> Void) {
        let fetchMeals = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print(error)
                return
            }
            
            guard let data = data else { return }
            
            guard let jsonMeal = try? JSONDecoder().decode(Meals.self, from: data) else {
                return
            }
            
            let localMeal = jsonMeal.meals
            let sorted = localMeal.sorted{ $0.strMeal < $1.strMeal }
            self.buildMeals.append(sorted)
            
            if self.buildMeals.count == categories.count {
                DispatchQueue.main.async {
                    completion(.success(self.buildMeals))
                }
            }
        }
        fetchMeals.resume()
    }
    
    
    
}
