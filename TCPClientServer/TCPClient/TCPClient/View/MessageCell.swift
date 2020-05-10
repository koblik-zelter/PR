//
//  MessageCell.swift
//  TCPClient
//
//  Created by Alex Koblik-Zelter on 5/10/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

    
class MessageCell: UICollectionViewCell {
    
    private var rightContraint: NSLayoutConstraint!
    private var leftContraint: NSLayoutConstraint!
    
    var message: Message? {
        didSet {
            guard let message = message else { return }
            self.fromUsername.text = message.sender
            self.messageLabel.text = message.message
        }
    }
    
    var isMyMessage: Bool? {
        didSet {
            guard let isMyMessage = isMyMessage else { return }
            if (isMyMessage) {
                self.textBubbleView.backgroundColor = .red
                self.rightContraint.isActive = true
                self.leftContraint.isActive = false
                self.fromUsername.textAlignment = .right
            } else {
                self.textBubbleView.backgroundColor = .lightGray
                self.rightContraint.isActive = false
                self.leftContraint.isActive = true
                self.fromUsername.textAlignment = .left
            }
        }
    }
    
    private let messageLabel: UILabel = {
        let textView = UILabel()
        textView.font = .systemFont(ofSize: 18)
        textView.text = "Sample message"
        textView.numberOfLines = 0
        textView.lineBreakMode = .byWordWrapping
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textColor = .white
        return textView
    }()
    
    private let fromUsername: UILabel = {
        let textView = UILabel()
        textView.font = .systemFont(ofSize: 14)
        textView.text = "username"
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.backgroundColor = .clear
        textView.textAlignment = .right
        textView.textColor = .lightGray
        return textView
    }()
    
    private let textBubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = .red
        view.layer.cornerRadius = 15
        view.translatesAutoresizingMaskIntoConstraints = false
        view.layer.masksToBounds = true
        return view
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupViews()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupViews() {
        self.addSubview(textBubbleView)
        self.addSubview(messageLabel)
        self.addSubview(fromUsername)
        
        self.fromUsername.topAnchor.constraint(equalTo: self.contentView.topAnchor).isActive = true
        self.fromUsername.heightAnchor.constraint(equalToConstant: 18).isActive = true
        self.fromUsername.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -25).isActive = true
        self.fromUsername.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16).isActive = true
        self.textBubbleView.topAnchor.constraint(equalTo: self.fromUsername.bottomAnchor).isActive = true
        self.textBubbleView.bottomAnchor.constraint(equalTo: self.contentView.bottomAnchor).isActive = true
      
        self.rightContraint = textBubbleView.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -16)
        self.leftContraint = textBubbleView.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 16)
        
        self.textBubbleView.widthAnchor.constraint(equalTo: self.widthAnchor, multiplier: 0.4).isActive = true
        
        self.messageLabel.topAnchor.constraint(equalTo: self.textBubbleView.topAnchor).isActive = true
        self.messageLabel.bottomAnchor.constraint(equalTo: self.textBubbleView.bottomAnchor).isActive = true
        self.messageLabel.leadingAnchor.constraint(equalTo: self.textBubbleView.leadingAnchor, constant: 8).isActive = true
        self.messageLabel.trailingAnchor.constraint(equalTo: self.textBubbleView.trailingAnchor, constant: -4).isActive = true
    
       
    }
}
