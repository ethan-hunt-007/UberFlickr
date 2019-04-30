//
//  PaginationModel.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

public struct PaginationModel: Equatable {
    var nextPage: Int
    var totalPages: Int
    
    init(nextPage: Int, totalPages: Int) {
        self.nextPage = nextPage
        self.totalPages = totalPages
    }
    
    public static func ==(lhs: PaginationModel, rhs: PaginationModel) -> Bool {
        return lhs.nextPage == rhs.nextPage && lhs.totalPages == rhs.totalPages
    }
}
