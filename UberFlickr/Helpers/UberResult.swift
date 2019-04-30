//
//  UberResult.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation

public enum UberResult<T> {
    case Success(T)
    case Failure(Error)
}
