//
//  NotificationController.swift
//  InstagramFirestore
//
//  Created by jh on 2021/05/02.
//

import UIKit

private let reuseIdentifier = "NotificationCell"

class NotificationsController: UITableViewController {
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
    }
    
    //MARK: - Helpers
    
    func configureTableView(){
        view.backgroundColor = .white
        navigationItem.title = "알림"
        
        tableView.register(NotificationCell.self, forCellReuseIdentifier: reuseIdentifier)
        tableView.rowHeight = 80
        tableView.separatorStyle = .none
    }
}

extension NotificationsController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: reuseIdentifier, for: indexPath) as! NotificationCell
        
        return cell
    }
}
