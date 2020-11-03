//
//  RecipeService.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 5/25/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation
import FirebaseDatabase

final class RecipeService {
    
    func fetchRecipes<T: Decodable>(_ filename: String, as type: T.Type = T.self) -> T {
        let data: Data
        
        guard let file = Bundle.main.url(forResource: filename, withExtension: nil)
            else {
                fatalError("Couldn't find \(filename) in main bundle.")
        }
        
        do {
            data = try Data(contentsOf: file)
        } catch {
            fatalError("Couldn't load \(filename) from main bundle:\n\(error)")
        }
        
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(T.self, from: data)
        } catch {
            fatalError("Couldn't parse \(filename) as \(T.self):\n\(error)")
        }
    }
}

class Service: NSObject {
    static let shared = Service()
    
    func fetchCourses(completion: @escaping ([Recipe]?, Error?) -> ()) {
//        let headers = [
//            "x-rapidapi-host": "yummly2.p.rapidapi.com",
//            "x-rapidapi-key": "d681da975cmsh96f870b28c81334p15a2a3jsna9db3bed0d9a"
//        ]
        
//        guard let url = URL(string: "https://yummly2.p.rapidapi.com/feeds/list?tag=list.recipe.popular&limit=18&start=0") else { return }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//        request.allHTTPHeaderFields = headers
        
//        let urlString = "https://yummly2.p.rapidapi.com/feeds/list?tag=list.recipe.popular&limit=18&start=0"
//        guard let url = URL(string: urlString) else { return }
        guard let file = Bundle.main.url(forResource: "recipes.json", withExtension: nil) else { return }
        URLSession.shared.dataTask(with: file) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch recipes:", err)
                return
            }
            
            // check response
            guard let data = data else { return }
            print("data: \(data)")
            
            do {
//                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
                print("RecipeList: \(String(describing: recipes))")
                DispatchQueue.main.async {
                    completion(recipes, nil)
                    print("recipes: \(recipes)")
                }
                
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
        }.resume()
    }

    
}




class Service2: NSObject {
    
    static let shared = Service2()
//    var isPagenating = false
    let ref = Database.database().reference()
    /// API Edamam https://api.edamam.com/search?app_key=2f068593f24adb3f5d74514987bf0d7b&app_id=1e04c681&q=chocolate&dish_type=dessert
    let params = ["app_key": "2f068593f24adb3f5d74514987bf0d7b",
                  "app_id":"1e04c681",
                  "q":"chocolate",
                  "dish_type":"dessert"]
    /// API Spoonacular https://api.spoonacular.com/recipes/search?number=2&apiKey=b22f28fb671d4c7ba1e37cf19363b694
    let params2 = ["apiKey": "b22f28fb671d4c7ba1e37cf19363b694",
                   "number":"b22f28fb671d4c7ba1e37cf19363b694",
                   "query": "burger"]
    
    func fetchRecipes (/*pagination: Bool = false,*/ completion: @escaping ([ContentList]?, Error?) -> ()) {
        let headers = [
            "x-rapidapi-host": "yummly2.p.rapidapi.com",
            "x-rapidapi-key": "3b2a8a28c6msheee19c73f506a5fp10101djsn7380e3cacb9c" // host: hana
        ]
        
        guard let url = URL(string: "https://yummly2.p.rapidapi.com/feeds/list?tag=list.recipe.popular&limit=18&start=0") else { return }
        guard let url2 = URL(string: "https://yummly2.p.rapidapi.com/feeds/list-similarities?authorId=Yummly&apiFeedType=moreFrom&start=0&id=15-Minute-Baked-Salmon-with-Lemon-9029477&limit=18") else { return }
        
//        guard let url = URL(string: "https:") else { return }

        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        var request2 = URLRequest(url: url2)
        request2.httpMethod = "GET"
        request2.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch courses:", err)
                return
            }
            
//            var data2: Data?
//            URLSession.shared.dataTask(with: request2) {(data2, response, error) in
//               data2 = data!
            
            

            // check response
            guard let data = data else { return }
//            guard let newData = data2 else { return }
            
            do {
//                                let recipes = try JSONDecoder().decode([Recipe].self, from: data)
//                let recipes2 = try JSONDecoder().decode(RecipeList2.self, from: newData)
                let recipes = try JSONDecoder().decode(RecipeList2.self, from: data)
                print("RecipeList: \(recipes.feed)")
//                print("RecipeList: \(recipes2.feed)")

                DispatchQueue.main.async {
                    completion([recipes].first?.feed, nil)
//                    completion(pagination ? [recipes2].first?.feed : [recipes].first?.feed, nil)
                }
                
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
//            }.resume()
        }.resume()
    }
    
    func fetchRecipesForNewData (/*pagination: Bool = false,*/ completion: @escaping ([ContentList]?, Error?) -> ()) {
        let headers = [
            "x-rapidapi-host": "yummly2.p.rapidapi.com",
            "x-rapidapi-key": "3b2a8a28c6msheee19c73f506a5fp10101djsn7380e3cacb9c" // host: BeStrong
        ]
        
        guard let url = URL(string: "https://yummly2.p.rapidapi.com/feeds/list-similarities?authorId=Yummly&apiFeedType=moreFrom&start=0&id=15-Minute-Baked-Salmon-with-Lemon-9029477&limit=18") else { return }
    
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch courses:", err)
                return
            }

            // check response
            guard let data = data else { return }
            
            do {
                let recipes = try JSONDecoder().decode(RecipeList2.self, from: data)
                print("RecipeList: \(recipes.feed)")

                DispatchQueue.main.async {
                    completion([recipes].first?.feed, nil)
                }
                
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
        }.resume()
    }
    
    
    func fetchCategoryRecipes (completion: @escaping ([ContentList]?, Error?) -> ()) {
        
        
        let headers = [
            "x-rapidapi-host": "yummly2.p.rapidapi.com",
            "x-rapidapi-key": "3b2a8a28c6msheee19c73f506a5fp10101djsn7380e3cacb9c" // host: BeStrong
        ]
        
        
        let appKey = "?app_key=2f068593f24adb3f5d74514987bf0d7b&"
        let appID = "app_id=1e04c681&q"
        let query = "chicken"
//        let dishType = "salad"
        let mealType = "dinner"
        guard let url = URL(string: "https://api.edamam.com/search\(appKey)&\(appID)&q=\(query)&meal_type=\(mealType)") else { return }
    
        
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        
        URLSession.shared.dataTask(with: request) { (data, resp, err) in
            if let err = err {
                completion(nil, err)
                print("Failed to fetch courses:", err)
                return
            }

            // check response
            guard let data = data else { return }
            
            do {
                let recipes = try JSONDecoder().decode(RecipeList2.self, from: data)
                print("RecipeList: \(recipes.feed)")

                DispatchQueue.main.async {
                    completion([recipes].first?.feed, nil)
                }
                
            } catch let jsonErr {
                print("Failed to decode:", jsonErr)
            }
        }.resume()
    }
    
}
