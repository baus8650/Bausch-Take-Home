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
    
    var categories = [String]() {
        didSet {
            DispatchQueue.main.async {
                print("categories changed", self.categories)
            }
        }
    }
    var searchCategories = [String]()
    var meals = [[MealsInCategory]]() {
        didSet {
            DispatchQueue.main.async {
                print("meals have changed", self.meals)
            }
//            DispatchQueue.main.async {
//                if self.meals.count == self.categories.count {
                    
//                    self.tableView.reloadData()
//                }
//            }
        }
    }
    var searchMeals = [[MealsInCategory]]()
    var categoryIndices = [Int]()
    var isSearching: Bool?
    var indicator = UIActivityIndicatorView()
    
    
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
        
        let catURL = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
        populateMeals(catURL: catURL)

    
    }
    // MARK: - TESTING
    
    func populateMeals(catURL: URL) {
        
        var localCategory: String?
        
        networkManager.categoryRequest(with: catURL) { [weak self] result in
            switch result {
            case .success(let categories):
                self?.categories = categories
                for i in 0..<categories.count {
                    localCategory = categories[i]
                    let urlString = "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(localCategory!)"
                    let url = URL(string: urlString)
                    self?.networkManager.mealRequest(with: url!, categories: categories) { [weak self] result in
                        switch result {
                        case .success(let meals):
                            self?.meals = meals
                            if self?.meals.count == self?.categories.count {
                                DispatchQueue.main.async {
                                    self?.indicator.stopAnimating()
                                    self?.indicator.hidesWhenStopped = true
                                    self?.tableView.reloadData()
                                }
                            }
                        default:
                            self?.meals = [[MealsInCategory]]()
                        }
                    }
                }
            default:
                self?.categories = [String]()
            }
        }
    }
    
    // MARK: - Helper Functions
    
    func performFetching() {

        let semaphore = DispatchSemaphore(value: 0)
        
        semaphore.signal()
            let url = URL(string: "https://www.themealdb.com/api/json/v1/1/categories.php")!
            self.newFetchCategories(with: url) { [weak self] result in
                switch result {
                case .success(let categories):
                    var localCategory: String
                    for i in 0..<categories.count {
                        localCategory = categories[i]
                        let url = URL(string: "https://www.themealdb.com/api/json/v1/1/filter.php?c=\(localCategory)")
                        self?.newFetchMeals(with: url!) { [weak self] result in
                            switch result {
                            case .success(let meals):
                                DispatchQueue.main.async {
                                    self?.meals = meals
                                }
                            default:
                                self?.meals = []
                            }
                        }
                    }
                    DispatchQueue.main.async{
                        
                    }
                default:
                    self?.categories = []
                    
                }
            }
        
        

    }
    
    func newFetchCategories (with url: URL, completion: @escaping(Result<[String], Error>) -> Void) {
        let fetchCategories = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jsonCategory = try? JSONDecoder().decode(Categories.self, from: data) {
                    DispatchQueue.main.async {
                        self.categories = jsonCategory.categories.map { $0.strCategory }.sorted()
                        completion(.success(self.categories))
                    }
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        fetchCategories.resume()
    }
    
    func newFetchMeals (with url: URL, completion: @escaping(Result<[[MealsInCategory]], Error>) -> Void) {
        let fetchMeals = URLSession.shared.dataTask(with: url) { data, response, error in
            if let data = data {
                if let jsonMeal = try? JSONDecoder().decode(Meals.self, from: data) {
                    let localMeal = jsonMeal.meals
                    let sorted = localMeal.sorted{ $0.strMeal < $1.strMeal }
                    self.meals.append(sorted)
                    print("IN THE FUNCTION \(self.meals.count)")
                }
            } else if let error = error {
                print("HTTP Request Failed \(error)")
            }
        }
        fetchMeals.resume()
    }
    
//    func getCategories(withRequest request: URLRequest, withCompletion completion: @escaping (String?, Error?) -> Void) {
//        let task = URLSession.shared.dataTask(with: request) { (data: Data?, response: URLResponse?, error: Error?) in
//            if error != nil {
//                completion(nil, error)
//                return
//            }
//            else if let data = data {
//                do {
//                    guard let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String:Any] else {completion(nil, nil);return}
//                    guard let details = json["detail"] as? String else {completion(nil, nil);return}
//                    completion(details, nil)
//                }
//                catch {
//                    completion(nil, error)
//                }
//            }
//        }
//        task.resume()
//    }
    
    func activityIndicator() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
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
    
    func parseCategory(json: Data) {
        
        let decoder = JSONDecoder()
        
        if let jsonCategory = try? decoder.decode(Categories.self, from: json) {
            categories = jsonCategory.categories.map { $0.strCategory }.sorted()
        }
        
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
    
    func parseMeal(json: Data) {
        
        let decoder = JSONDecoder()
        if let jsonMeal = try? decoder.decode(Meals.self, from: json) {
            let localMeal = jsonMeal.meals
            let sorted = localMeal.sorted{ $0.strMeal < $1.strMeal }
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
            let indexPath = tableView.indexPathForSelectedRow!
            let mealID: String
            
            if isSearching! {
                mealID = searchMeals[indexPath.section][indexPath.row].idMeal
            } else {
                mealID = meals[indexPath.section][indexPath.row].idMeal
            }
            
            detailVC.urlString = "https://www.themealdb.com/api/json/v1/1/lookup.php?i=\(mealID)"
            
        }
    }
    
}

// MARK: - Extensions

extension CategoryViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        categoryIndices = [Int]()
        searchCategories = [String]()
        searchMeals = [[MealsInCategory]]()
        searchCategories = categories.filter({$0.prefix(searchText.count) == searchText})
        
        for i in searchCategories {
            categoryIndices.append(categories.firstIndex(of: i)!)
        }
        for i in categoryIndices {
            searchMeals.append(meals[i])
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
        
        tableView.reloadData()
        
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}
