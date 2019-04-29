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
        let downloadTask = URLSession.shared.downloadTask(with: self.imageUrl) { (downloadPath, response, error) in
            if
                let _downloadPath = downloadPath,
                let data = try? Data(contentsOf: _downloadPath) {
                    let image = UIImage(data: data)
                    self.completionHandler?(image, self.imageUrl, self.indexPath, error)
            }
            self.finish(true)
            self.executing(false)
        }
        downloadTask.resume()
    }
    
}
