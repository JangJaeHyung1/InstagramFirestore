//
//  SearchController.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/02.
//
import UIKit

private let reuseIdentifier = "UserCell"

class SearchController: UITableViewController {
    
    // MARK: - Properties
    
    private var users = [User]()
    private var filteredUser = [User]()
    private let searchController = UISearchController(searchResultsController: nil)
    
    private var inSearchMode: Bool {
        return searchController.isActive && !searchController.searchBar.text!.isEmpty
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configureSearchController()
        configureTableView()
        fetchUsers()
    }
    
    // MARK: - API
    
    func fetchUsers() {
        UserService.fetchUsers { users in
//            print("DEBUG: fetch Users in search controller \(users)")
            self.users = users
            self.tableView.reloadData()
        }
    }
    
    // MARK: - Helpers
    
    func configureTableView() {
        view.backgroundColor = .white
        
        tableView.register(UserCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 64
    }
    
    func configureSearchController() {
        searchController.searchResultsUpdater = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.searchBar.placeholder = "검색"
        navigationItem.searchController = searchController
        
        // true인 controller에 content를 뿌림.
        definesPresentationContext = false
    }
    
}

// MARK: - UITableViewDataSource

extension SearchController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return inSearchMode ? filteredUser.count : users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! UserCell
        
        let user = inSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
//        print("DEBUG: Index path row is \(indexPath.row)")
        cell.viewModel = UserCellViewModel(user: user)
        
        return cell
    }
}

// MARK: - UITableViewDelegate

extension SearchController {
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        print("DEBUG: user name \(users[indexPath.row].userName)")
        let user = inSearchMode ? filteredUser[indexPath.row] : users[indexPath.row]
        let controller = ProfileController(user: user)
        navigationController?.pushViewController(controller, animated: true)
    }
}

// MARK: - UISearchResultsUpdating

extension SearchController: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
//        print("DEBUG: update user list")
        guard let searchText = searchController.searchBar.text?.lowercased() else { return }
//        print("DEBUG: searchText \(searchText)")
        filteredUser = users.filter({ $0.userName.lowercased().contains(searchText) || $0.fullName.lowercased().contains(searchText) })
        
//        print("DEBUG: filter users \(filteredUser)")
        self.tableView.reloadData()
    }
}
