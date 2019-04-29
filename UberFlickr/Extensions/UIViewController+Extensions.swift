//
//  UIViewController+Extensions.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 30/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
import UIKit

extension UIViewController: NibLoadableView {
    
    public static var nibName: String {
        return String(describing: self)
    }
    
    public class func loadFromNib<T : UIViewController>(withName: String = T.nibName, bundle: Bundle? = nil) -> T {
        return T(nibName: withName, bundle: bundle)
    }
    
}
