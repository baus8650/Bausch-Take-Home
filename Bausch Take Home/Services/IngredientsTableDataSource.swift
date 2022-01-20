//
//  IngredientsTableDataSource.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit

class IngredientsTableDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var recipe: [Int: [String: String]]?
    
    // MARK: - Initializer
    
    init(data recipe: [Int: [String: String]]) {
        self.recipe = recipe
    }
    
    // MARK: - TableView Data Sources
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "Ingredients"
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
