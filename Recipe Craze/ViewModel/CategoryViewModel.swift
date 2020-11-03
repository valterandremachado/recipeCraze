//
//  CategoryViewModel.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/1/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation

struct CategoryViewModel: Codable {
    
    var id: Int
    var name: String
    var image: String
    var duration: Int
    var numberOfServings: Int
    
    var ingredientArray = [IngredientArray]()
    var preparationStepsArray = [StepArray]()
    var nutritionArray = [NutritionArray]()
    
    init(recipeModel: RecipeResults){
        
        self.id = recipeModel.recipeId
        self.name = recipeModel.recipeName
        self.image = recipeModel.recipeImage
        self.duration = recipeModel.durationInMinutes
        self.numberOfServings = recipeModel.servings
        
        self.nutritionArray = recipeModel.nutritionArray
        self.ingredientArray = recipeModel.ingredientArray
        self.preparationStepsArray = recipeModel.stepArray.first?.steps ?? []
    }
}
