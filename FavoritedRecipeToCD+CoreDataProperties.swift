//
//  FavoritedRecipeToCD+CoreDataProperties.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 10/17/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//
//

import Foundation
import CoreData


extension FavoritedRecipeToCD {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<FavoritedRecipeToCD> {
        return NSFetchRequest<FavoritedRecipeToCD>(entityName: "FavoritedRecipeToCD")
    }

    @NSManaged public var duration: String?
    @NSManaged public var id: String?
    @NSManaged public var image: Data?
    @NSManaged public var ingredientCDArray: Data?
    @NSManaged public var name: String?
    @NSManaged public var nutritionCDArray: Data?
    @NSManaged public var preparationCDArray: Data?
    @NSManaged public var servingsNo: Int32
    @NSManaged public var isFavorited: Bool

}

extension FavoritedRecipeToCD : Identifiable {

}
