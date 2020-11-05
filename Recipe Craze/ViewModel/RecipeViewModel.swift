//
//  RecipeViewModel.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 10/2/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation
import UIKit

struct RecipeViewModel: Codable {
    
    var id: Int
    var name: String
    var image: String
    var rating: Int
    var review: Int
    var duration: Int
    var fats: Int
    var calories: Int
    
    // Dependency Injection (DI)
    init(recipe: Recipe) {
        self.id = recipe.id
        self.name = recipe.name
        self.image = recipe.image
        self.rating = recipe.rating
        self.review = recipe.review
        self.duration = recipe.duration
        self.fats = recipe.fats
        self.calories = recipe.calories
        //        fetchCourses()
    }
    
}

struct RecipeViewModel2: Codable {
    
    var id: String
    var name: String
    var image: String
    var rating: Double
    var review: Int
    var duration: String
    var ownerName: String
    var ownerPic: String
    var numberOfServings: Int
    var hdRecipeImage: String
    var sourceUrl: String

    var nutrientArray: [Nutrition]? = [Nutrition]()
    var ingredientArray: [Ingredient]? = [Ingredient]()
    var preparationStepsArray: [String]
//    var fats: Int
//    var calories: Int
        
    // Dependency Injection (DI)
    init(recipe: ContentList) {
        self.id = recipe.id
        self.name = recipe.name
        self.image = recipe.image
        self.rating = recipe.rating
        self.duration = recipe.duration
        self.review = recipe.review
        self.ownerName = recipe.ownerName
        self.ownerPic = recipe.ownerProfilePic
        self.numberOfServings = recipe.numberOfServings
        self.hdRecipeImage = recipe.hdRecipeImage?.snapshotUrl ?? ""
        self.sourceUrl = recipe.sourceUrl
        
        self.nutrientArray = recipe.nutritionArray
        self.ingredientArray = recipe.ingredientArray
        self.preparationStepsArray = recipe.preparationSteps
    }
    
    
}
