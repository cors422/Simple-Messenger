//
//  UsersViewController.swift
//  Simple Messenger
//
//  Created by Дмитрий Никольский on 30.11.2022.
//

import UIKit

class UsersViewController: UIViewController {

    
 
    @IBOutlet weak var tableView: UITableView!
    var users = [CurrentUser]()
    let service = Service.shared
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.register(UINib(nibName: "UserCellTableViewCell", bundle: nil), forCellReuseIdentifier: "userCell")
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        getUsers() 
    }
    
    func getUsers(){
        service.getAllUsers { users in
            self.users = users
            self.tableView.reloadData()
        }
    }
}

extension UsersViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "userCell", for: indexPath) as! UserCellTableViewCell
        cell.selectionStyle = .none
        let cellName = users[indexPath.row]
        cell.configCell(cellName.email)
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let userId = users[indexPath.row].id
        let vc = ChatViewController()
        
        vc.otherId = userId
        
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    
}
