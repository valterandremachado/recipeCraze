//
//  RecipePost.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 4/24/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation

struct FavoritedRecipe: Codable {
    let name: String
//    var hasFavorited: Bool
}

struct Recipes {
    var names: [FavoritedRecipe]
//    let image: String
//    let calories: Float
//    let fats: Double
//    let duration: Int
}
