//
//  NewChatViewController.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 17/11/23.
//

import UIKit
import FirebaseAuth

class NewChatViewController: UIViewController {
    
    @IBOutlet weak var newChatListTableView: UITableView!
    
    var dataSource: [UserModel] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initSearchBar()
        initDelegate()
        newChatListTableView.register(UINib(nibName: "NewChatTableViewCell", bundle: nil), forCellReuseIdentifier: "NewChatTableViewCell")
        loadData()
        // Do any additional setup after loading the view.
    }
    
    private func loadData() {
        DatabaseManager.sharedInstance.getAllUsers { [self] userList in
            dataSource = userList
            reloadTableView()
        }
    }
    
    private func reloadTableView() {
        newChatListTableView.reloadData()
    }
    
    private func initSearchBar() {
        
    }
    
    @IBAction func btnCloseAction(_ sender: Any) {
        self.dismiss(animated: true)
    }
    
}

extension NewChatViewController: UITableViewDelegate, UITableViewDataSource {
    
    private func initDelegate() {
        newChatListTableView.delegate = self
        newChatListTableView.dataSource = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "NewChatTableViewCell") as! NewChatTableViewCell
        cell.loadData(user: dataSource[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        DatabaseManager.sharedInstance.getUser(uid: dataSource[indexPath.row].userId ?? "") { receiverUser in
            print("receiver user email \(receiverUser.email)")
            print("receiver user uid \(receiverUser.userId)")
            
            let currentUserUid = Auth.auth().currentUser!.uid
            let selectedUserUid: String = receiverUser.userId ?? ""
            var arrUid = [currentUserUid, selectedUserUid]
            arrUid.sort()
            let chatId = arrUid.joined(separator: "_")
            print("chatId \(chatId)")
            DatabaseManager.sharedInstance.checkAndCreateNewConversation(conversationId: chatId) {
                print("check firestore")
            }
        }
    }
}
