//
//  UserAuthViewModel.swift
//  Recipe Craze
//
//  Created by Valter A. Machado on 11/10/20.
//  Copyright © 2020 Machado Dev. All rights reserved.
//

import Foundation
import FirebaseAuth
import FirebaseStorage
import FirebaseDatabase

// Singleton
protocol UserRegistrationSingleton {
    func didSignUpUser(didFetchInfo state: Bool, name: String, email: String, profileImageUrl: String, numberOfFaveRecipes: Int)
    func userRegistrationCallBack(errorMessage: String)
}

/// This class  is for storing purposes only
class UserRegistrationViewModel {
    
    var delegate: UserRegistrationSingleton?
    static let shared = UserRegistrationViewModel()
        
    var didFetchCurrentUserInfo = false
    
    // Create userObject
    func createUserWith(_ userObject: User) {
        let firebaseAuth = Auth.auth()
        firebaseAuth.createUser(withEmail: userObject.email, password: userObject.password) { [self] (result, error) in
            switch error {
            case .none:
                
                guard let uid = result?.user.uid else { return }

                let storageRef = Storage.storage().reference(forURL: "gs://recipeapp-39b49.appspot.com").child("profile_image").child(uid)

                let metadata = StorageMetadata()
                metadata.contentType = "image/jpg"
                                
                storageRef.putData(userObject.selectedImageUrl, metadata: metadata) { (storageMetadata, error) in
                    if error != nil {
                        print(error!.localizedDescription)
                        return
                    } else {
                        // MARK: - Storing profileImage, username and email in the firebase (Auth and Storage)
                        storageRef.downloadURL { (url, error) in
                            if let profileImageUrl = url?.absoluteString {
                                // When user is created successfully store user info to firebaseDB
                                let db = Database.database().reference()
                                let useRef = db.child("users")
                                let newUserRef = useRef.child(uid)
                                newUserRef.updateChildValues(["id": uid,
                                                     "firstName": userObject.firstName,
                                                     "lastName": userObject.lastName,
                                                     "email": userObject.email,
                                                     "password": userObject.password,
                                                     "profileImageUrl": profileImageUrl])
                                
                                print("signup")
                                fetchCurrentUserInfo()
                            }
                        }
                    }
                }
                
            case .some(_):
                print("Couldn't Signup the user. because of " + error!.localizedDescription)
                delegate?.userRegistrationCallBack(errorMessage: error!.localizedDescription)
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
            
            uid != nil ? (self.didFetchCurrentUserInfo = true) : (self.didFetchCurrentUserInfo = false)

            db.observeSingleEvent(of: .value) { [self] (snapshot) in

                if let dict = snapshot.value as? [String: AnyObject] {
                    // retrive data from firebase snapshot
//                    let id = dict["id"] as? String ?? ""
                    let profileImageUrl = dict["profileImageUrl"] as? String ?? ""
                    let firstName = dict["firstName"] as? String ?? ""
//                    let lastName = dict["lastName"] as? String ?? ""
                    let email = dict["email"] as? String ?? ""
//                    let password = dict["password"] as? String ?? ""
//                    let location = dict["location"] as? String ?? ""
                    let numberOfFaveRecipes = dict["numberOfFaveRecipes"] as? Int ?? 0
                    
//                    self.firstName = firstName!
                    delegate?.didSignUpUser(didFetchInfo: didFetchCurrentUserInfo, name: firstName, email: email, profileImageUrl: profileImageUrl, numberOfFaveRecipes: numberOfFaveRecipes)
                    print("backEndIsPresenting: \(self.didFetchCurrentUserInfo)")
                    
                } // End of dic block
                
            } // End of observeSingleEvent block
            
        }
    }
    
    
}
