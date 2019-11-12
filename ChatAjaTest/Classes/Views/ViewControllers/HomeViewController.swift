//
//  HomeViewController.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 09/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit
import FirebaseFirestore
import SwiftMessages
import SwiftyUserDefaults
import Kingfisher

class HomeViewController: UIViewController {
    
    @IBOutlet private weak var tableView:UITableView!
    private var homeViewModel:HomeViewModel!
    private let currentUser = Defaults[.currentUser]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButtonItems()
        homeViewModel = HomeViewModel()
        homeViewModel.delegate = self
        homeViewModel.observerChatListener()
    }
    
    func setupRightBarButtonItems() {
        let url = URL(string: currentUser?.avatarUrl ?? "")
        let profileButton = UIButton(type: .custom)
        profileButton.frame = CGRect(x: 0.0, y: 0.0, width: 24, height: 24)
        profileButton.layer.cornerRadius = 12
        profileButton.clipsToBounds = true
        profileButton.kf.setImage(with: url, for: .normal)
        profileButton.addTarget(self, action: #selector(profileButtonDidClicked(_:)), for: .touchUpInside)

        let menuBarItem = UIBarButtonItem(customView: profileButton)
        menuBarItem.customView?.translatesAutoresizingMaskIntoConstraints = false
        menuBarItem.customView?.heightAnchor.constraint(equalToConstant: 24).isActive = true
        menuBarItem.customView?.widthAnchor.constraint(equalToConstant: 24).isActive = true
        
        self.navigationItem.rightBarButtonItem = menuBarItem
    }
    
    @objc func profileButtonDidClicked(_ sender:UIButton) {
        let messageView: MessageView = MessageView.viewFromNib(layout: .centeredView)
        messageView.configureBackgroundView(width: 250)
        messageView.configureContent(title: "\(currentUser?.name ?? "")", body: "Do you want to sign out ?", iconImage: sender.imageView?.image, iconText: "", buttonImage: nil, buttonTitle: "Sign Out") { _ in
            UserManager().logout()
            SwiftMessages.hide()
        }
        messageView.backgroundView.backgroundColor = UIColor.init(white: 0.97, alpha: 1)
        messageView.backgroundView.layer.cornerRadius = 10
        var config = SwiftMessages.defaultConfig
        config.presentationStyle = .center
        config.duration = .forever
        config.dimMode = .blur(style: .dark, alpha: 1, interactive: true)
        config.presentationContext  = .window(windowLevel: UIWindow.Level.statusBar)
        SwiftMessages.show(config: config, view: messageView)
    }

}

// MARK: - HomeViewModelDelegate
extension HomeViewController: UITableViewDataSource, UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChannelTableViewCell") as! ChannelTableViewCell
        let chats = homeViewModel.chats
        if chats.count > 0 {
            let chat = chats[indexPath.row]
            cell.configureCell(chat: chat)
        }
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return  homeViewModel.chats.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    //MARK: - UITableViewDelegate
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 80
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let selectedChat = homeViewModel.chats[indexPath.row]
        let chatViewController = ChatViewController()
        chatViewController.chat = selectedChat
        let userIDs = selectedChat.userIDs
        let opponentUserIds = userIDs.filter({$0 != currentUser?.userId})
        if opponentUserIds.count > 0, let opponentUserId = opponentUserIds.first {
            let userManager = UserManager()
            userManager.getUser(withUserId: opponentUserId, completion: {(userModel) in
                chatViewController.opponentUser = userModel
                self.navigationController?.pushViewController(chatViewController, animated: true)
            })
        }
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0.1
    }
}

// MARK: - HomeViewModelDelegate
extension HomeViewController: HomeViewModelDelegate {
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func didGetAllChatListSuccess(chats: [Chat]) {
        tableView.reloadData()
    }
    
    func didGetAllChatListError(message: String) {
        
    }
    
    func insertRow(atIndex index: Int) {
        tableView.insertRows(at: [IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func updateRow(atIndex index: Int) {
        tableView.reloadRows(at:[IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    func deleteRow(atIndex index: Int) {
        tableView.deleteRows(at:[IndexPath(row: index, section: 0)], with: .automatic)
    }
    
    
}
