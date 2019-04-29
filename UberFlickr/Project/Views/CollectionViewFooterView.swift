//
//  CollectionViewFooterView.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 30/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
import UIKit

class CollectionViewFooterView: UICollectionReusableView {
    private var activityIndicator: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView(style: .gray)
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.startAnimating()
        return activityIndicatorView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        constructLayout()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        constructLayout()
    }
    
    fileprivate func constructLayout() {
        let containerView = UIView()
        addSubview(containerView)
        containerView.leftOfViewInside(view: self, constant: 0)
        containerView.rightOfViewInside(view: self, constant: 0)
        containerView.topOfViewInside(view: self, constant: 0)
        containerView.bottomOfViewInside(view: self, constant: 0)
        containerView.backgroundColor = UIColor.white
        containerView.translatesAutoresizingMaskIntoConstraints = false
        containerView.addSubview(activityIndicator)
        activityIndicator.centerVertically(to: containerView)
        activityIndicator.centerHorizontally(to: containerView)
    }
}
