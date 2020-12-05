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
    
//    @objc dynamic var id = 0
    @objc dynamic var realmUserUID: String? = nil

//    @objc dynamic var name: String? = nil
//    @objc dynamic var image: Data? = nil //UIImage? = nil
//    @objc dynamic var isFavorited = false
    
    override static func primaryKey() -> String? {
       return "realmUserUID"
    }
    
    convenience init(realmUserUID: String){
        self.init()
//        self.id = id
        self.realmUserUID = realmUserUID
    }
    
}
