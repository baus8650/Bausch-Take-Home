//
//  DetailViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit

class DetailViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
    
    @IBOutlet var mealImage: UIImageView!
    
    @IBOutlet var instructionsText: UITextView!
    @IBOutlet var ingredientsTable: UITableView!
    
    var nameLabel: String?
    var mealID: String?
    var recipe: [Int: [String: String]]?
    var urlString: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let queue = DispatchQueue.global()
        ingredientsTable.dataSource = self
        ingredientsTable.delegate = self
        
        queue.async {
            if self.urlString == nil {
                self.urlString = "https://www.themealdb.com/api/json/v1/1/random.php"
            }
            self.fetchMealJSON(with: self.urlString!)
        }
    }
    
    func fetchMealJSON(with urlString: String) {
        if let url = URL(string: urlString) {
            if let data = try? Data(contentsOf: url) {
                parseMeal(json: data)
            }
        }
    }
    
    func parseMeal(json: Data) {
        let decoder = JSONDecoder()
        if let jsonMeal = try? decoder.decode(MealDetail.self, from: json) {
            let image = jsonMeal.meals[0].strMealThumb
            let name = jsonMeal.meals[0].strMeal
            let instructions = jsonMeal.meals[0].strInstructions
            let imageURL = URL(string: image)
            recipe = jsonMeal.meals[0].generateRecipe()
            
            DispatchQueue.main.async {
                if let imageData = try? Data(contentsOf: imageURL!) {
                    self.mealImage.image = UIImage(data: imageData)
                }
                self.navigationItem.title = name
                self.instructionsText.text = instructions
                self.ingredientsTable.reloadData()
            }
        }
        
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
    
}