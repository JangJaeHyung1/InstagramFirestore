//
//  ProfileHeaderViewModel.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/14.
//

import Foundation

struct ProfileHeaderViewModel {
    let user: User
    
    var fullName: String {
        return user.fullName
    }
    
    var profileImageUrl: URL? {
        return URL(string: user.profileImageUrl)
    }
            
    init(user: User) {
        self.user = user
    }
}
