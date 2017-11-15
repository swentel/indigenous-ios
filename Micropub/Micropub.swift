//
//  Micropub.swift
//  Indigenous
//
//  Created by Edward Hinkle on 11/14/17.
//  Copyright © 2017 Studio H, LLC. All rights reserved.
//

import Foundation

func sendMicropub(forAction: String, aboutUrl: URL, completion: @escaping () -> Swift.Void) {
    
    DispatchQueue.global(qos: .background).async {
        var entryString = ""
        
        switch(forAction) {
            case "Like":
                entryString = "h=entry&like-of=\(aboutUrl.absoluteString)"
            case "Repost":
                entryString = "h=entry&repost-of=\(aboutUrl.absoluteString)"
            case "Bookmark":
                entryString = "h=entry&bookmark-of=\(aboutUrl.absoluteString)"
            case "Listen":
                entryString = "h=entry&listen-of=\(aboutUrl.absoluteString)"
            default:
                print("ERROR")
        }
        
        let defaults = UserDefaults(suiteName: "group.software.studioh.indigenous")
        let micropubAuth = defaults?.dictionary(forKey: "micropubAuth")
        
        if let micropubDetails = micropubAuth,
            let micropubEndpoint = URL(string: micropubDetails["micropub_endpoint"] as! String) {
            
            var request = URLRequest(url: micropubEndpoint)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let bodyString = "\(entryString)&access_token=\(micropubDetails["access_token"]!)"
            let bodyData = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
            request.httpBody = bodyData
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                completion()
            }
            task.resume()
        }
    }
}

func sendMicropub(note: String, completion: @escaping () -> Swift.Void) {
    
    DispatchQueue.global(qos: .background).async {
        var entryString = "h=entry&content=\(note)"
        
        let defaults = UserDefaults(suiteName: "group.software.studioh.indigenous")
        let micropubAuth = defaults?.dictionary(forKey: "micropubAuth")
        
        if let micropubDetails = micropubAuth,
            let micropubEndpoint = URL(string: micropubDetails["micropub_endpoint"] as! String) {
            
            var request = URLRequest(url: micropubEndpoint)
            request.httpMethod = "POST"
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            request.setValue("application/x-www-form-urlencoded", forHTTPHeaderField: "Content-Type")
            let bodyString = "\(entryString)&access_token=\(micropubDetails["access_token"]!)"
            let bodyData = bodyString.data(using:String.Encoding.utf8, allowLossyConversion: false)
            request.httpBody = bodyData
            
            // set up the session
            let config = URLSessionConfiguration.default
            let session = URLSession(configuration: config)
            
            let task = session.dataTask(with: request) { (data, response, error) in
                completion()
            }
            task.resume()
        }
    }
}
