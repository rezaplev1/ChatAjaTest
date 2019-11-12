//
//  ChatViewController.swift
//  ChatAjaTest
//
//  Created by Muhammad Nizar on 12/11/19.
//  Copyright © 2019 Muhammad Nizar. All rights reserved.
//

import UIKit
import MessageKit
import InputBarAccessoryView
import SwiftyUserDefaults
import SwiftMessages

class ChatViewController: MessagesViewController {
    
    private var chatViewModel:ChatViewModel!
    var chat:Chat!
    var opponentUser:UserModel!
    private let currentUser = Defaults[.currentUser]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRightBarButtonItems()
        maintainPositionOnKeyboardFrameChanged = true
        messageInputBar.inputTextView.tintColor = .primary
        messageInputBar.sendButton.setTitleColor(.primary, for: .normal)
        
        messageInputBar.delegate = self
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        
        let layout = messagesCollectionView.collectionViewLayout as? MessagesCollectionViewFlowLayout
        
        // Hide the outgoing avatar and adjust the label alignment to line up with the messages
        layout?.setMessageOutgoingAvatarSize(.zero)
        layout?.setMessageIncomingAvatarSize(.zero)
        layout?.setMessageOutgoingMessageTopLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageOutgoingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .right, textInsets: UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 8)))
        layout?.setMessageIncomingMessageTopLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)))
        layout?.setMessageIncomingMessageBottomLabelAlignment(LabelAlignment(textAlignment: .left, textInsets: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0)))
        
        chatViewModel = ChatViewModel(chat: chat, currentUser: currentUser, opponentUser: opponentUser)
        chatViewModel.delegate = self
        chatViewModel.observerMessageListener()
        
        self.title = opponentUser.name
    }
    
    func setupRightBarButtonItems() {
        let url = URL(string: opponentUser?.avatarUrl ?? "")
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
        messageView.configureContent(title: "\(opponentUser?.name ?? "")", body: "", iconImage: sender.imageView?.image, iconText: "", buttonImage: nil, buttonTitle: "Dismiss") { _ in
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
    
    // MARK: - Helpers
    
    func isTimeLabelVisible(at indexPath: IndexPath) -> Bool {
        return true
    }
    
    func isPreviousMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section - 1 >= 0 else { return false }
        return chatViewModel.messages[indexPath.section].user == chatViewModel.messages[indexPath.section - 1].user
    }
    
    func isNextMessageSameSender(at indexPath: IndexPath) -> Bool {
        guard indexPath.section + 1 < chatViewModel.messages.count else { return false }
        return chatViewModel.messages[indexPath.section].user == chatViewModel.messages[indexPath.section + 1].user
    }
    
}

// MARK: - MessageLabelDelegate

extension ChatViewController: MessageLabelDelegate {
    
    func didSelectAddress(_ addressComponents: [String: String]) {
        print("Address Selected: \(addressComponents)")
    }
    
    func didSelectDate(_ date: Date) {
        print("Date Selected: \(date)")
    }
    
    func didSelectPhoneNumber(_ phoneNumber: String) {
        print("Phone Number Selected: \(phoneNumber)")
    }
    
    func didSelectURL(_ url: URL) {
        print("URL Selected: \(url)")
    }
    
    func didSelectTransitInformation(_ transitInformation: [String: String]) {
        print("TransitInformation Selected: \(transitInformation)")
    }
    
    func didSelectHashtag(_ hashtag: String) {
        print("Hashtag selected: \(hashtag)")
    }
    
    func didSelectMention(_ mention: String) {
        print("Mention selected: \(mention)")
    }
    
    func didSelectCustom(_ pattern: String, match: String?) {
        print("Custom data detector patter selected: \(pattern)")
    }
    
}

// MARK: - MessagesDisplayDelegate
extension ChatViewController: MessagesDisplayDelegate {
    
