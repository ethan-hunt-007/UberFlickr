//
//  MockRemoteImageManager.swift
//  UberFlickrTests
//
//  Created by Jayant Jaiswal on 30/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
@testable import JJRemoteImage

class MockRemoteImageManager: JJRemoteImageManagerProtocol {
    var downloadImageCalled: Bool = false
    var slowDownImageDownloadCalled: Bool = false
    var cancelAllDownloadTasksCalled: Bool = false
    func downloadImage(_ url: URL?, indexPath: IndexPath?, completion: @escaping ImageCompletionHandler) {
        downloadImageCalled = true
    }
    
    func slowDownImageDownloadTask(for url: URL?) {
        slowDownImageDownloadCalled = true
    }
    
    func cancellAllDownloadTasks() {
        cancelAllDownloadTasksCalled = true
    }
    
    
}
