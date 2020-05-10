//
//  ViewController.swift
//  TCPClient
//
//  Created by Alex Koblik-Zelter on 5/10/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    private let usernameTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Enter your Username"
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.backgroundColor = UIColor(white: 0, alpha: 0.03)
        tf.borderStyle = .roundedRect
        tf.font = UIFont.systemFont(ofSize: 14)
        tf.addTarget(self, action: #selector(enableSignInButton), for: .editingChanged)
        tf.autocapitalizationType = .none
        
        return tf
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Sign in", for: .normal)
        button.backgroundColor = UIColor.rgbColor(red: 149, green: 204, blue: 244)
        button.layer.cornerRadius = 5
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 14)
        button.setTitleColor(.white, for: .normal)
        button.addTarget(self, action: #selector(signIn), for: .touchUpInside)
        button.isEnabled = false
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setupViews()
        
    }
    
    private func setupViews() {
        self.view.backgroundColor = .white
        let stackView = UIStackView(arrangedSubviews: [usernameTextField, loginButton])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        stackView.distribution = .fillEqually
        stackView.axis = .vertical
        stackView.spacing = 16
        
        view.addSubview(stackView)
        
        NSLayoutConstraint.activate([
            stackView.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            stackView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 40),
            stackView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -40),
            stackView.heightAnchor.constraint(equalToConstant: 100)
        ])
    }
    
    @objc private func signIn() {
        guard let login = usernameTextField.text else { return }
        let vc = ChatRoomViewController()
        vc.username = login
        vc.modalPresentationStyle = .fullScreen
        self.navigationController?.pushViewController(vc, animated: true)
        
    }
    
    @objc private func enableSignInButton() {
        guard let login = usernameTextField.text else { return }
                
        if (login.count > 0) {
            loginButton.isEnabled = true
            loginButton.backgroundColor = .rgbColor(red: 17, green: 154, blue: 237)
        }
        else {
            loginButton.isEnabled = false
            loginButton.backgroundColor = .rgbColor(red: 149, green: 204, blue: 244)
        }
    }
}

extension UIColor {
    static func rgbColor(red: CGFloat, green: CGFloat, blue: CGFloat) -> UIColor {
        return UIColor(red: red/255, green: green/255, blue: blue/255, alpha: 1)
    }
}
