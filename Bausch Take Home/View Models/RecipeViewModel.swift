//
//  RecipeTableDataSources.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit


class RecipeViewModel: NSObject {
    
    // MARK: - Properties
    
    var networkManager: NetworkManager?
    var loadingViewController: ActivityIndicator?
    var tableDataSource: RecipeTableDataSource?
    
    var categories = [String]() {
        didSet {
            self.networkManager?.fetchMealsByCategory(with: self.categories) { meals in
                self.meals = meals
            }
        }
    }
    
    var meals = [[MealsInCategory]]() {
        didSet {
            populateTable(categories: self.categories, meals: self.meals)
            loadingViewController?.remove()
        }
    }
    
    var searchCategories = [String]()
    var searchMeals = [[MealsInCategory]]()
    var categoryIndices = [Int]()
    var isSearching: Bool?
    
    var tableView: UITableView?
    
    // MARK: - Initializer
    
    init(controller: UIViewController, tableView: UITableView) {
        loadingViewController = ActivityIndicator()
        controller.add(loadingViewController!)
        self.isSearching = false
        self.tableView = tableView
        super.init()
        fetchCategories()
    }
    
    // MARK: - Helper Functions
    
    func populateTable(categories: [String], meals: [[MealsInCategory]]) {
        tableDataSource = RecipeTableDataSource(categories: categories, meals: meals, tableView: self.tableView!)
        self.tableView?.dataSource = tableDataSource
        
        self.tableView?.reloadData()
    }
    
    func fetchCategories() {
        self.networkManager = NetworkManager()
        self.networkManager?.fetchCategories { fetchedCategories in
            self.categories = fetchedCategories
        }
    }
    
    
}

// MARK: - Extensions

extension RecipeViewModel: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        categoryIndices = [Int]()
        searchCategories = [String]()
        searchMeals = [[MealsInCategory]]()
        
        let searchTerms = searchText.lowercased().components(separatedBy: " ").filter { $0 != "" }
        searchCategories = categories.filter { cat in
            for term in searchTerms{
                if cat.lowercased().contains(term){
                    return true
                }
            }
            return false
        }
        
        if searchText == "" {
            isSearching = false
            searchCategories = categories
            populateTable(categories: self.categories, meals: self.meals)
        }
        
        for category in searchCategories {
            categoryIndices.append(categories.firstIndex(of: category)!)
        }
        for meal in categoryIndices {
            searchMeals.append(meals[meal])
        }
        isSearching = true
        populateTable(categories: self.searchCategories, meals: self.searchMeals)
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        searchBar.text = ""
        categoryIndices = [Int]()
        searchCategories = [String]()
        searchMeals = [[MealsInCategory]]()
        populateTable(categories: self.categories, meals: self.meals)
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

