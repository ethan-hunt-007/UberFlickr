//
//  FlickrSearchViewModelTest.swift
//  UberFlickrTests
//
//  Created by Jayant Jaiswal on 30/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import XCTest
@testable import UberFlickr
@testable import JJRemoteImage

class FlickrSearchViewModelTest: XCTestCase {
    var viewModel: FlickrPhotoSearchViewModel!
    var operation: MockUberFlickrSearchOperation!
    var remoteImageManager: MockRemoteImageManager!
    override func setUp() {
        super.setUp()
        operation = MockUberFlickrSearchOperation()
        operation.stubPhotosModel = stubPhotosModel()
        remoteImageManager = MockRemoteImageManager()
        viewModel = FlickrPhotoSearchViewModel(flickSearchOperation: operation,
                                               sharedRemoteImageManager: remoteImageManager)
    }
    
    override func tearDown() {
        viewModel = nil
        operation = nil
        remoteImageManager = nil
        super.tearDown()
    }
    
    func test_flickSearchAPI() {
        let searchUrl: String = operation.searchURL(for: "birds", page: 1, apiKey: MockUberFlickrSearchOperation.Constants.API_KEY)!.absoluteString
        XCTAssert(searchUrl == "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=abcXYZ123&format=json&nojsoncallback=1&safe_search=1&text=birds&page=1")
    }
    
    func test_imageAPI() {
        XCTAssert(stubFlickrPhoto().imageUrl!.absoluteString == "https://farm23.static.flickr.com/xyz123/abc123_alphaBeta.jpg")
    }
    
    func test_dataSource() {
        viewModel.searchText = "birds"
        viewModel.search(viewModel.searchText)
        XCTAssertTrue(operation.isFetchResultsCalled)
        XCTAssert(viewModel.dataSource.value.count == stubFlickrPhotos().count)
        viewModel.search("birds")
        XCTAssert(viewModel.dataSource.value.count == stubFlickrPhotos().count * 2)
        viewModel.search("birds")
        XCTAssert(viewModel.dataSource.value.count == stubFlickrPhotos().count * 3)
        viewModel.refresh()
        XCTAssert(viewModel.dataSource.value.count == stubFlickrPhotos().count)
    }
    
}

extension FlickrSearchViewModelTest {
    func stubFlickrPhoto() -> UberFlickrPhoto {
        return UberFlickrPhoto(photoId: "abc123",
                               server: "xyz123",
                               farm: 23,
                               secret: "alphaBeta")
    }
    
    func stubFlickrPhotos() -> [UberFlickrPhoto] {
        var photos:[UberFlickrPhoto] = []
        photos.append(UberFlickrPhoto(photoId: "abc123",
                                      server: "xyz123",
                                      farm: 23,
                                      secret: "alphaBeta"))
        photos.append(UberFlickrPhoto(photoId: "abc124",
                                      server: "xyz124",
                                      farm: 24,
                                      secret: "alphaBeta1"))
        photos.append(UberFlickrPhoto(photoId: "abc125",
                                      server: "xyz125",
                                      farm: 25,
                                      secret: "alphaBeta2"))
        return photos
    }
    
    func stubPhotosModel() -> PhotosModel {
        return PhotosModel(currentPage: 1,
                           totalPages: 100,
                           photos: stubFlickrPhotos(),
                           searchTerm: "abc")
    }
}
