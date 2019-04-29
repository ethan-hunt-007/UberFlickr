//
//  ObjectManager.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

class ObjectManager {
    typealias GETRequestCompeltion = ((Data) -> Void)
    var task: URLSessionTask?
    
    static let shared = ObjectManager()
    private init() {
        
    }
    func executeGET(withUrl url: String, completion: @escaping GETRequestCompeltion) {
        guard
            let _url = URL(string: url) else { return }
        executeGET(withUrl: _url, completion: completion)
        
    }
    
    func executeGET(withUrl url: URL, completion: @escaping GETRequestCompeltion) {
        task = URLSession.shared.dataTask(with: url, completionHandler: { (data, response, error) in
            guard
                let _data = data,
                error == nil,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200
                else {
                    return
            }
            completion(_data)
        })
        task?.resume()
    }
    
    func cancel() {
        task?.cancel()
    }
}
