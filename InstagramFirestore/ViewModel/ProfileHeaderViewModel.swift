//
//  ProfileHeaderViewModel.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/14.
//

import UIKit

struct ProfileHeaderViewModel {
    let user: User
    
    var fullName: String {
        return user.fullName
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
            
    var followButtonText: String {
        if user.isCurrentUser {
            return "프로필 수정"
        }
        
        return user.isFollowed ? "팔로잉 중" : "팔로우 하기"
    }
    
    var followButtonBackgroundColor: UIColor {
        return user.isCurrentUser ? .white : .systemBlue
    }
    
    var followButtonTextColor: UIColor {
        return user.isCurrentUser ? .black : . white
    }
    
    init(user: User) {
        self.user = user
    }
}
