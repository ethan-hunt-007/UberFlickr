//
//  UberFlickrPhotoComponentAssembler.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
import JJRemoteImage

protocol UberFlickrPhotoComponentAssembler {
    func resolveFlickrPhotoSearchViewController() -> FlickrPhotoSearchViewController
    func resolveFlickrPhotoSearchViewModel() -> FlickrPhotoSearchViewModel
    func resolveFlickrPhotoSearchOperation() -> UberFlickrSearchOperation
    func resolveImageDownloadManager() -> JJRemoteImageManager
}

extension UberFlickrPhotoComponentAssembler where Self: UberFlickrPhotoComponentAssembler {
    func resolveFlickrPhotoSearchViewController() -> FlickrPhotoSearchViewController {
        let photoSearchVC: FlickrPhotoSearchViewController = FlickrPhotoSearchViewController.loadFromNib()
        photoSearchVC.viewModel = resolveFlickrPhotoSearchViewModel()
        photoSearchVC.sharedRemoteImageManager = resolveImageDownloadManager()
        photoSearchVC.title = "Uber Flickr"
        return photoSearchVC
    }
    
    func resolveFlickrPhotoSearchViewModel() -> FlickrPhotoSearchViewModel {
        return
            FlickrPhotoSearchViewModel(flickSearchOperation: resolveFlickrPhotoSearchOperation(),
                                       sharedRemoteImageManager: resolveImageDownloadManager())
    }
    
    func resolveFlickrPhotoSearchOperation() -> UberFlickrSearchOperation {
        return UberFlickrSearchOperation()
    }
    
    func resolveImageDownloadManager() -> JJRemoteImageManager {
        return JJRemoteImageManager.shared
    }
}
