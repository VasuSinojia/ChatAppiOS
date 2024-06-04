//
//  ChatListViewController.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 10/11/23.
//

import UIKit

struct ChatUser {
    let name: String
    let lastMessage: String
    let pendingMessage: Int
    let lastMessageDate: String
    let isMe: Bool
    var isImage: Bool?
    var image: UIImage?
}

class ChatListViewController: UIViewController {
    
    @IBOutlet weak var chatListTableView: UITableView!
    @IBOutlet weak var txtUserName: UILabel!
    private var chatList: [ChatUser] = []
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = true
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        Task {
            let conversationList = try? await DatabaseManager.sharedInstance.fetchMyConversations()
            if let conversations = conversationList {
                for conversation in conversations {
                    chatList.append(ChatUser(name: "\(conversation.firstName ?? "") \(conversation.lastName ?? "")", lastMessage: "hi", pendingMessage: 2, lastMessageDate: "Sun", isMe: false))
                }
            }
            chatListTableView.reloadData()
        }
        DatabaseManager.sharedInstance.fetchChatsFromConversationId(conversationId: "9dj4zUt8LZmeGOicNQS2")
        chatListTableView.register(UINib(nibName: "ChatCellView", bundle: nil), forCellReuseIdentifier: "cell")
        loadData()
        initDelegate()
        // Do any additional setup after loading the view.
    }
    
    private func loadData() {
        var user = MyManager.getUserData()
        txtUserName.text = (user.firstName ?? "") + " " + (user.lastName ?? "")
    }
    
    
    @IBAction func btnProfileAction(_ sender: UIButton) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "MyProfileViewController") as! MyProfileViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension ChatListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func initDelegate() {
        chatListTableView.dataSource = self
        chatListTableView.delegate = self
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! ChatCellView
        cell.loadData(chatUser: chatList[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let nextVC = self.storyboard?.instantiateViewController(identifier: "ChatInteractionWindow") as! ChatInteractionWindow
        self.navigationController?.pushViewController(nextVC, animated: true)
    }
    
}
