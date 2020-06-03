//
//  ViewController.swift
//  udpClient
//
//  Created by Alex Koblik-Zelter on 6/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import Network
import Lottie

class ViewController: UIViewController {

    var connection: NWConnection?
    var hostUDP: NWEndpoint.Host = "239.255.255.255"
    var portUDP: NWEndpoint.Port = 8080
    
    let button = UIButton()
    
    private let animationView: AnimationView = {
        let animationView = AnimationView(name: "shuttle")
        animationView.translatesAutoresizingMaskIntoConstraints = false
        return animationView
    }()
    
    var screenshotTimer: Timer!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        self.setupAnimation()
        
        connectToUDP(hostUDP,portUDP)
        screenshotTimer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(takeScreenshot), userInfo: nil, repeats: true)
        
    }
    
    private func setupAnimation() {
        self.animationView.contentMode = .scaleToFill
        self.animationView.loopMode = .loop
        self.animationView.animationSpeed = 2.0
        self.view.addSubview(animationView)
        
        self.animationView.centerYAnchor.constraint(equalTo: self.view.centerYAnchor).isActive = true
        self.animationView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
        self.animationView.heightAnchor.constraint(equalToConstant: 75).isActive = true
        self.animationView.widthAnchor.constraint(equalToConstant: 75).isActive = true
        self.animationView.play()
    }
    
    @objc func takeScreenshot() {
        var image: UIImage?
        let currentLayer = self.animationView.layer
        let currentScale = UIScreen.main.scale
        UIGraphicsBeginImageContextWithOptions(currentLayer.frame.size, false, currentScale);
        guard let currentContext = UIGraphicsGetCurrentContext() else {return}
        currentLayer.render(in: currentContext)
        image = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let img = image else { return }
        self.sendUDP(img.pngData()!)
    }
    
    func connectToUDP(_ hostUDP: NWEndpoint.Host, _ portUDP: NWEndpoint.Port) {
        
        self.connection = NWConnection(host: hostUDP, port: portUDP, using: .udp)
        
        self.connection?.stateUpdateHandler = { (newState) in
            switch (newState) {
            case .ready:
                print("State: Ready\n")
                self.receiveUDP()
            case .setup:
                print("State: Setup\n")
            case .cancelled:
                print("State: Cancelled\n")
            case .preparing:
                print("State: Preparing\n")
            default:
                print("Error! State not defined!\n")
            }
        }
        
        self.connection?.start(queue: .global())
    }
    
    func sendUDP(_ content: Data) {
        self.connection?.send(content: content, completion: NWConnection.SendCompletion.contentProcessed(({ (NWError) in
            if (NWError == nil) {
                print("Data was sent to UDP")
            } else {
                print("ERROR! Error when data (Type: Data) sending. NWError: \n \(NWError!)")
            }
        })))
    }
    
    func receiveUDP() {
        self.connection?.receiveMessage { (data, context, isComplete, error) in
            if (isComplete) {
                print("Receive is complete")
                if (data != nil) {
                    let backToString = String(decoding: data!, as: UTF8.self)
                    print("Received message: \(backToString)")
                } else {
                    print("Data == nil")
                }
            }
        }
    }
    
}


