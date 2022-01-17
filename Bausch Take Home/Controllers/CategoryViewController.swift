//
//  CategoryViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit


class CategoryViewController: UITableViewController {
    
    // MARK: - Properties
    
    let networkManager = NetworkManager()
    
    var indexPath: IndexPath?
    var offsetLocation: CGPoint?
    
    var categories = [String]() {
        didSet {
            let queue = DispatchQueue.global()
            queue.async {
                self.networkManager.fetchMealsByCategory(with: self.categories) { meals in
                    self.meals = meals
                }
            }
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let scrollOffset = offsetLocation {
            tableView.contentOffset = scrollOffset
            tableView.reloadData()
        } else {
            return
        }
    }
    
    var meals = [[MealsInCategory]]() {
        didSet {
            self.tableView.reloadData()
            self.indicator.stopAnimating()
            self.indicator.hidesWhenStopped = true
        }
    }
    var searchCategories = [String]()
    var searchMeals = [[MealsInCategory]]()
    var categoryIndices = [Int]()
    var isSearching: Bool?
    var indicator = UIActivityIndicatorView()
    
    let semaphore = DispatchSemaphore(value: 1)
    let queue = DispatchQueue.global()
    
    // MARK: - IBOutlets
    
    @IBOutlet var searchBar: UISearchBar!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "Recipes"
        
        
        
        activityIndicator()
        indicator.startAnimating()
        searchBar.delegate = self
        isSearching = false
        
        self.tableView.keyboardDismissMode = .onDrag
        
        self.networkManager.fetchCategories(completion: { categories in
            self.categories = categories
        })
        
    }
    
    // MARK: - Helper Functions
    
    func activityIndicator() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        
        if isSearching! {
            return searchCategories.count
        } else {
            return categories.count
        }
        
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        if isSearching! {
            return searchCategories[section]
        } else {
            return categories[section]
        }
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if isSearching! {
            return searchMeals[section].count
        } else {
            return meals[section].count
        }
        
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! CategoryTableViewCell
        
        if isSearching! {
            let title = searchMeals[indexPath.section][indexPath.row].strMeal
            cell.titleLabel.text = title
        } else {
            let title = meals[indexPath.section][indexPath.row].strMeal
            cell.titleLabel.text = title
        }
        
        return cell
        
    }
    
    override func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(named: "default")
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        header.textLabel?.frame = header.bounds
        
    }
    
    override func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 40
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "ListToDetail" {
            
            let detailVC = segue.destination as! DetailViewController
            indexPath = tableView.indexPathForSelectedRow!
            offsetLocation = tableView.contentOffset
            let mealID: String
            
            if isSearching! {
                mealID = searchMeals[indexPath!.section][indexPath!.row].idMeal
            } else {
                mealID = meals[indexPath!.section][indexPath!.row].idMeal
            }
            
            detailVC.urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
            
        }
    }
    
}

// MARK: - Extensions


