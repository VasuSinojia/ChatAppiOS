//
//  ChatCellView.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 10/11/23.
//

import Foundation
import UIKit

class ChatCellView: UITableViewCell {
    
    let nibName = "ChatCellView"
    @IBOutlet weak var profileImage: UIImageView!
    
    @IBOutlet weak var name: UILabel!
    
    @IBOutlet weak var lastMessage: UILabel!
    
    @IBOutlet weak var lastMessageDateLbl: UILabel!
    
    @IBOutlet weak var unreadCount: UILabel!
    
    func loadData(chatUser: ChatUser) {
        self.name.text = chatUser.name
        self.lastMessage.text = chatUser.lastMessage
        self.lastMessageDateLbl.text = chatUser.lastMessageDate
        self.unreadCount.text = String(chatUser.pendingMessage)
    }
//    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.backgroundColor = UIColor.clear
        // Initialization code
    }
//
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }
//    
//    
//    func commonInit() {
//        guard let view = loadViewFromNib() else { return }
//        view.frame = self.bounds
//        self.addSubview(view)
//    }
//    
//    func loadViewFromNib() -> UIView? {
//        let bundle = Bundle(for: type(of: self))
//        let nib = UINib(nibName: nibName, bundle: bundle)
//        return nib.instantiate(withOwner: self, options: nil).first as? UIView
//    }
}
