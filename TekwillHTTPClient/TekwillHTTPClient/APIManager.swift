//
//  APIManager.swift
//  TekwillHTTPClient
//
//  Created by Alex Koblik-Zelter on 5/3/20.
//  Copyright © 2020 Alex Koblik-Zelter. All rights reserved.
//

import Foundation


class APIManager {
    static let shared = APIManager()
    
    private init() { }
    
    func login(login: String, password: String, handler: @escaping(Result<Int, Errors>) -> Void) {
        guard let url = URL(string: "https://tekwill.md/api/LoginUser.php") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let dataThing = "action=save&email=\(login)&password=\(password)".data(using: .utf8)
        request.httpBody = dataThing
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            guard let resp = response as? HTTPURLResponse, let dict = resp.allHeaderFields as? [String: String], let link = response?.url else {
                handler(.failure(.invalidResponse))
                return
            }
            // Check for Error
            guard data != nil else {
                handler(.failure(.invalidData))
                return
            }
            
            let cookies = HTTPCookie.cookies(withResponseHeaderFields: dict, for: link)
            HTTPCookieStorage.shared.setCookie(cookies.first!)
            print(cookies)
            handler(.success(resp.statusCode))
        }
        task.resume()
    }
    
    func getUserData(handler: @escaping(Result<String, Errors>) -> Void) {
        guard let url = URL(string: "https://www.tekwill.md/account/profile") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                handler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                handler(.failure(.invalidResponse))
                return
            }
            
            guard let data = data, let dataString = String(data: data, encoding: .utf8) else {
                handler(.failure(.invalidData))
                return
            }
                
//             print("Response data string:\n \(dataString)")
            handler(.success(dataString))
        }
        task.resume()
    }
    
    func head(handler: @escaping(Result<[String: String], Errors>) -> Void) {
        guard let url = URL(string: "https://www.tekwill.md/account/profile") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "HEAD"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                handler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(.invalidResponse))
                return
            }
            
            guard let dict = response.allHeaderFields as? [String: String] else {
                handler(.failure(.invalidResponse))
                return
            }
            
            handler(.success(dict))
        }
        task.resume()
    }
    
    func options(handler: @escaping(Result<String, Errors>) -> Void) {
        guard let url = URL(string: "https://google.com") else { return }
        var request = URLRequest(url: url)
        request.httpMethod = "OPTIONS"
        
        let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
            if let _ = error {
                handler(.failure(.unableToComplete))
                return
            }
            
            guard let response = response as? HTTPURLResponse else {
                handler(.failure(.invalidResponse))
                return
            }

            guard let dict = response.allHeaderFields as? [String: String] else {
                handler(.failure(.invalidResponse))
                return
            }
            
            let allow = dict["allow"]
            handler(.success(allow!))
        }
        task.resume()
    }
}
