//
//  MainTabController.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/02.
//

import UIKit
import Firebase
import YPImagePicker

class MainTabController: UITabBarController {
    
    // MARK: - Lifecycle
    
    private var user: User? {
        didSet {
            guard let user = user else { return }
            configureViewControllers(withUser: user)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        configureViewControllers()
        checkIfUserIsLoggedIn()
        fetchUser()
    }
    
    // MARK: - API
    
    func fetchUser() {
        UserService.fetchUser { user in
            self.user = user
        }
    }
    
    func checkIfUserIsLoggedIn() {
        if Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let controller = LoginController()
                controller.delegate = self
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: true, completion: nil)
            }
        }
    }

    // MARK: - Helpers
    
    func configureViewControllers(withUser user: User) {
        view.backgroundColor = .white
        
        self.delegate = self
        
        let layout = UICollectionViewFlowLayout()
        let feed = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "home_unselected"), seletedImage: #imageLiteral(resourceName: "home_selected"), rootViewController: FeedController(collectionViewLayout: layout))
        
        let search = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "search_unselected"), seletedImage: #imageLiteral(resourceName: "search_selected"), rootViewController: SearchController())
        
        let imageSelector = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "plus_unselected"), seletedImage: #imageLiteral(resourceName: "plus_unselected"), rootViewController: ImageSelectorController())
        
        let notifications = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "like_unselected"), seletedImage: #imageLiteral(resourceName: "like_selected"), rootViewController: NotificationsController())
        
//        let profileLayout = UICollectionViewFlowLayout()
        let profileController = ProfileController(user: user)
        let profile = templateNavigationController(unselectedImage: #imageLiteral(resourceName: "profile_unselected"), seletedImage: #imageLiteral(resourceName: "profile_selected"), rootViewController: profileController)
        
        viewControllers = [feed, search, imageSelector, notifications, profile]
        
        tabBar.tintColor = .black
    }
    
    func templateNavigationController(unselectedImage: UIImage, seletedImage: UIImage, rootViewController: UIViewController) -> UINavigationController {
        let nav = UINavigationController(rootViewController: rootViewController)
        nav.tabBarItem.image = seletedImage
        nav.navigationBar.tintColor = .black
        return nav
    }
    
    func didFinishPickMedia(_ picker: YPImagePicker) {
        picker.didFinishPicking { items, _ in
            picker.dismiss(animated: false) {
                guard let selectedImage = items.singlePhoto?.image else { return }
//                print("DEBUG: selectedImage \(selectedImage)")
                
                let controller = UploadPostController()
                let nav = UINavigationController(rootViewController: controller)
                nav.modalPresentationStyle = .fullScreen
                self.present(nav, animated: false, completion: nil)
                
            }
        }
    }
}

// MARK: - AuthenticationDelegate

extension MainTabController: AuthenticationDelegate {
    func authenticationDidComplete() {
        fetchUser()
//        print("DEBUG: Auth did complete. Fetch user and update")
        self.dismiss(animated: true, completion: nil)
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, shouldSelect viewController: UIViewController) -> Bool {
        let index = viewControllers?.firstIndex(of: viewController)
        
        if index == 2 {
            var config = YPImagePickerConfiguration()
            config.library.mediaType = .photo
            config.shouldSaveNewPicturesToAlbum = false
            config.startOnScreen = .library
            config.screens = [.library]
            config.hidesStatusBar = false
            config.hidesBottomBar = false
            config.library.maxNumberOfItems = 1
            
            let picker = YPImagePicker(configuration: config)
            picker.modalPresentationStyle = .fullScreen
            present(picker, animated: true, completion: nil)
            
            didFinishPickMedia(picker)
        }
        
        return true
    }
}