    func backgroundColor(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> UIColor {
        return isFromCurrentSender(message: message) ? .primary : .incomingMessage
    }
    
    func shouldDisplayHeader(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> Bool {
        return false
    }
    
    func messageStyle(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageStyle {
        let corner: MessageStyle.TailCorner = isFromCurrentSender(message: message) ? .bottomRight : .bottomLeft
        return .bubbleTail(corner, .curved)
    }
    
    func configureAvatarView(_ avatarView: AvatarView, for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) {
        avatarView.isHidden = true
    }
    
}

// MARK: - MessagesLayoutDelegate
extension ChatViewController: MessagesLayoutDelegate {
    
    func messageBottomLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        if isTimeLabelVisible(at: indexPath) {
            return 18
        }
        return 0
    }
    func cellTopLabelHeight(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        return 0
    }
    
    func footerViewSize(for message: MessageType, at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> CGSize {
        return CGSize(width: 0, height: 8)
    }
    
    func heightForLocation(message: MessageType, at indexPath: IndexPath, with maxWidth: CGFloat, in messagesCollectionView: MessagesCollectionView) -> CGFloat {
        
        return 0
    }
    
}

// MARK: - MessagesDataSource
extension ChatViewController: MessagesDataSource {
    
    func isFromCurrentSender(message: MessageType) -> Bool {
        return message.sender.senderId == currentSender().senderId
    }
    
    func messageBottomLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        if isTimeLabelVisible(at: indexPath) {
            return NSAttributedString(string: MessageKitDateFormatter.shared.string(from: message.sentDate), attributes: [NSAttributedString.Key.font: UIFont.boldSystemFont(ofSize: 10), NSAttributedString.Key.foregroundColor: UIColor.darkGray])
        }
        return nil
    }
    
    func cellTopLabelAttributedText(for message: MessageType, at indexPath: IndexPath) -> NSAttributedString? {
        return nil
    }
    
    func currentSender() -> SenderType {
        return chatViewModel.currentUser
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return chatViewModel.messages.count
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return chatViewModel.messages[indexPath.section]
    }
}

// MARK: - ChatViewModelDelegate
extension ChatViewController: ChatViewModelDelegate {
    func showLoading() {
        
    }
    
    func hideLoading() {
        
    }
    
    func didGetAllMessagesSuccess(messages: [Message]) {
        print("didGetAllMessagesSuccess total:\(messages.count)")
    }
    
    func didGetAllMessagesError(message: String) {
        
    }
    
    func insertRow(atIndex index: Int) {
        self.messagesCollectionView.reloadData()
        self.messagesCollectionView.scrollToBottom(animated: true)
    }
    
    func updateRow(atIndex index: Int) {
        self.messagesCollectionView.reloadData()
    }
    
    func deleteRow(atIndex index: Int) {
        self.messagesCollectionView.reloadData()
    }
    
    
}

// MARK: - InputBarAccessoryViewDelegate

extension ChatViewController: InputBarAccessoryViewDelegate {

    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {

        // Here we can parse for which substrings were autocompleted
        let attributedText = messageInputBar.inputTextView.attributedText!
        let range = NSRange(location: 0, length: attributedText.length)
        attributedText.enumerateAttribute(.autocompleted, in: range, options: []) { (_, range, _) in

            let substring = attributedText.attributedSubstring(from: range)
            let context = substring.attribute(.autocompletedContext, at: 0, effectiveRange: nil)
            print("Autocompleted: `", substring, "` with context: ", context ?? [])
        }

        let components = inputBar.inputTextView.components
        messageInputBar.inputTextView.text = String()
        messageInputBar.invalidatePlugins()

        // Send button activity animation
        messageInputBar.sendButton.startAnimating()
        messageInputBar.inputTextView.placeholder = "Sending..."
        DispatchQueue.global(qos: .default).async {
            // fake send request task
            sleep(1)
            DispatchQueue.main.async { [weak self] in
                self?.messageInputBar.sendButton.stopAnimating()
                self?.messageInputBar.inputTextView.placeholder = "Aa"
                self?.insertMessages(components)
                self?.messagesCollectionView.scrollToBottom(animated: true)
            }
        }
    }

    private func insertMessages(_ data: [Any]) {
        for component in data {
            if let str = component as? String {
                chatViewModel.insertMessage(str)
            }
        }
    }
}
