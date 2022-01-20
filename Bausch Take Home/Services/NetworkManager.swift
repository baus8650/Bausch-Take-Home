//
//  NetworkAPI.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/6/22.
//

import Foundation

class NetworkManager {
//
    func fetchCategories(completion: @escaping([String]) -> Void) {

        let urlSession = URLSession.shared
        let urlString: String
        urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        let url = URL(string: urlString)!
        let fetch = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }

            guard let jsonCategory = try? JSONDecoder().decode(Categories.self, from: data) else {
                return
            }

            let categories = jsonCategory.categories.map { $0.strCategory }.sorted()

            DispatchQueue.main.async {
                completion(categories)
            }
        }

        fetch.resume()
    }

    func fetchMealsByCategory(with categories: [String], completion: @escaping ([[MealsInCategory]]) -> Void) {

        let urlSession = URLSession.shared

        var urlString: String
        var localCategory: String
        var meals = [[MealsInCategory]]()

        for i in 0..<categories.count {
            meals.append([])
            localCategory = categories[i]
            urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(localCategory)"
            let url = URL(string: urlString)!
            let fetch = urlSession.dataTask(with: url) { data, response, error in
                guard let data = data else {
                    return
                }

                guard let jsonMeal = try? JSONDecoder().decode(Meals.self, from: data) else {
                    return
                }

                let localMeal = jsonMeal.meals
                let sorted = localMeal.sorted{ $0.strMeal < $1.strMeal }
                meals[i] = sorted
                if meals.count == categories.count {
                    DispatchQueue.main.async {
                        completion(meals)
                    }
                }

            }
            fetch.resume()

        }
    }


    func fetchMealDetail(with urlString: String, completion: @escaping (Meal) -> Void) {

        let urlSession = URLSession.shared

        let url = URL(string: urlString)!

        let fetch = urlSession.dataTask(with: url) { data, response, error in
            guard let data = data else {
                return
            }

            guard let jsonMeal = try? JSONDecoder().decode(MealDetail.self, from: data) else {
                return
            }

            let meal = jsonMeal.meals[0]

            DispatchQueue.main.async {
                completion(meal)
            }

        }
        fetch.resume()

    }
}
    

class CategoryRequest:  NSObject {
    
    private let url: URL
    
    enum CategoryRequestError: Error {
        case invalidResponse
        case noData
        case failedRequest
        case invalidData
    }
    
    
    override init() {
        self.url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
    }
    
    func fetchCategories(completion: @escaping (Categories?, CategoryRequestError?) -> Void) {
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                
                guard error == nil else {
                    print("Failed to fetch categories: \(error!.localizedDescription)")
                    completion(nil, .failedRequest)
                    return
                }
                
                guard let data = data else {
                    print("No data returned from mealdb")
                    completion(nil, .noData)
                    return
                }
                
                guard let response = response as? HTTPURLResponse else {
                  print("Unable to process type response")
                  completion(nil, .invalidResponse)
                  return
                }
                
                guard response.statusCode == 200 else {
                  print("Failure response from mealdb: \(response.statusCode)")
                  completion(nil, .failedRequest)
                  return
                }
                
                do {
                    let decoder = JSONDecoder()
                    let categoryData: Categories = try decoder.decode(Categories.self, from: data)
                    completion(categoryData, nil)
                } catch {
                    print("Unable to decode category response: \(error.localizedDescription)")
                    completion(nil, .invalidData)
                }
            }
        }.resume()
    }
    
}

