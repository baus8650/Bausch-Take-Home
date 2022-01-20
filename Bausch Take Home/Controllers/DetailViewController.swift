//
//  DetailViewController.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/5/22.
//

import UIKit

class DetailViewController: UIViewController {
    
    // MARK: - Properties
    
    var mealViewModel: MealDetailViewModel?
    var ingrediantsTableDelegate: IngredientsTableDelegate?
    var urlString: String?
    
    // MARK: - IBOutlets
    
    @IBOutlet var instructionsLabel: UILabel!
    @IBOutlet var mealImage: UIImageView!
    @IBOutlet var instructionsText: UITextView!
    @IBOutlet var ingredientsTable: UITableView!
    
    // MARK: - Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ingrediantsTableDelegate = IngredientsTableDelegate()
        ingredientsTable.delegate = ingrediantsTableDelegate
        ingredientsTable.dataSource = mealViewModel?.dataSource
        
        mealViewModel = MealDetailViewModel(for: self, table: self.ingredientsTable)
        if urlString != nil {
            mealViewModel?.getMealURL(url: urlString!)
        } else {
            mealViewModel?.fetchMeal()
        }
        setup()
    }
    
    // MARK: - Helper Functions
    
    func setup() {
        mealViewModel?.mealImage.bind { [weak self] mealImage in
            self?.mealImage.image = mealImage
        }
        
        mealViewModel?.instructionsText.bind { [weak self] text in
            self?.instructionsText.text = text
            self?.instructionsText.textContainerInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
            self?.instructionsText.layer.cornerRadius = 10
            self?.instructionsText.backgroundColor = .secondarySystemGroupedBackground
        }
        
        mealViewModel?.instructionsLabel.bind { [weak self] text in
            self?.instructionsLabel.text = text
        }   
    }
}
