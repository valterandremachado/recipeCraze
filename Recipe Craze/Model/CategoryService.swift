//
//  CategoryService.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/1/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation

class CategoryService: NSObject {
    
    static let shared = CategoryService()
    
    func fetchRecipes (/*pagination: Bool = false,*/ mealType: String,  limit: Int, completion: @escaping ([RecipeResults]?, Error?) -> ()) {
        let url = "https://api.spoonacular.com/recipes/complexSearch"
            
        let headers = [
                "Content-Type": "application/json",
        ]
        
        let param = ["apiKey": "b22f28fb671d4c7ba1e37cf19363b694", //myAcc -> cd03dd3f4f204f4cb3dca72ef6e97c14
                     "number": "\(limit)",
//                     "query": "chicken with rice",
                     "fillIngredients": "true",
                     "addRecipeInformation": "true",
                     "instructionsRequired": "false",
                     "addRecipeNutrition": "true",
                     "type": mealType]//breakfast
        
        var urlComponents = URLComponents(string: url)

        var queryItems = [URLQueryItem]()
        for (key, value) in param {
            queryItems.append(URLQueryItem(name: key, value: value))
        }

        urlComponents?.queryItems = queryItems

        var request = URLRequest(url: (urlComponents?.url)!)
        request.httpMethod = "GET"

        for (key, value) in headers {
            request.setValue(value, forHTTPHeaderField: key)
        }


        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch courses:", err)
                return
            }
            
            // check response
            guard let data = data else { return }
//            print(resp)
            
            do {

                let recipes = try JSONDecoder().decode(RecipeResultsArray.self, from: data)
                print("RecipeList: \(recipes.results)")

                DispatchQueue.main.async {
                    completion([recipes].first?.results, nil)
//                    completion(pagination ? [recipes2].first?.feed : [recipes].first?.feed, nil)
                }
                
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
        }.resume()
    }
    
}
