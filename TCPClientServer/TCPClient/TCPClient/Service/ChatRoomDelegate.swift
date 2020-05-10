//
//  ChatRoomDelegate.swift
//  TCPClient
//
//  Created by Alex Koblik-Zelter on 5/10/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

protocol ChatRoomDelegate: class {
    func didRecieve(message: Result<Message, ErrorMessage>) 
}
