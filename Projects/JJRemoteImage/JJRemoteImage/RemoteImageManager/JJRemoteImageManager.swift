//
//  JJRemoteImageManager.swift
//  JJRemoteImage
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

public protocol JJRemoteImageManagerProtocol {
    func downloadImage(_ url: URL?, indexPath: IndexPath?, completion: @escaping ImageCompletionHandler)
    func slowDownImageDownloadTask(for url: URL?)
    func cancellAllDownloadTasks()
}

public class JJRemoteImageManager: JJRemoteImageManagerProtocol {
    
    public static let shared = JJRemoteImageManager()
    
    fileprivate lazy var imageDownloadQueue: OperationQueue = {
        var queue = OperationQueue()
        queue.name = "com.jjRemoteImage.imageDownloadQueue"
        queue.qualityOfService = .userInteractive
        return queue
    }()
    fileprivate lazy var imageCache: NSCache<NSString, UIImage> = {
        return NSCache<NSString, UIImage>()
    }()
    
    public func downloadImage(_ url: URL?,
                              indexPath: IndexPath?,
                              completion: @escaping ImageCompletionHandler) {
        guard let _url = url else { return }
        if let cachedImage = imageCache.object(forKey: _url.absoluteString as NSString) {
            DispatchQueue.main.async {
                completion(cachedImage, _url, indexPath, nil)
            }
        } else {
            if let operations = (imageDownloadQueue.operations as? [JJImageDownloadOperation])?.filter({$0.imageUrl.absoluteString == _url.absoluteString && $0.isFinished == false && $0.isExecuting == true }),
                let operation = operations.first {
                operation.queuePriority = .veryHigh
            } else {
                let operation = JJImageDownloadOperation(imageUrl: _url, indexPath: indexPath)
                if indexPath == nil {
                    operation.queuePriority = .high
                }
                operation.completionHandler = { (image, url, indexPath, error) in
                    if let newImage = image {
                        self.imageCache.setObject(newImage, forKey: url.absoluteString as NSString)
                    }
                    DispatchQueue.main.async {
                        completion(image, url, indexPath, error)
                    }
                }
                imageDownloadQueue.addOperation(operation)
            }
        }
    }
    
    public func slowDownImageDownloadTask(for url: URL?) {
        guard let _url = url else {
            return
        }
        if let operations = (imageDownloadQueue.operations as? [JJImageDownloadOperation])?.filter({$0.imageUrl.absoluteString == _url.absoluteString && $0.isFinished == false && $0.isExecuting == true }),
            let operation = operations.first {
            operation.queuePriority = .low
        }
    }
    
    public func cancellAllDownloadTasks() {
        imageDownloadQueue.cancelAllOperations()
    }
}
