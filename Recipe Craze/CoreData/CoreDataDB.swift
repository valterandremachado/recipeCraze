//
//  CoreDataDB.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 10/2/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import CoreData

final class CoreDataDB: NSObject {
        
    // MARK: - Persistence Manager
    let persistenceManager: PersistenceManager
    
    // MARK: - Main Init
    init(persistenceManager: PersistenceManager) {
        self.persistenceManager = persistenceManager
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Methods
    func createFavoritedPost(id: String, name: String, image: UIImage?, ingredArray: [String]?, duration: String?, servingsNo: Int32?, prepArray: [String]?, nutriArray: [Any]?, isFavorited: Bool) {
        let favoritedPost = FavoritedRecipeToCD(context: persistenceManager.context)
        favoritedPost.id = id
        favoritedPost.name = name
        // Converting UIImage to Binary Data
        let imageData = image?.jpegData(compressionQuality: 0.5)
        favoritedPost.image = imageData
        favoritedPost.duration = duration!
        favoritedPost.servingsNo = servingsNo!
        favoritedPost.isFavorited = isFavorited
        // Convert arrays to data to facilitate put them in the coreData
        let ingredArrayToData = try! JSONSerialization.data(withJSONObject: ingredArray!, options: [])
        let prepArrayToData = try! JSONSerialization.data(withJSONObject: prepArray!, options: [])
        let nutriArrayToData = try! JSONSerialization.data(withJSONObject: nutriArray!, options: [])
        favoritedPost.ingredientCDArray = ingredArrayToData
        favoritedPost.preparationCDArray = prepArrayToData
        favoritedPost.nutritionCDArray = nutriArrayToData

//        print("stringArrayToData: \(stringArrayToData)")
        persistenceManager.save()
    }
    
    @discardableResult func checkIfItemExist(id: String, name: String, image: UIImage?, ingredArray: [String]?, duration: String?, servingsNo: Int32?, prepArray: [String]?, nutriArray: [Any]?, isFavorited: Bool) -> Bool {
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedRecipeToCD")
        fetchRequest.fetchLimit =  1
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        do {
            let count = try persistenceManager.context.count(for: fetchRequest)
            if count > 0 {
                print("The item you're trying to add already exist in the db")
                return true
            } else {
                createFavoritedPost(id: id, name: name, image: image, ingredArray: ingredArray, duration: duration, servingsNo: servingsNo, prepArray: prepArray, nutriArray: nutriArray, isFavorited: isFavorited)
                return false
            }
        }catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
            return false
        }
    }
    
    func deleteItem(name: String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "FavoritedRecipeToCD")
        fetchRequest.predicate = NSPredicate(format: "name == %@", name)
        
        do {
            let objects = try persistenceManager.context.fetch(fetchRequest)
            for object in objects {
                persistenceManager.context.delete(object)
            }
            try persistenceManager.context.save()
        } catch _ {
            // error handling
        }
    }
    
    func getFavoritedPost() {
//        guard let favoritedPost = try! persistenceManager.context.fetch(FavoritedPost.fetchRequest()) as? [FavoritedPost] else { return }
        let favoritedPost = persistenceManager.fetch(FavoritedRecipeToCD.self)
        favoritedPost.forEach({ print($0.image as Any) })
    }
    
    
    func resetAllRecords(in entity : String) // entity = Your_Entity_Name
    {
        
        let context = persistenceManager.context
        let deleteFetch = NSFetchRequest<NSFetchRequestResult>(entityName: entity)
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: deleteFetch)
        do
        {
            try context.execute(deleteRequest)
            try context.save()
        }
        catch
        {
            print ("There was an error")
        }
    }
    
}
