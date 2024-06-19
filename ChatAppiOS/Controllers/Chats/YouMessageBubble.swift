//
//  YouMessageBubble.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 10/11/23.
//

import UIKit

class YouMessageBubble: UITableViewCell {
    @IBOutlet weak var txtMessage: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    func loadData(chatUser: ChatMessage) {
        self.txtMessage.text = chatUser.message
        
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
