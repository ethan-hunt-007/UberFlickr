//
//  JJImageDownloadOperation.swift
//  JJRemoteImage
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

public typealias ImageCompletionHandler = (_ image: UIImage?, _ url: URL, _ indexPath: IndexPath?, _ error: Error?) -> Void

class JJImageDownloadOperation: Operation {
    var completionHandler: ImageCompletionHandler?
    var imageUrl: URL
    var indexPath: IndexPath?
    
    init(imageUrl: URL, indexPath: IndexPath?) {
        self.imageUrl = imageUrl
        self.indexPath = indexPath
    }
    
    override var isAsynchronous: Bool {
        get {
            return true
        }
    }
    
    override var isExecuting: Bool {
        return _executing
    }
    
    override var isFinished: Bool {
        return _finished
    }
    
    private var _executing = false {
        willSet {
            willChangeValue(forKey: "isExecuting")
        }
        didSet {
            didChangeValue(forKey: "isExecuting")
        }
    }
    
    private var _finished = false {
        willSet {
            willChangeValue(forKey: "isFinished")
        }
        didSet {
            didChangeValue(forKey: "isFinished")
        }
    }
    
    func executing(_ executing: Bool) {
        _executing = executing
    }
    
    func finish(_ finished: Bool) {
        _finished = finished
    }
    
    override func main() {
        guard isCancelled == false else {
            finish(true)
            return
        }
        self.executing(true)
        self.downloadImage()
    }
    
    func downloadImage() {
        let downloadTask = URLSession.shared.dataTask(with: self.imageUrl) { (data, response, error) in
            if
                let _data = data,
                error == nil,
                let httpResponse = response as? HTTPURLResponse,
                httpResponse.statusCode == 200,
                let mimeType = response?.mimeType,
                mimeType.hasPrefix("image") {
                    let image = UIImage(data: _data)
                    self.completionHandler?(image, self.imageUrl, self.indexPath, error)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
    
}
