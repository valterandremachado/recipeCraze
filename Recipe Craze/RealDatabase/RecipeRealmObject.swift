//
//  RecipeRealmObject.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 6/20/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import RealmSwift

class RecipeRealmObject: Object {
    
    @objc dynamic var id: String? = nil
    @objc dynamic var realmUserUID: String? = nil
    @objc dynamic var userFirstName: String? = nil
//    @objc dynamic var image: Data? = nil //UIImage? = nil
//    @objc dynamic var isFavorited = false
    
    override static func primaryKey() -> String? {
       return "id"
    }
    
    convenience init(id: String, realmUserUID: String, userFirstName: String){
        self.init()
        self.id = id
        self.realmUserUID = realmUserUID
        self.userFirstName = userFirstName
    }
    
}
