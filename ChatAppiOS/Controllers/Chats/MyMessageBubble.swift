//
//  MyMessageBubble.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 10/11/23.
//

import UIKit

class MyMessageBubble: UITableViewCell {
    @IBOutlet weak var txtMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadData(chatUser: ChatUser) {
        self.txtMessage.text = chatUser.lastMessage
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
