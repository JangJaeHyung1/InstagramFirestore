//
//  User.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/14.
//

import Foundation
import Firebase

struct User {
    let email: String
    let fullName: String
    let profileImageUrl: String
    let userName: String
    let uid: String
    
    var isFollowed = false
    
    var isCurrentUser: Bool { return Auth.auth().currentUser?.uid == uid }
    
    init(dictionary: [String: Any]) {
        self.email = dictionary["email"] as? String ?? ""
        self.fullName = dictionary["fullName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        
    }
}
