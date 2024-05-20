//
//  MyImageBubble.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 16/11/23.
//

import UIKit

class MyImageBubble: UITableViewCell {
    
    @IBOutlet weak var myImageView: UIImageView!
    
    func loadData(chatUser: ChatUser) {
        self.myImageView.image = chatUser.image
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
