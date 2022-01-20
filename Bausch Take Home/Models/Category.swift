//
//  Category.swift
//  Bausch Take Home
//
//  Created by Tim Bausch on 1/10/22.
//

import Foundation

struct Category: Decodable {
    var strCategory: String
    var strCategoryThumb: String
}

struct CategoryList: Decodable {
    var categories: [Category]
}

