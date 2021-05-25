//
//  PostService.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/23.
//

import UIKit
import Firebase

struct PostService {
    
    static func uploadPost(caption: String, image: UIImage, completion: @escaping(FirestoreCompletion)) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        
        ImageUploader.uploadImage(image: image) { imageUrl in
            let data = ["caption": caption, "timestamp": Timestamp(date: Date()), "likes": 0, "imageUrl": imageUrl, "ownerUid": uid] as [String : Any]
            
            COLLECTION_POSTS.addDocument(data: data, completion: completion)
        }
        
    }
    
    static func fetchPost(completion: @escaping([Post]) -> Void) {
        COLLECTION_POSTS.getDocuments { snapshot, error in
            guard let docs = snapshot?.documents else { return }
            
            let posts = docs.map({ Post(postId: $0.documentID, dictionary: $0.data())})
            completion(posts)
        }
    }
}
