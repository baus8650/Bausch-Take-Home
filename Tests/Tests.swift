//
//  Tests.swift
//  Tests
//
//  Created by Tim Bausch on 1/7/22.
//

import XCTest
@testable import Bausch_Take_Home

final class Tests: XCTestCase {
    
    let timeout: TimeInterval = 5
    var expectation: XCTestExpectation!
    
    override func setUp() {
        
        expectation = expectation(description: "Server responds in reasonable time")
    }
    
    // MARK: - Category Tests
    
    func test_fetchCategories() {
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.expectation.fulfill() }
            
            XCTAssertNil(error)
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(CategoryList.self, from: data)
                )
            } catch { }
        }
        .resume()
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_fetchCategoriesCount() {
        
        NetworkManager().fetchCategories { categories in
            defer { self.expectation.fulfill() }
            XCTAssertEqual(categories.count, 14, "This API should return 14 meal categories.")
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    // MARK: - Meals By Category Tests
    
    func test_fetchMealsByCategory() {
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=Seafood")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.expectation.fulfill() }
            
            XCTAssertNil(error)
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(Meals.self, from: data)
                )
            } catch { }
        }
        .resume()
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_fetchSeafoodMealsCount() {
        
        var localMeals = [[MealsInCategory]]()
        NetworkManager().fetchMealsByCategory(with: ["Seafood"]) { mealsByCategory in
            defer { self.expectation.fulfill() }
            localMeals.append(mealsByCategory[0])
            let meals = localMeals.flatMap { $0 }
            XCTAssertEqual(meals.count, 27, "There should be 27 meals in the Seafood category")
        }
        
        waitForExpectations(timeout: timeout)
        
    }
    
    func test_fetchDessertMealsCount() {
        
        var localMeals = [[MealsInCategory]]()
        NetworkManager().fetchMealsByCategory(with: ["Dessert"]) { mealsByCategory in
            defer { self.expectation.fulfill() }
            localMeals.append(mealsByCategory[0])
            let meals = localMeals.flatMap { $0 }
            XCTAssertEqual(meals.count, 64, "There should be 64 meals in the Dessert category")
        }
        
        waitForExpectations(timeout: timeout)
        
    }
    
    func test_fetchGoatMealsCount() {
        
        var localMeals = [[MealsInCategory]]()
        NetworkManager().fetchMealsByCategory(with: ["Goat"]) { mealsByCategory in
            defer { self.expectation.fulfill() }
            localMeals.append(mealsByCategory[0])
            let meals = localMeals.flatMap { $0 }
            XCTAssertEqual(meals.count, 1, "There should be 1 meal in the Goat category")
        }
        
        waitForExpectations(timeout: timeout)
        
    }
    
    // MARK: - Individual Meal Tests
    
    func test_fetchMealsByID() {
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.expectation.fulfill() }
            
            XCTAssertNil(error)
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(Meals.self, from: data)
                )
            } catch { }
        }
        .resume()
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_fetchRandomMeal() {
        
        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/random.php")!
        URLSession.shared.dataTask(with: url) { data, response, error in
            defer { self.expectation.fulfill() }
            
            XCTAssertNil(error)
            do {
                let response = try XCTUnwrap(response as? HTTPURLResponse)
                XCTAssertEqual(response.statusCode, 200)
                
                let data = try XCTUnwrap(data)
                XCTAssertNoThrow(
                    try JSONDecoder().decode(Meals.self, from: data)
                )
            } catch { }
        }
        .resume()
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_ingredientsNotNil() {
        
        var recipe = [Int: [String: String]]()
        
        NetworkManager().fetchMealDetail(
            with: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772"
        ) { meal in
            defer { self.expectation.fulfill() }
            
            recipe = meal.generateRecipe()
            for i in 1...recipe.count {
                XCTAssertNotNil(recipe[i]?.keys.first, "No ingredient should be nil.")
                XCTAssertNotEqual(recipe[i]!.keys.first, "", "No ingredient should have a value of blank.")
                XCTAssertNotNil(recipe[i]!.values.first, "No measurement should be nil.")
                XCTAssertNotEqual(recipe[i]!.values.first, "", "No measurement should have a value of blank.")
            }
            XCTAssertEqual(recipe.count, 9, "This recipe should containe 9 ingredient/measurement pairs.")
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_instructionsNotEmpty() {
        
        NetworkManager().fetchMealDetail(
            with: "https://www.themealdb.com/api/json/v1/1/lookup.php?i=52772"
        ) { meal in
            defer { self.expectation.fulfill() }
            
            XCTAssertNotEqual(meal.strInstructions, "", "Instructions should not be blank")
        }
        waitForExpectations(timeout: timeout)
    }
    
    func test_ingredientsNotNilRandom() {
        
        var recipe = [Int: [String: String]]()
        
        NetworkManager().fetchMealDetail(
            with: "https://www.themealdb.com/api/json/v1/1/random.php"
        ) { meal in
            defer { self.expectation.fulfill() }
            
            recipe = meal.generateRecipe()
            for i in 1...recipe.count {
                XCTAssertNotNil(recipe[i]?.keys.first, "No ingredient should be nil.")
                XCTAssertNotEqual(recipe[i]!.keys.first, "", "No ingredient should have a value of blank.")
                XCTAssertNotNil(recipe[i]!.values.first, "No measurement should be nil.")
                XCTAssertNotEqual(recipe[i]!.values.first, "", "No measurement should have a value of blank.")
            }
        }
        
        waitForExpectations(timeout: timeout)
    }
    
    func test_instructionsNotEmptyRandom() {
        
        NetworkManager().fetchMealDetail(
            with: "https://www.themealdb.com/api/json/v1/1/random.php"
        ) { meal in
            defer { self.expectation.fulfill() }
            
            XCTAssertNotEqual(meal.strInstructions, "", "Instructions should not be blank")
        }
        waitForExpectations(timeout: timeout)
    }
    
}
