//
//  CategoryViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit


class CategoryViewController: UITableViewController {
    
    // MARK: - Properties
    
    var viewModel: RecipeViewModel?
    var tableDelegate: RecipeTableDelegate?
    var offsetLocation: CGPoint?
    
    
    // MARK: - IBOutlets
    
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recipes"
        
        tableDelegate = RecipeTableDelegate()
        viewModel = RecipeViewModel(controller: self, tableView: self.tableView)
        self.tableView.delegate = tableDelegate
        self.tableView.dataSource = viewModel?.tableDataSource
        self.tableView.keyboardDismissMode = .onDrag
        self.searchBar.delegate = viewModel
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if let scrollOffset = offsetLocation {
            self.tableView.contentOffset = scrollOffset
            self.tableView.reloadData()
        } else {
            return
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ListToDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            offsetLocation = tableView.contentOffset
            let mealID: String
            
            if viewModel?.isSearching == true {
                mealID = (viewModel?.searchMeals[indexPath.section][indexPath.row].idMeal)!
            } else {
                mealID = (viewModel?.meals[indexPath.section][indexPath.row].idMeal)!
            }
            
            detailVC.urlString = mealID
        }
    }
}
