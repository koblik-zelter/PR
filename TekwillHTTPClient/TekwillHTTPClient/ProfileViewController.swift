//
//  ProfileViewController.swift
//  TekwillHTTPClient
//
//  Created by Alex Koblik-Zelter on 5/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import UIKit
import WebKit

class ProfileViewController: UIViewController {
    
    private var webView: WKWebView!
    private var headers: [String: String] = [:]
    private var options: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupWebView()
        self.getHeaders()
        self.getOptions()
        self.configureWebView()
    }
    
    private func setupWebView() {
        self.webView = WKWebView(frame: self.view.frame, configuration: .init())
        self.view.addSubview(webView)
    }
    
    private func configureWebView() {
        APIManager.shared.getUserData { [unowned self] (res) in
            switch res {
                case .success(let html):
                    DispatchQueue.main.async {
                        self.webView.loadHTMLString(html, baseURL: nil)
                    }
                    break
                case .failure(let err):
                    print(err.rawValue)
                    break
            }
        }
    }
    
    private func getHeaders() {
        
        APIManager.shared.head { [unowned self] (res) in
            switch res {
                case .success(let headers):
                    DispatchQueue.main.async {
                        print(headers)
                        self.headers = headers
                    }
                    break
                case .failure(let err):
                    print(err.rawValue)
                    break
            }
        }
    }
    
    private func getOptions() {
        APIManager.shared.options { (res) in
            switch res {
                case .success(let options):
                    DispatchQueue.main.async {
                        print(options)
                        self.options = options
                    }
                    break
                case .failure(let err):
                    print(err.rawValue)
                    break
            }
        }
    }
    
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
