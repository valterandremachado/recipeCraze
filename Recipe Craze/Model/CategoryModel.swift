//
//  CategoryModel.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 10/23/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation

struct RecipeResultsArray: Codable {
    var results: [RecipeResults]
}

struct RecipeResults: Codable {
    var recipeId: Int
    var recipeName: String
    var recipeImage: String
    var durationInMinutes: Int
    var servings: Int
    
    var ingredientArray = [IngredientArray]()
    var stepArray = [InstructionArray]()
    var nutritionArray = [NutritionArray]()
   
    private enum RootKeys: String, CodingKey {
        case sourceName
        case extendedIngredients
        case steps = "analyzedInstructions"
        case nutrition
        
        case recipeId = "id"
        case recipeName = "title"
        case recipeImage = "image"
        case servings
        case durationInMinutes = "readyInMinutes"
    }
    
    private enum NutritionKeys: String, CodingKey {
        case nutrients
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let nutritionContainer = try rootContainer.nestedContainer(keyedBy: NutritionKeys.self, forKey: .nutrition)
        
        nutritionArray = try nutritionContainer.decode([NutritionArray].self, forKey: .nutrients)
        ingredientArray = try rootContainer.decode([IngredientArray].self, forKey: .extendedIngredients)
        stepArray = try rootContainer.decode([InstructionArray].self, forKey: .steps)
        
        recipeName = try rootContainer.decode(String?.self, forKey: .recipeName) ?? ""
        recipeImage = try rootContainer.decode(String?.self, forKey: .recipeImage) ?? ""
        recipeId = try rootContainer.decode(Int?.self, forKey: .recipeId) ?? 0
        servings = try rootContainer.decode(Int?.self, forKey: .servings) ?? 0
        durationInMinutes = try rootContainer.decode(Int?.self, forKey: .durationInMinutes) ?? 0

    }
}

struct IngredientArray: Codable {
    var ingredient: String
    
    private enum RootKeys: String, CodingKey {
        case ingredient = "original"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        ingredient = try container.decode(String?.self, forKey: .ingredient) ?? ""
    }
}

struct InstructionArray: Codable {
    var steps: [StepArray]
    
    private enum RootKeys: String, CodingKey {
        case steps
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        steps = try container.decode([StepArray].self, forKey: .steps)
    }
}

struct StepArray: Codable {
    var step: String
    
    private enum RootKeys: String, CodingKey {
        case step
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        step = try container.decode(String?.self, forKey: .step) ?? ""
    }
}

struct NutritionArray: Codable {
    
    var title: String
    var amount: Double
    var unit: String
    var percentOfDailyNeeds: Double

    private enum RootKeys: String, CodingKey {
        case title
        case amount
        case unit
        case percentOfDailyNeeds
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        
        title = try container.decode(String?.self, forKey: .title) ?? ""
        amount = try container.decode(Double?.self, forKey: .amount) ?? 0
        unit = try container.decode(String?.self, forKey: .unit) ?? ""
        percentOfDailyNeeds = try container.decode(Double?.self, forKey: .percentOfDailyNeeds) ?? 0
    }
    
}

