//
//  Message.swift
//  TCPClient
//
//  Created by Alex Koblik-Zelter on 5/10/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation

struct Message: Codable {
    var message: String
    var sender: String
    var statusCode: Int
    
    private enum CodingKeys: String, CodingKey {
        case message = "Message"
        case sender = "Username"
        case statusCode = "StatusCode"
    }
}
