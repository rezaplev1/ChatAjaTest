//
//  ChannelTableViewCell.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 11/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit
import Kingfisher
import SwiftyUserDefaults
import MessageKit

class ChannelTableViewCell: UITableViewCell {
    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(chat:Chat) {
        let currentUser = Defaults[.currentUser]
        let userIDs = chat.userIDs
        let opponentUserIds = userIDs.filter({$0 != currentUser?.userId})
        if opponentUserIds.count > 0, let opponentUserId = opponentUserIds.first {
            let userManager = UserManager()
            userManager.getUser(withUserId: opponentUserId, completion: {(userModel) in
                let url = URL(string: userModel.avatarUrl)
                self.profilePic.kf.setImage(with: url)
                self.nameLabel.text = userModel.name
                self.messageLabel.text = chat.lastMessage
                if let lastMessageDate = chat.lastMessageDate {
                    self.timeLabel.text = MessageKitDateFormatter.shared.string(from: lastMessageDate)
                } else {
                    self.timeLabel.text = ""
                }
            })
        }
    }
}
