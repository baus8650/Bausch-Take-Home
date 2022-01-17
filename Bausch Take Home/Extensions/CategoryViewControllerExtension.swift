//
//  CategoryViewControllerExtension.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/12/22.
//

import Foundation
import UIKit

extension CategoryViewController: UISearchBarDelegate {
    
    
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
        }
        
        for category in searchCategories {
            categoryIndices.append(categories.firstIndex(of: category)!)
        }
        for meal in categoryIndices {
            searchMeals.append(meals[meal])
        }
        isSearching = true
        
        tableView.reloadData()
        
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        
        isSearching = false
        searchBar.text = ""
        categoryIndices = [Int]()
        searchCategories = [String]()
        searchMeals = [[MealsInCategory]]()
        
//        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
