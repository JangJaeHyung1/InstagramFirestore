//
//  NotificationViewModel.swift
//  InstagramFirestore
//
//  Created by jh on 2021/06/07.
//

import UIKit

struct NotificationViewModel {
    var notification: Notification
    
    init(notification: Notification) {
        self.notification = notification
    }
    
    var postImageUrl: URL? { return URL(string: notification.postImageUrl ?? "" )}
    
    var profileImageUrl: URL? { return URL(string: notification.userProfileImageUrl)}
    
    var timestampString: String? {
        let formatter = DateComponentsFormatter()
        formatter.allowedUnits = [.second, .minute, .hour, .day, .weekOfMonth]
        formatter.maximumUnitCount = 1
        formatter.unitsStyle = .abbreviated
        return formatter.string(from: notification.timestamp.dateValue(), to: Date()) ?? "2m"
    }
    
    var notificationMessage: NSAttributedString {
        let userName = notification.userName
        let message = notification.type.notificationMessage
        
        let attributedText = NSMutableAttributedString(string: userName, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)])
        attributedText.append(NSAttributedString(string: message, attributes: [.font: UIFont.boldSystemFont(ofSize: 14)]))
        attributedText.append(NSAttributedString(string: " \(timestampString ?? "")", attributes: [.font: UIFont.boldSystemFont(ofSize: 12), .foregroundColor: UIColor.lightGray]))
        
        return attributedText
    }
    
    var shouldHidePostImage: Bool { return notification.type == .follow }
    
    var followButtonText: String { return notification.userIsFollowed ? "팔로잉" : "팔로우" }
    var followButtonBackgroundColor: UIColor { return notification.userIsFollowed ? .white : .systemBlue }
    var followButtonTextColor: UIColor { return notification.userIsFollowed ? .black : .white }
    
    
}
