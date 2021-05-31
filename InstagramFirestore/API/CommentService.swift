//
//  CommentService.swift
//  InstagramFirestore
//
//  Created by jh on 2021/06/01.
//

import Firebase

struct CommentService {
    
    static func uploadComment(comment: String, postID: String, user: User, completion: @escaping(FirestoreCompletion)) {
        
        let data: [String: Any] = ["uid": user.uid, "comment": comment,
                                   "timestamp": Timestamp(date: Date()),
                                   "userName": user.userName,
                                   "profileImageUrl": user.profileImageUrl]
        
        COLLECTION_POSTS.document(postID).collection("comments").addDocument(data: data, completion: completion)
        
    }
    
    static func fetchComments() {
        
    }
}
