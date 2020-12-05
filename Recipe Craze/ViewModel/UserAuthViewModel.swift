//
//  UserListViewModels.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/11/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

// Singleton
protocol UserAuthSingleton: class {
    func didEndFetchingUserInfo(didFetchInfo state: Bool, userUID: String, firstName: String, lastName: String, email: String, profileImageUrl: String, numberOfFaveRecipes: Int)
    func userAuthCallBack(errorMessage: String)
}

/// This class is for retriving data purposes only
class UserAuthViewModel {
    
    weak var delegate: UserAuthSingleton?
    static let shared = UserAuthViewModel()
    
    var didFetchCurrentUserInfo = false
    
    func signInUserWith(_ email: String,_ password: String) {
        Auth.auth().signIn(withEmail: email, password: password) { [self] (result, error) in
            
            switch error {
            case .none:
                fetchCurrentUserInfo()
            case .some(_):
                delegate?.userAuthCallBack(errorMessage: error!.localizedDescription)
                print("Couldn't login the user. because of " + error!.localizedDescription)
            }
            
        }
    }
    
    func fetchCurrentUserInfo() { 
        if Auth.auth().currentUser == nil {
            print("User is not signed in.")
        }
        else
        {
            print("FetchingUserInfo...")
            let uid = Auth.auth().currentUser?.uid
            let db = Database.database().reference().child("users").child(uid!)
            // Check if current user is signed in order to fetch his/her profile info, and change isPresent state in order to pass the info to the singletonDelegate
            uid != nil ? (self.didFetchCurrentUserInfo = true) : (self.didFetchCurrentUserInfo = false)
            
            db.observeSingleEvent(of: .value) { [self] (snapshot) in
                
                if let dict = snapshot.value as? [String: AnyObject] {
                    // retrive data from firebase snapshot
                    let id = dict["id"] as? String ?? ""
                    let profileImageUrl = dict["profileImageUrl"] as? String ?? ""
                    let firstName = dict["firstName"] as? String ?? ""
                    let lastName = dict["lastName"] as? String ?? ""
                    let email = dict["email"] as? String ?? ""
//                    let password = dict["password"] as? String ?? ""
//                    let location = dict["location"] as? String ?? ""
                    let numberOfFaveRecipes = dict["numberOfFaveRecipes"] as? Int ?? 0
                    
                    delegate?.didEndFetchingUserInfo(didFetchInfo: didFetchCurrentUserInfo, userUID: id, firstName: firstName, lastName: lastName, email: email, profileImageUrl: profileImageUrl, numberOfFaveRecipes: numberOfFaveRecipes)
//                    print("backEndIsPresenting: \(didFetchCurrentUserInfo)")
                    
                } // End of dic block
                
            } // End of observeSingleEvent block
            
        }
    }
    
    
}
