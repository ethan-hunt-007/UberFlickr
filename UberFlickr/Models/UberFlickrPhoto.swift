//
//  UberFlickrPhoto.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

class UberFlickrPhoto: Codable {
    var photoId: String
    var server: String
    var farm: Int
    var secret: String
    
    public enum CodingKeys: String, CodingKey {
        case photoId = "id"
        case server
        case secret
        case farm
    }
    
    var imageUrl: URL? {
        if let _url: URL = URL(string: String(format: "https://farm%d.static.flickr.com/%@/%@_%@.jpg", farm, server, photoId, secret)) {
            return _url
        }
        return nil
    }
}
