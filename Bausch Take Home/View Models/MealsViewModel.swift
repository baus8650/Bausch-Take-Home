//
//  MealsViewModel.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation

public class MealsViewModel {
    
    let networkManager: NetworkManager?
    
    var categories: [String]?
    var meals: Box<[[MealsInCategory]]?> = Box([])
    
//    let networkManager: NetworkManager?
    
    init(for categories: [String]) {
        networkManager = NetworkManager()
        self.categories = categories
        networkManager?.fetchMealsByCategory(with: categories, completion: { [weak self] meals in
            self?.meals.value = meals
        })
    }
    
    func getMeals() {
        networkManager?.fetchMealsByCategory(with: categories ?? [], completion: { [weak self] meals in
//            let categories = categoryData.categories.map { $0.strCategory }.sorted()
//            print("INSIDE MEALS MODEL \(meals)")
            self?.meals.value = meals
        })
    }
    
//    func getCategories() {
//        networkManager?.fetchCategories(completion: { categories in
//            print("INSIDE VIEW MODEL \(categories)")
//            self.categories.value = categories
//
//        })
//    }
    
}
