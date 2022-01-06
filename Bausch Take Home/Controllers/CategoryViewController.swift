//
//  CategoryViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit

class CategoryViewController: UITableViewController {

    var categories = [String]()
    var meals = [[MealsInCategory]]()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let semaphore = DispatchSemaphore(value: 1)
        let queue = DispatchQueue.global()
        
        queue.async {
            semaphore.wait()
            self.fetchCategoryJSON()
            semaphore.signal()
        }
        
        queue.async {
            semaphore.wait()
            self.fetchMealsJSON(for: self.categories)
            semaphore.signal()
        }
        
        DispatchQueue.main.async {
            semaphore.wait()
            self.tableView.reloadData()
            semaphore.signal()
        }
        
    }
    
    func fetchCategoryJSON() {
        let urlString: String
        urlString = "https://www.themealdb.com/api/json/v1/1/categories.php"
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseCategory(json: data)
                return
            }
        }
        performSelector(onMainThread: #selector(showError), with: nil, waitUntilDone: false)
    }
    
    func fetchMealsJSON(for categories: [String]) {
        var urlString: String
        var localCategory: String
        for i in 0..<categories.count {
            localCategory = categories[i]
            urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(localCategory)"
            if let url = URL(string: urlString) {
                if let data = try? Data(contentsOf: url) {
                    parseMeal(json: data)
                }
            }
        }
    }
    
    func parseCategory(json: Data) {
        let decoder = JSONDecoder()
        if let jsonCategory = try? decoder.decode(Categories.self, from: json) {
            categories = jsonCategory.categories.map { $0.strCategory }.sorted()
        }
    }
    
    func parseMeal(json: Data) {
        let decoder = JSONDecoder()
        if let jsonMeal = try? decoder.decode(Meals.self, from: json) {
            let localMeal = jsonMeal.meals
            let sorted = localMeal.sorted{ $0.strMeal < $1.strMeal } // Fairly certain meals are loaded alphabetically to begin with, but just to be safe
            meals.append(sorted)
            
        }
    }

    @objc func showError() {
        let ac = UIAlertController(title: "Loading error", message: "There was a problem loading the data; please check your connection and try again.", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac,animated: true)
    }
    
    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return categories.count
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return categories[section]
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return meals[section].count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! CategoryTableViewCell
        let title = meals[indexPath.section][indexPath.row].strMeal
        cell.titleLabel.text = title
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ListToDetail" {
            let detailVC = segue.destination as! DetailViewController
            let indexPath = tableView.indexPathForSelectedRow!
            detailVC.mealID = meals[indexPath.section][indexPath.row].idMeal
        }
    }

}
