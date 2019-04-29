//
//  PhotosModel.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

class PhotosModel: Codable {
    var currentPage: Int
    var totalPages: Int
    var photos: [UberFlickrPhoto] = []
    var searchTerm: String?
    public enum CodingKeys: String, CodingKey {
        case currentPage = "page"
        case totalPages = "pages"
        case photos = "photo"
        case searchTerm
    }
}
