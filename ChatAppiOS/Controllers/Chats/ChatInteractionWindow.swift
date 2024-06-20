//
//  ChatInteractionWindow.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 10/11/23.
//

import UIKit
import GrowingTextView

class ChatInteractionWindow: UIViewController {
    @IBOutlet weak var tblChatBubbles: UITableView!
    @IBOutlet weak var messsageTextField: GrowingTextView!
    
    private var chatList: [ChatMessage] = []
    let imagePicker = UIImagePickerController()
    var conversationId: String?
    var opponentUser: ChatUser?

    override func viewDidLoad() {
        super.viewDidLoad()

        let longGestureRecognizer = UILongPressGestureRecognizer(target: self, action: #selector(longPressAction(sender: )))
        tblChatBubbles.addGestureRecognizer(longGestureRecognizer)
        
        tblChatBubbles.register(UINib(nibName: "MyMessageBubble", bundle: nil), forCellReuseIdentifier: "MyMessageBubble")
        tblChatBubbles.register(UINib(nibName: "YouMessageBubble", bundle: nil), forCellReuseIdentifier: "YouMessageBubble")
        
        tblChatBubbles.register(UINib(nibName: "MyImageBubble", bundle: nil), forCellReuseIdentifier: "MyImageBubble")
        tblChatBubbles.register(UINib(nibName: "YouImageBubble", bundle: nil), forCellReuseIdentifier: "YouImageBubble")
        
        initNavbar()
        setProfileViewToNavBar()
        Task {
            DatabaseManager.sharedInstance.fetchChatsFromConversationId(conversationId: conversationId ?? "") { message  in
                self.chatList.append(message)
                self.reloadTableView()
                self.scrollTableViewToBottom()
            }
        }
        
        scrollTableViewToBottom()
        // Do any additional setup after loading the view.
    }
    func editHandler(message_text : String, index : Int){
        let alertController = UIAlertController(title: "Edit your text here", message: "", preferredStyle: UIAlertController.Style.alert)
        alertController.addTextField { (textField : UITextField!) -> Void in
            textField.placeholder = "Enter text"
            textField.text = message_text

        }
        let saveAction = UIAlertAction(title: "Save", style: UIAlertAction.Style.default, handler: { [self] alert -> Void in
            let firstTextField = alertController.textFields![0] as UITextField
            print(firstTextField.text ?? "Nothing")
//            chatList[index] = ChatUser(name: "Asgar", lastMessage: firstTextField.text!, pendingMessage: 0, lastMessageDate: "", isMe: true)
            reloadTableView()

        })
        let cancelAction = UIAlertAction(title: "Cancel", style: UIAlertAction.Style.default, handler: {
            (action : UIAlertAction!) -> Void in })
        
        alertController.addAction(saveAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    private func initNavbar() {
        let navigationBarAppearance = UINavigationBarAppearance()
        navigationBarAppearance.configureWithOpaqueBackground()
        navigationBarAppearance.backgroundColor = UIColor(named: "chat_screen_bg_color")

        UINavigationBar.appearance().standardAppearance = navigationBarAppearance
        UINavigationBar.appearance().compactAppearance = navigationBarAppearance
        UINavigationBar.appearance().scrollEdgeAppearance = navigationBarAppearance
    }
    
    private func scrollTableViewToBottom() {
        if (!chatList.isEmpty) {
            let indexPath = IndexPath(row: chatList.count - 1, section: 0)
            self.tblChatBubbles.scrollToRow(at: indexPath, at: .bottom, animated: true)
        }
    }
    
    private func reloadTableView() {
        tblChatBubbles.reloadData()
    }
    
    private func clearTextField() {
        messsageTextField.text = ""
    }
    
    private func sendMessage() {
        let messageText = messsageTextField.text ?? ""
        let userId = MyManager.user.userId ?? ""
        let currentTime = Date()
        let message = ChatMessage(message: messageText, messageType: .TEXT, senderId: userId,createdAt: currentTime)
        if (conversationId != nil) {
            DatabaseManager.sharedInstance.sendMessage(conversationId: conversationId!, chatMessage: message)
        }
    }
    
    private func setProfileViewToNavBar() {
        let image = UIImage(named: "profile")
        
        let imageView = UIImageView(image: image)
        imageView.heightAnchor.constraint(equalToConstant: 30).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        let titleLabel = UILabel()
        titleLabel.text = opponentUser?.name ?? "User"
        titleLabel.textColor = .white
        
        let stackView = UIStackView(arrangedSubviews: [imageView, titleLabel])
        stackView.spacing = 5
        stackView.alignment = .center
        
        let backButton = UIBarButtonItem(image: UIImage(systemName: "arrow.backward"), style: .done, target: self, action: #selector(backAction))
        backButton.tintColor = .white
        
        let barButtonItem = UIBarButtonItem(customView: stackView)
        self.navigationController?.navigationBar.backgroundColor = UIColor(named: "chat_screen_bg_color")
        navigationItem.leftBarButtonItems = [backButton, barButtonItem]

    }
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        if (!messsageTextField.text.isEmpty) {
            
//            chatList.append(ChatUser(name: "Asgar", lastMessage: messsageTextField.text, pendingMessage: 0, lastMessageDate: "", isMe: true))
            
            sendMessage()
            clearTextField()
            reloadTableView()
            scrollTableViewToBottom()
        }
    }
    
    @IBAction func pickImageBtnAction(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Please select option!", message: "", preferredStyle: .actionSheet)
        
        let cameraAction = UIAlertAction(title: "Camera", style: .default, handler: { [self] _ in
            alertController.dismiss(animated: true)
            if (!UIImagePickerController.isSourceTypeAvailable(.camera)) {
                let alertController = UIAlertController(title: "Error", message: "Camera not available.", preferredStyle: .alert)
                let alertAction = UIAlertAction(title: "OK", style: .cancel)
                alertController.addAction(alertAction)
                self.present(alertController, animated: true)
                return
            }
            
            imagePicker.sourceType = .camera
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        })
        
        let galleryAction = UIAlertAction(title: "Gallery", style: .default, handler: { [self] _ in
            alertController.dismiss(animated: true)
            imagePicker.sourceType = .photoLibrary
            imagePicker.delegate = self
            self.present(imagePicker, animated: true)
        })
        
        alertController.addAction(cameraAction)
        alertController.addAction(galleryAction)
        self.present(alertController, animated: true)
        
    }
    
    
    @objc private func backAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @objc private func longPressAction(sender: UILongPressGestureRecognizer) {
        print("on long press")
        if sender.state == .began {
            let touchPoint = sender.location(in: tblChatBubbles)
            if let indexPath = tblChatBubbles.indexPathForRow(at: touchPoint) {
//                showDeleteWarning(user: chatList[indexPath.row], index: indexPath.row)
            }
        }
    }
    
//    private func showDeleteWarning(user: ChatUser, index: Int) {
//        let alertController  = UIAlertController(title: "Do you want to delete this message?", message: user.lastMessage, preferredStyle: .alert)
//        let editButton = UIAlertAction(title: "Edit", style: .default, handler: { _ in
//            self.editHandler(message_text: self.chatList[index].lastMessage, index: index)
//        })
//        let deleteButton = UIAlertAction(title: "Delete for me", style: .default, handler: { _ in
//            self.chatList.remove(at: index)
//            self.reloadTableView()
//        })
//        let deleteEveryOneButton = UIAlertAction(title: "Delete for everyone", style: .default, handler: { _ in })
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: {
//            (action : UIAlertAction!) -> Void in })
//        cancelAction.setValue(UIColor.red, forKey: "titleTextColor")
//
//        if user.isMe {
//            alertController.addAction(editButton)
//            alertController.addAction(deleteEveryOneButton)
//        }
//        alertController.addAction(deleteButton)
//        alertController.addAction(cancelAction)
//        self.present(alertController, animated: true, completion: nil)
//    }
    
    override func viewWillAppear(_ animated: Bool) {
        self.navigationController?.isNavigationBarHidden = false
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

extension ChatInteractionWindow: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let pickedImage = info[.originalImage] as? UIImage else { return }
        self.imagePicker.dismiss(animated: true)
//        chatList.append(ChatUser(name: "", lastMessage: "", pendingMessage: 0, lastMessageDate: "", isMe: true, isImage: true, image: pickedImage))
        reloadTableView()
        scrollTableViewToBottom()
    }
}

extension ChatInteractionWindow: UITableViewDelegate, UITableViewDataSource {

    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chatList.count 
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let message = chatList[indexPath.row]
        let userId = MyManager.user.userId
        
        if message.senderId == userId {
            
//            if message.messageType == .IMAGE {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "MyImageBubble") as! MyImageBubble
//                cell.loadData(chatUser: chatList[indexPath.row])
//                return cell
//            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "MyMessageBubble") as! MyMessageBubble
            cell.loadData(chatUser: message)
            return cell
            
        } else {
            
//            if chatList[indexPath.row].isImage ?? false {
//                let cell = tableView.dequeueReusableCell(withIdentifier: "YouImageBubble") as! YouImageBubble
//                cell.loadData(chatUser: chatList[indexPath.row])
//                return cell
//            }
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "YouMessageBubble") as! YouMessageBubble
            cell.loadData(chatUser: message)
            return cell

        }
    }
}

extension ChatInteractionWindow: GrowingTextViewDelegate {
    func textViewDidChangeHeight(_ textView: GrowingTextView, height: CGFloat) {
       UIView.animate(withDuration: 0.2) {
           self.view.layoutIfNeeded()
           self.scrollTableViewToBottom()
       }
    }
}
