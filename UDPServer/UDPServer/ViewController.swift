//
//  ViewController.swift
//  UDPServer
//
//  Created by Alex Koblik-Zelter on 6/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Cocoa
import CocoaAsyncSocket

class ViewController: NSViewController, GCDAsyncUdpSocketDelegate {
    
    @IBOutlet weak var videoImageView: NSImageView!
    private var socket: GCDAsyncUdpSocket?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.socket = getNewSocket()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    private func getNewSocket() -> GCDAsyncUdpSocket? {
        let port = UInt16(8080)
        let IP = "239.255.255.255"
        let sock = GCDAsyncUdpSocket(delegate: self, delegateQueue: .main)
        do {
            try sock.bind(toPort: port)
            try sock.joinMulticastGroup(IP)
            try sock.enableBroadcast(true)
            try sock.beginReceiving()
        } catch let err as NSError {
            print(err)
            print("Issue with setting up listener")
            return nil
        }
        return sock
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didNotConnect error: Error?) {
        print("didNotConnect \(error)")
    }

    func udpSocket(_ sock: GCDAsyncUdpSocket, didSendDataWithTag tag: Int) {
        print("didSendDataWithTag")
    }
    
    func udpSocket(_ sock: GCDAsyncUdpSocket, didReceive data: Data, fromAddress address: Data, withFilterContext filterContext: Any?) {
        guard let image = NSImage(data: data) else { return }
        self.videoImageView.image = image
    }
}

