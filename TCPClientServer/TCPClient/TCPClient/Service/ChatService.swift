//
//  ChatService.swift
//  TCPClient
//
//  Created by Alex Koblik-Zelter on 5/10/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit

class ChatService: NSObject {
    
    var inputStream: InputStream!
    var outputStream: OutputStream!
    let maxReadLength = 4096
    weak var delegate: ChatRoomDelegate?

    func setupNetworkCommunication() {
        var readStream: Unmanaged<CFReadStream>?
        var writeStream: Unmanaged<CFWriteStream>?
        
        CFStreamCreatePairWithSocketToHost(kCFAllocatorDefault,
                                           "localhost" as CFString,
                                           8081,
                                           &readStream,
                                           &writeStream)
        
        inputStream = readStream!.takeRetainedValue()
        outputStream = writeStream!.takeRetainedValue()
        
        inputStream.delegate = self

        inputStream.schedule(in: .current, forMode: .common)
        outputStream.schedule(in: .current, forMode: .common)
        
        inputStream.open()
        outputStream.open()

    }

    func joinChat(username: String) {
        let user = username
        let data = "iam:\(user)".data(using: .utf8)!
        
        _ = data.withUnsafeBytes {
            guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
                print("Error joining chat")
                return
            }
            outputStream.write(pointer, maxLength: data.count)
        }
    }
    
    func send(message: Message) {
        let data = "Message:\(message.message);Username:\(message.sender)".data(using: .utf8)!
      
      _ = data.withUnsafeBytes {
        guard let pointer = $0.baseAddress?.assumingMemoryBound(to: UInt8.self) else {
          print("Error joining chat")
          return
        }
        outputStream.write(pointer, maxLength: data.count)
      }
    }
    
    func stopChatSession() {
        inputStream.close()
        outputStream.close()
    }
}

extension ChatService: StreamDelegate {
    func stream(_ aStream: Stream, handle eventCode: Stream.Event) {
        guard let stream = aStream as? InputStream else { return }
        readAvailableBytes(stream: stream)

    }
    
    fileprivate func readAvailableBytes(stream: InputStream) {
        let buffer = UnsafeMutablePointer<UInt8>.allocate(capacity: maxReadLength)
        var data = Data()
        while stream.hasBytesAvailable {
            let numberOfBytesRead = inputStream.read(buffer, maxLength: maxReadLength)
            
            if numberOfBytesRead < 0, let error = stream.streamError {
                print(error)
                break
            }
            data.append(buffer, count: numberOfBytesRead)
            do {
                let message = try JSONDecoder().decode(Message.self, from: data)
                self.delegate?.didRecieve(message: .success(message))

            }
            catch {
                self.delegate?.didRecieve(message: .failure(.invalidData))
            }
        }
    }
}
