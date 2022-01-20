//
//  CategoryViewModel.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/19/22.
//

import Foundation

public class CategoryViewModel {
    
    let categoryRequest: CategoryRequest?
    let networkManager: NetworkManager?
    
    var categories: Box<[String]?> = Box([])
    
//    let networkManager: NetworkManager?
    
    init() {
        categoryRequest = CategoryRequest()
        networkManager = NetworkManager()
    }
    
    func getCategories() {
        networkManager?.fetchCategories(completion: { [weak self] categoryData in
//            let categories = categoryData.categories.map { $0.strCategory }.sorted()
            self?.categories.value = categoryData
        })
    }
    
//    func getCategories() {
//        networkManager?.fetchCategories(completion: { categories in
//            print("INSIDE VIEW MODEL \(categories)")
//            self.categories.value = categories
//
//        })
//    }
    
}
