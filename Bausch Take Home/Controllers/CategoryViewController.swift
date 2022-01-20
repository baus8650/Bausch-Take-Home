//
//  CategoryViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit


class CategoryViewController: UITableViewController {
    
    // MARK: - Properties
    
    var dataSource: RecipeTableDataSource?
    var tableDelegate: RecipeTableDelegate?
    var offsetLocation: CGPoint?
    
    override func viewWillAppear(_ animated: Bool) {
        if let scrollOffset = offsetLocation {
            tableView.contentOffset = scrollOffset
            tableView.reloadData()
        } else {
            return
        }
    }
    
    // MARK: - IBOutlets
    
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recipes"
        
        tableDelegate = RecipeTableDelegate()
        self.tableView.delegate = tableDelegate
        dataSource = RecipeTableDataSource(for: self.tableView, controller: self)
        tableView.dataSource = dataSource
        searchBar.delegate = dataSource
        
        self.tableView.keyboardDismissMode = .onDrag
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ListToDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            offsetLocation = tableView.contentOffset
            let mealID: String
            
            if dataSource?.isSearching == true {
                mealID = (dataSource?.searchMeals[indexPath.section][indexPath.row].idMeal)!
            } else {
                mealID = (dataSource?.meals[indexPath.section][indexPath.row].idMeal)!
            }
            
            detailVC.urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
        }
    }
}

