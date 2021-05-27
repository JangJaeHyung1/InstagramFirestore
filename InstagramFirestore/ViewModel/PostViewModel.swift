//
//  PostViewModel.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/26.
//

import Foundation

struct PostViewModel {
    let post: Post
    
    var imageUrl: URL? { return URL(string: post.imageUrl) }
    
    var userProfileImageUrl: URL? { return URL(string: post.ownerImageUrl) }
    
    var userName: String { return post.ownerUserName }
    
    var caption: String { return post.caption }
    
    var likes: Int { return post.likes }
    
    var likesLabelText: String {
        return "좋아요 \(post.likes) 개"
    }
    
    init(post: Post) {
        self.post = post
    }
}
