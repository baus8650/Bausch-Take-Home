//
//  RecipeTableDataSource.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation
import UIKit

class RecipeTableDataSource: NSObject, UITableViewDataSource {
    
    // MARK: - Properties
    
    var sectionArray = [String]()
    var object = [[MealsInCategory]]()
    var tableView: UITableView?
    
    // MARK: - Initializer
    
    init(categories: [String], meals: [[MealsInCategory]], tableView: UITableView) {
        self.sectionArray = categories
        self.object = meals
        self.tableView = tableView
    }
    
    // MARK: - TableView Data Source Methods
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return self.sectionArray.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        
        return self.sectionArray[section]
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.object[section].count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "MealCell", for: indexPath) as! CategoryTableViewCell
        
        let title = self.object[indexPath.section][indexPath.row].strMeal
        cell.titleLabel.text = title
        
        
        return cell
        
    }
    
}
