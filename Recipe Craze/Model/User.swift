//
//  User.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/10/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation

struct User {
    
    var id: String
//    var profileImageUrl: String
    var firstName: String
    var lastName: String
    var fullName: String
    var email: String
    var password: String
//    var location: String
    var numberOfFaveRecipes: Int
    var selectedImageUrl: Data

    init(id: String, firstName: String, lastName: String, email: String, password: String, numberOfFaveRecipes: Int, selectedImageUrl: Data) {
        self.id = id
//        self.profileImageUrl = profileImageUrl
        self.firstName = firstName
        self.lastName = lastName
        self.fullName = firstName + lastName
        self.email = email
        self.password = password
//        self.location = location
        self.numberOfFaveRecipes = numberOfFaveRecipes
        self.selectedImageUrl = selectedImageUrl
    }
    
}
