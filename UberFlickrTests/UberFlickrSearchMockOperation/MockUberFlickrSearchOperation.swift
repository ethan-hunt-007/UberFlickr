//
//  MockUberFlickrSearchOperation.swift
//  UberFlickrTests
//
//  Created by Jayant Jaiswal on 30/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
@testable import UberFlickr

class MockUberFlickrSearchOperation: UberFlickrSearchOperationProtocol {
    var isFetchResultsCalled: Bool = false
    var stubPhotosModel: PhotosModel!
    struct Constants {
        static let API_KEY: String = "abcXYZ123"
    }
    
    func fetchResults(for query: String,
                      page: Int,
                      completion: @escaping FlickrSearchCompletion) {
        isFetchResultsCalled = true
        stubPhotosModel.searchTerm = query
        stubPhotosModel.currentPage = page
        completion(.Success((stubPhotosModel,
                             PaginationModel(nextPage: page + 1, totalPages: 100))))
    }
    
}
