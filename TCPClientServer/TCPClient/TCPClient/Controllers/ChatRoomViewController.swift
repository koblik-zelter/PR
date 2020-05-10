//
//  ChatRoomViewController.swift
//  TCPClient
//
//  Created by Alex Koblik-Zelter on 5/10/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import MessageKit
class ChatRoomViewController: UIViewController {
    
    var username: String? = "koblzelv"

    fileprivate let cellID = "MessageCellID"
    fileprivate var service: ChatService!
    fileprivate var messages: [Message] = []
    fileprivate var collectionView: UICollectionView!
        
    private let messageInputContainerView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
       
    private let inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.textColor = .darkGray
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()
    
    private lazy var sendButton: UIButton = {
        let button = UIButton()
        button.setTitle("Send", for: .normal)
        let titleColor = UIColor(red: 0, green: 137/255, blue: 249/255, alpha: 1)
        button.setTitleColor(titleColor, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        button.titleLabel?.font = .boldSystemFont(ofSize: 16)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupCollectionView()
        self.setupInput()
        self.setupService()
    }
    
    fileprivate func setupCollectionView() {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.backgroundColor = .init(red: 250/255, green: 250/255, blue: 250/255, alpha: 1)
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.bounces = true
        collectionView.isScrollEnabled = true
        self.view.backgroundColor = .white
        self.view.addSubview(collectionView)
        
        collectionView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor).isActive = true
        collectionView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor).isActive = true
        collectionView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor).isActive = true
        collectionView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(MessageCell.self, forCellWithReuseIdentifier: cellID)
        
        self.definesPresentationContext = true
    }
    
    fileprivate func setupInput() {
        self.view.addSubview(messageInputContainerView)
        self.messageInputContainerView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor, constant: 0).isActive = true
        self.messageInputContainerView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 0).isActive = true
        self.messageInputContainerView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: 0).isActive = true
        self.messageInputContainerView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        
        self.messageInputContainerView.addSubview(inputTextField)
        
        self.inputTextField.topAnchor.constraint(equalTo: self.messageInputContainerView.topAnchor).isActive = true
        self.inputTextField.leadingAnchor.constraint(equalTo: self.messageInputContainerView.leadingAnchor).isActive = true
        self.inputTextField.trailingAnchor.constraint(equalTo: self.messageInputContainerView.trailingAnchor,  constant: -100).isActive = true
        self.inputTextField.heightAnchor.constraint(equalToConstant: 45).isActive = true
        
        self.messageInputContainerView.addSubview(sendButton)
        
        self.sendButton.heightAnchor.constraint(equalToConstant: 45).isActive = true
        self.sendButton.trailingAnchor.constraint(equalTo: self.messageInputContainerView.trailingAnchor, constant: -16).isActive = true
        self.sendButton.leadingAnchor.constraint(equalTo: self.inputTextField.trailingAnchor, constant: 16).isActive = true
        self.sendButton.centerYAnchor.constraint(equalTo: self.inputTextField.centerYAnchor).isActive = true
    }
    
    fileprivate func setupService() {
        guard let userName = self.username else { return }
        
        service = ChatService()
        service.delegate = self
        service.setupNetworkCommunication()
        service.joinChat(username: userName)
    }
    
    @objc func handleSend() {
        guard let message = self.inputTextField.text else { return }
        guard let username = self.username else { return }
        self.service.send(message: Message(message: message, sender: username, statusCode: 0))
    }
}

extension ChatRoomViewController: ChatRoomDelegate {
    func didRecieve(message: Result<Message, ErrorMessage>) {
        switch message {
        case .success(let message):
            if (message.statusCode == 201) {
                let alert = UIAlertController(title: "New User", message: "\(message.sender) has joined!", preferredStyle: .alert)
                alert.addAction(.init(title: "Hello my Friend!", style: .default, handler: nil))
                self.present(alert, animated: true, completion: nil)
                break
            }
            self.messages.append(message)
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
            break
        case .failure(let err):
            print(err.rawValue)
            break
        }
    }
}

extension ChatRoomViewController: UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath) as? MessageCell else { return UICollectionViewCell() }
        let message = messages[indexPath.item]
        
        var isMyMessage = false
        if self.username == message.sender {
            isMyMessage = true
        }
        
        cell.isMyMessage = isMyMessage
        cell.message = message
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.view.frame.width, height: 50)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 8, left: 0, bottom: 16, right: 0)
    }
    
    
}
