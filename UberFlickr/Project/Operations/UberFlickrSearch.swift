//
//  UberFlickrSearch.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

public typealias FlickrSearchResult = UberResult<(PhotosModel, PaginationModel)>
public typealias FlickrSearchCompletion = ((FlickrSearchResult) -> Void)

public protocol UberFlickrSearchOperationProtocol {
    func fetchResults(for query: String, page: Int, completion: @escaping FlickrSearchCompletion)
    func searchURL(for query: String, page: Int, apiKey: String) -> URL?
}

extension UberFlickrSearchOperationProtocol {
    public func searchURL(for query: String, page: Int, apiKey: String) -> URL? {
        guard let searchTerm = query.addingPercentEncoding(withAllowedCharacters: CharacterSet.alphanumerics) else {
            return nil
        }
        let urlString = "https://api.flickr.com/services/rest/?method=flickr.photos.search&api_key=\(apiKey)&format=json&nojsoncallback=1&safe_search=1&text=\(searchTerm)&page=\(page)"
        if let _url = URL(string: urlString) {
            return _url
        }
        return nil
    }
}

class UberFlickrSearchOperation: UberFlickrSearchOperationProtocol {
    struct Search {
        static let API_KEY: String = "3e7cc266ae2b0e0d78e279ce8e361736"
        static let DOMAIN: String = "UberFlickrSearch"
    }
    
    struct Constants {
        static let kSearchFailureMsg: String = "Unknown Response"
    }
    
    let searchError: NSError = NSError(domain: Search.DOMAIN, code: 0, userInfo: [NSLocalizedFailureReasonErrorKey: Constants.kSearchFailureMsg])
    
    func fetchResults(for query: String, page: Int, completion: @escaping FlickrSearchCompletion) {
        guard let _searchUrl = searchURL(for: query, page: page, apiKey: Search.API_KEY) else {
            completion(.Failure(searchError))
            return
        }
        ObjectManager.shared.executeGET(withUrl: _searchUrl) { [weak self](data) in
            guard let strongSelf = self else { return }
            guard
                let json = try? JSONSerialization.jsonObject(with: data, options: JSONSerialization.ReadingOptions(rawValue: 0)) as? [String: AnyObject] ?? [:],
                let photos = json["photos"] else {
                    DispatchQueue.main.async {
                        completion(.Failure(strongSelf.searchError))
                    }
                    return
            }
            do {
                let _data: Data = try JSONSerialization.data(withJSONObject: photos)
                var result = try JSONDecoder().decode(PhotosModel.self, from: _data)
                result.searchTerm = query
                var paginationModel: PaginationModel
                if result.currentPage < result.totalPages {
                    paginationModel = PaginationModel(nextPage: result.currentPage+1,
                                                      totalPages: result.totalPages)
                } else {
                    paginationModel = PaginationModel(nextPage: result.currentPage,
                                                      totalPages: result.totalPages)
                    if result.currentPage > result.totalPages {
                        result.photos = []
                    }
                }
                DispatchQueue.main.async {
                    completion(.Success((result, paginationModel)))
                }
            } catch {
                DispatchQueue.main.async {
                    completion(.Failure(strongSelf.searchError))
                }
            }
        }
    }
}
