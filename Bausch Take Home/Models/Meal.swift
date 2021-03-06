//
//  Recipes.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import Foundation

struct MealsInCategory: Decodable {
    var strMeal: String
    var strMealThumb: String
    var idMeal: String
}

struct Meals: Decodable {
    var meals: [MealsInCategory]
}

struct MealDetail: Decodable {
    var meals: [Meal]
}

struct Meal: Decodable {
    var idMeal: String
    var strMeal: String
    var strInstructions: String
    var strMealThumb: String
    
    var strIngredient1: String?
    var strIngredient2: String?
    var strIngredient3: String?
    var strIngredient4: String?
    var strIngredient5: String?
    var strIngredient6: String?
    var strIngredient7: String?
    var strIngredient8: String?
    var strIngredient9: String?
    var strIngredient10: String?
    var strIngredient11: String?
    var strIngredient12: String?
    var strIngredient13: String?
    var strIngredient14: String?
    var strIngredient15: String?
    var strIngredient16: String?
    var strIngredient17: String?
    var strIngredient18: String?
    var strIngredient19: String?
    var strIngredient20: String?
    var strMeasure1: String?
    var strMeasure2: String?
    var strMeasure3: String?
    var strMeasure4: String?
    var strMeasure5: String?
    var strMeasure6: String?
    var strMeasure7: String?
    var strMeasure8: String?
    var strMeasure9: String?
    var strMeasure10: String?
    var strMeasure11: String?
    var strMeasure12: String?
    var strMeasure13: String?
    var strMeasure14: String?
    var strMeasure15: String?
    var strMeasure16: String?
    var strMeasure17: String?
    var strMeasure18: String?
    var strMeasure19: String?
    var strMeasure20: String?
    
    func generateRecipe() -> [Int: [String: String]] {
        var recipe = [Int: [String: String]]()
        let ingredients = [strIngredient1, strIngredient2, strIngredient3, strIngredient4, strIngredient5, strIngredient6, strIngredient7, strIngredient8, strIngredient9, strIngredient10, strIngredient11, strIngredient12, strIngredient13, strIngredient14, strIngredient15, strIngredient16, strIngredient17, strIngredient18, strIngredient19, strIngredient20]
        let measurements = [strMeasure1, strMeasure2, strMeasure3, strMeasure4, strMeasure5, strMeasure6, strMeasure7, strMeasure8, strMeasure9, strMeasure10, strMeasure11, strMeasure12, strMeasure13, strMeasure14, strMeasure15, strMeasure16, strMeasure17, strMeasure18, strMeasure19, strMeasure20]
        
        for i in 0..<ingredients.count {
            guard let localIngredient = ingredients[i] else { break }
            //            var localMeasurement = ""
            //            if measurements[i] != nil {
            //                localMeasurement = measurements[i]!
            //            } else {
            //                localMeasurement = ""
            //            }
            let localMeasurement = measurements[i] ?? ""
            //            guard let localMeasurement = measurements[i] else { break }
            if localIngredient != "" {
                recipe[i+1] = [localIngredient: localMeasurement]
            }
        }
        return recipe
    }
    
}




