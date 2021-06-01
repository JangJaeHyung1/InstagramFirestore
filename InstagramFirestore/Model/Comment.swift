//
//  Comment.swift
//  InstagramFirestore
//
//  Created by jh on 2021/06/01.
//

import Firebase

struct Comment {
    let uid: String
    let userName: String
    let profileImageUrl: String
    let timestamp: Timestamp
    let commentText: String
    
    init(dictionary: [String: Any]) {
        self.uid = dictionary["uid"] as? String ?? ""
        self.userName = dictionary["userName"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.commentText = dictionary["comment"] as? String ?? ""
        self.timestamp = dictionary["timestamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
