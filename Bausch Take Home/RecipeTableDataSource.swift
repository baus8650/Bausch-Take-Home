//
//  RecipeTableDataSources.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit


class RecipeTableDataSource: NSObject, UITableViewDataSource {
    
    var networkManager: NetworkManager?
    let loadingViewController: ActivityIndicator?
    
    var categories = [String]() {
        didSet {
            self.networkManager?.fetchMealsByCategory(with: self.categories) { meals in
                self.meals = meals
            }
        }
    }
    
    var meals = [[MealsInCategory]]() {
        didSet {
            
            self.tableView?.reloadData()
            loadingViewController?.remove()
        }
    }
    
    var searchCategories = [String]()
    var searchMeals = [[MealsInCategory]]()
    var categoryIndices = [Int]()
    var isSearching: Bool?
    let tableView: UITableView?
    
    init(for tableView: UITableView, controller: UIViewController) {
        loadingViewController = ActivityIndicator()
        controller.add(loadingViewController!)
        self.isSearching = false
        self.tableView = tableView
        super.init()
        fetchCategories()
    }
    
    func fetchCategories() {
        self.networkManager = NetworkManager()
        self.networkManager?.fetchCategories { fetchedCategories in
            self.categories = fetchedCategories
        }
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        if isSearching == true {
            return searchCategories.count
        } else {
            return categories.count
        }
        
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isSearching == true {
            return searchCategories[section]
        } else {
            return categories[section]
        }
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching == true {
            return searchMeals[section].count
        } else {
            return meals[section].count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! CategoryTableViewCell
        
        if isSearching == true {
            let title = searchMeals[indexPath.section][indexPath.row].strMeal
            cell.titleLabel.text = title
        } else {
            let title = meals[indexPath.section][indexPath.row].strMeal
            cell.titleLabel.text = title
        }
        
        return cell
        
    }
}

extension RecipeTableDataSource: UISearchBarDelegate {
    
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
            tableView?.reloadData()
        }
        
        for category in searchCategories {
            categoryIndices.append(categories.firstIndex(of: category)!)
        }
        for meal in categoryIndices {
            searchMeals.append(meals[meal])
        }
        isSearching = true
        tableView?.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        searchBar.text = ""
        categoryIndices = [Int]()
        searchCategories = [String]()
        searchMeals = [[MealsInCategory]]()
        tableView?.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

