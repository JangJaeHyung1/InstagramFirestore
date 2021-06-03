//
//  FeedController.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/02.
//

import UIKit
import Firebase

private let reuseIdentifier = "Cell"

class FeedController: UICollectionViewController {
    
    // MARK: - Lifecycle
    
    private var posts = [Post]() {
        didSet { collectionView.reloadData() }
    }
    
    var post: Post?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureUI()
        fetchPosts()
    }
    
    // MARK: - Actions
    
    @objc func handleRefresh() {
        posts.removeAll()
        fetchPosts()
    }
    
    @objc func handleLogout(){
        do {
            try Auth.auth().signOut()
            let controller = LoginController()
            controller.delegate = self.tabBarController as? MainTabController
            let nav = UINavigationController(rootViewController: controller)
            nav.modalPresentationStyle = .fullScreen
            self.present(nav, animated: true, completion: nil)
        } catch {
            print("DEBUG: Failed to sign out")
        }
    }
    
    // MARK: - API
    
    func fetchPosts() {
        guard post == nil else {
            return
        }
        PostService.fetchPosts { posts in
            self.posts = posts
            self.checkIfUserLikedPost()
            self.collectionView.refreshControl?.endRefreshing()
//            self.collectionView.reloadData()
        }
    }
    
    func checkIfUserLikedPost() {
        self.posts.forEach { post in
            PostService.checkIfUserLikePost(post: post) { didLike in
//                print("DEBUG: \(post.caption) post did liked : \(didLike)")
                if let index = self.posts.firstIndex(where: { $0.postId == post.postId }) {
                    self.posts[index].didLike = didLike
                }
            }
        }
    }
    
    // MARK: - Helpers
    
    func configureUI(){
        collectionView.backgroundColor = .white
        
        collectionView.register(FeedCell.self, forCellWithReuseIdentifier: reuseIdentifier)
        
        if post == nil {
            navigationItem.leftBarButtonItem = UIBarButtonItem(title: "로그아웃", style: .plain, target: self, action: #selector(handleLogout))
        }
        
        navigationItem.title = "피드"
        
        let refresher = UIRefreshControl()
        refresher.addTarget(self, action: #selector(handleRefresh), for: .valueChanged)
        collectionView.refreshControl = refresher
    }
}

// MARK: - UICollectionViewDataSource

extension FeedController {
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return post != nil ? 1 : posts.count
    }
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: reuseIdentifier, for: indexPath) as! FeedCell
        
        cell.delegate = self
        
        if let post = post {
            cell.viewModel = PostViewModel(post: post)
        } else {
            cell.viewModel = PostViewModel(post: posts[indexPath.row])
        }
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension FeedController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        let width = view.frame.width
        var height = width + 8 + 40 + 8
        height += 50
        height += 60
        
        return CGSize(width: width, height: height)
    }
}

// MARK: - FeedCellDelegate
extension FeedController: FeedCellDelegate {
    func cell(_ cell: FeedCell, showCommentsFor post: Post) {
        let controller = CommentController(post: post)
        navigationController?.pushViewController(controller, animated: true)
    }
    func cell(_ cell: FeedCell, didLike post: Post) {
//        print("DEBUG: Like tap")
//        post.didLike.toggle()
        cell.viewModel?.post.didLike.toggle()
        if post.didLike {
//            print("DEBUG: Unlike post")
            PostService.unlikePost(post: post) { _ in
//                print("DEBUG: Unlike complete")
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_unselected"), for: .normal)
                cell.likeButton.tintColor = .black
                cell.viewModel?.post.likes = post.likes - 1
            }
        } else {
//            print("DEBUG: Like post")
            PostService.likePost(post: post) { error in
//                print("DEBUG: Like complete")
                cell.likeButton.setImage(#imageLiteral(resourceName: "like_selected"), for: .normal)
                cell.likeButton.tintColor = .red
                cell.viewModel?.post.likes = post.likes + 1
            }
        }
    }
}
