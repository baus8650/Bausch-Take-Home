//
//  DetailViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    let networkManager = NetworkManager()
    
    var meal: Meal? {
        didSet {
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
                self.indicator.hidesWhenStopped = true
                let image = self.meal?.strMealThumb
                let imageURL = URL(string: image!)
                if let imageData = try? Data(contentsOf: imageURL!) {
                    self.mealImage.image = UIImage(data: imageData)
                }
                self.navigationItem.title = self.meal?.strMeal
                self.instructionsText.text = self.meal?.strInstructions
                self.instructionsText.backgroundColor = .secondarySystemGroupedBackground
                self.instructionsLabel.text = "Instructions"
                self.sectionTitle = "Ingredients"
                self.recipe = self.meal?.generateRecipe()
                self.ingredientsTable.reloadData()
            }
        }
    }
    
    var recipe: [Int: [String: String]]?
    var urlString: String?
    var sectionTitle = ""
    
    var indicator = UIActivityIndicatorView()
    
    // MARK: - IBOutlets
    
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var mealImage: UIImageView!
    @IBOutlet var instructionsText: UITextView!
    @IBOutlet var ingredientsTable: UITableView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingredientsTable.dataSource = self
        ingredientsTable.delegate = self
        
        activityIndicator()
        indicator.startAnimating()
        
        instructionsText.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        instructionsText.layer.cornerRadius = 10

        let queue = DispatchQueue.global()
        
        queue.async {
            if self.urlString == nil {
                self.urlString = "https://www.themealdb.com/api/json/v1/1/random.php"
            }
            
            self.networkManager.fetchMealDetail(with: self.urlString!) { meal in
                self.meal = meal
            }
        }
    }
    
    // MARK: - Helper Properties
    
    func activityIndicator() {
        
        indicator = UIActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 50, height: 50))
        indicator.style = UIActivityIndicatorView.Style.large
        indicator.center = self.view.center
        self.view.addSubview(indicator)
        
    }
    
}

// MARK: - Extensions

extension DetailViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return sectionTitle
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return recipe?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RecipeCell", for: indexPath) as! RecipeTableViewCell
        cell.ingredientLabel.text = recipe?[indexPath.row+1]?.keys.first
        cell.measurementLabel.text = recipe?[indexPath.row+1]?.values.first
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else { return }
        header.textLabel?.textColor = UIColor(named: "default")
        header.textLabel?.text = header.textLabel?.text?.capitalized
        header.textLabel?.font = UIFont.boldSystemFont(ofSize: 22)
        header.textLabel?.frame = header.bounds
    }
    
}
