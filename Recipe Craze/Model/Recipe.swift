//
//  Recipe.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/7/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation

struct RecipeList2: Codable {
    var feed: [ContentList]
}

struct ContentList: Codable {
    
    var id: String
    var name: String
    var image: String
    var rating: Double
    var duration: String
    var review: Int
    var hdRecipeImage: Videos?
    var numberOfServings: Int
    var sourceUrl: String
    
    var ownerName: String
    var ownerProfilePic: String
    
    var nutritionArray: [Nutrition]? = [Nutrition]()
    var ingredientArray: [Ingredient]? = [Ingredient]()

    var preparationSteps: [String]
    
    private enum RootKeys: String, CodingKey {
        case content
        case display
        case seo
    }
    
    private enum SeoKeys: String, CodingKey {
        case web
    }
    
    private enum WebKeys: String, CodingKey {
        case sourceUrl = "link-tags"
    }
    
    private enum DisplayKeys: String, CodingKey {
        case profile = "profiles" // array of profiles
    }
    
    private enum ContentKeys: String, CodingKey {
        case details
        case reviews
        case nutrition
        case ingredient = "ingredientLines" // array of ingredients
        case preparationSteps // string array of preparationSteps
        case videos // dict
        
    }
    
//    private enum VideosKeys: String, CodingKey {
//        case hdRecipeImage = "snapshotUrl"
//    }
    
    private enum NutritionKeys: String, CodingKey {
        case nutritionArray = "nutritionEstimates" // array of nutritionEstimates
    }
    
    private enum ReviewsKeys: String, CodingKey {
        case review = "totalReviewCount"
        case rating = "averageRating"
    }
    
    private enum DetailsKeys: String, CodingKey {
        case id = "recipeId"
        case name
        case image = "images" // array of images
//        case rating
        case duration = "totalTime"
        case numberOfServings
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        let contentContainer = try rootContainer.nestedContainer(keyedBy: ContentKeys.self, forKey: .content)
        let reviewsContainer = try contentContainer.nestedContainer(keyedBy: ReviewsKeys.self, forKey: .reviews)

        let sourceUrlContainer = try rootContainer.nestedContainer(keyedBy: SeoKeys.self, forKey: .seo)
        let webContainer = try sourceUrlContainer.nestedContainer(keyedBy: WebKeys.self, forKey: .web)

        let displayContainer = try rootContainer.nestedContainer(keyedBy: DisplayKeys.self, forKey: .display)
        let detailsContainer = try contentContainer.nestedContainer(keyedBy: DetailsKeys.self, forKey: .details)
        let nutritionContainer = try contentContainer.nestedContainer(keyedBy: NutritionKeys.self, forKey: .nutrition)

        self.ingredientArray = try contentContainer.decode([Ingredient].self, forKey: .ingredient)
        self.preparationSteps = try contentContainer.decode([String]?.self, forKey: .preparationSteps) ?? []
        self.hdRecipeImage = try contentContainer.decodeIfPresent(Videos.self, forKey: .videos)

        let urlContainer = try webContainer.decode([SourceUrl].self, forKey: .sourceUrl)
        let imagesContainer = try detailsContainer.decode([Images].self, forKey: .image)
        let ownerContainer = try displayContainer.decode([Profiles].self, forKey: .profile)
        //Decode nutrition array then pass decoded array to the variable nutritionArray
        self.nutritionArray = try nutritionContainer.decode([Nutrition].self, forKey: .nutritionArray)
        
        self.id = try detailsContainer.decode(String.self, forKey: .id)
        self.name = try detailsContainer.decode(String.self, forKey: .name)
//        self.rating = try detailsContainer.decode(Int.self, forKey: .rating)
        self.duration = try detailsContainer.decode(String.self, forKey: .duration)
        self.numberOfServings = try detailsContainer.decode(Int.self, forKey: .numberOfServings)
        self.review = try reviewsContainer.decode(Int.self, forKey: .review)
        self.rating = try reviewsContainer.decode(Double.self, forKey: .rating)
        
//        self.hdRecipeImage = try videosContainer.decode(String?.self, forKey: .hdRecipeImage) ?? ""
        
        self.sourceUrl = urlContainer.first?.href ?? ""
        self.image = imagesContainer.first?.resizableImageUrl ?? ""
        self.ownerName = ownerContainer.first?.displayName ?? ""
        self.ownerProfilePic = ownerContainer.first?.pictureUrl ?? ""
//        self.ingredientLine = ingredientContainer.first?.ingredient ?? ""
        
    }
}

struct SourceUrl: Codable {
    var href: String
}

struct Videos: Codable {
    
    let snapshotUrl: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.snapshotUrl = try container.decode(String.self, forKey: .snapshotUrl)
    }
}


struct Ingredient: Codable {
    var ingredient: String
    
    private enum RootKeys: String, CodingKey {
        case ingredient = "wholeLine"
    }
    
    init(from decoder: Decoder) throws {
        let rootContainer = try decoder.container(keyedBy: RootKeys.self)
        self.ingredient = try rootContainer.decode(String.self, forKey: .ingredient)
    }
}

struct Nutrition: Codable {
    
    var nutrientName: String
    var nutrientAmount: Double
    var percentDailyValue: Double
    
    private enum RootKeys: String, CodingKey {
        case nutrientName = "attribute"
        case nutrientAmount = "value"
        case display // object
    }
    
    private enum DailyValueKeys: String, CodingKey {
        case percentDailyValue
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let dailyContainer = try container.nestedContainer(keyedBy: DailyValueKeys.self, forKey: .display)
        
        self.percentDailyValue = try dailyContainer.decode(Double?.self, forKey: .percentDailyValue) ?? 0.0
        self.nutrientName = try container.decode(String.self, forKey: .nutrientName)
        self.nutrientAmount = try container.decode(Double.self, forKey: .nutrientAmount)
    }
}

struct Images: Codable {
    
    let resizableImageUrl: String
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.resizableImageUrl = try container.decode(String.self, forKey: .resizableImageUrl)
    }
}

struct Profiles: Codable {
    
    let displayName: String
    let pictureUrl: String
    
    private enum RootKeys: String, CodingKey {
        case ownerName = "displayName"
        case ownerProfilePic = "pictureUrl"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        self.displayName = try container.decode(String.self, forKey: .ownerName)
        self.pictureUrl = try container.decode(String.self, forKey: .ownerProfilePic)
    }
}











struct RecipeList: Codable {
    var feed: [DisplayList]
}

struct DisplayList: Codable {
    
//    var display: [Display]
    var displayName: String

    private enum RootKeys: String, CodingKey {
        case display
    }
    
    private enum DisplayKeys: String, CodingKey {
        case displayName
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: RootKeys.self)
        let displayTheName = try container.nestedContainer(keyedBy: DisplayKeys.self, forKey: .display)
        self.displayName = try displayTheName.decode(String.self, forKey: .displayName)
    }
}


struct Recipe: Hashable, Codable, Identifiable {
    var id: Int
    var name: String
    var image: String
    var rating: Int
    var review: Int
    var duration: Int
    var fats: Int
    var calories: Int
//    var owner: String
}
