//
//  AuthService.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/11.
//

import UIKit
import Firebase

struct AuthCredentials {
    let email: String
    let password: String
    let fullName: String
    let userName: String
    let profileImage: UIImage
}

struct AuthService {
    static func logUserIn(withEmail email: String, password: String, completion: AuthDataResultCallback?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: completion)
    }
    
    static func registerUser(withCredentials credentials: AuthCredentials, completion: @escaping (Error?) -> Void) {
        
        print("DEBUG: Credentials are \(credentials)")
        
        ImageUploader.uploadImage(image: credentials.profileImage) { imageUrl in
            
            Auth.auth().createUser(withEmail: credentials.email, password: credentials.password) { result, error in
                
                if let error = error {
                    print("DEBUG: Failed to register user \(error.localizedDescription)")
                    return
                }
                
                guard let uid = result?.user.uid else { return }
                
                let data: [String: Any] = ["email": credentials.email,
                                           "fullName": credentials.fullName,
                                           "profileImageUrl": imageUrl,
                                           "uid": uid,
                                           "userName": credentials.userName]
                
                COLLECTION_USERS.document(uid).setData(data, completion: completion)
                
            }
        }
    }
}
