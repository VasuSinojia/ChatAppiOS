//
//  NewChatTableViewCell.swift
//  ChatAppiOS
//
//  Created by Vasu-MacMini-M1 on 17/11/23.
//

import UIKit

class NewChatTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var userProfilePic: UIImageView!
    
    @IBOutlet weak var lblName: UILabel!
    
    func loadData(user: UserModel) {
        userProfilePic.image = UIImage(named: "profile")
        lblName.text = "\(user.firstName) \(user.lastName)"
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
