//
//  UICollectionView+Extensions.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
import UIKit

extension UICollectionReusableView: ReusableView {}
extension UICollectionView {
    
    //
    // Extension function to register a UICollectionViewCell with the Type itself.
    //
    public func register<T: UICollectionViewCell>(nibType: T.Type) {
        let nib = UINib(nibName: nibType.nibName, bundle: nil)
        register(nib, forCellWithReuseIdentifier: nibType.cellreuseIdentifier)
    }
    
    public func register<T: UICollectionViewCell>(cellType: T.Type) {
        register(cellType, forCellWithReuseIdentifier: cellType.cellreuseIdentifier)
    }
    
    public func register<T: UICollectionReusableView>(nibType: T.Type, forSupplementaryViewOfKind: String) {
        let nib = UINib(nibName: nibType.nibName, bundle: nil)
        register(nib,
                 forSupplementaryViewOfKind: forSupplementaryViewOfKind,
                 withReuseIdentifier: nibType.cellreuseIdentifier)
    }
    
    public func register<T: UICollectionReusableView>(cellType: T.Type, forSupplementaryViewOfKind: String) {
        self.register(cellType,
                      forSupplementaryViewOfKind: forSupplementaryViewOfKind,
                      withReuseIdentifier: cellType.cellreuseIdentifier)
    }
}

extension UICollectionView {
    public func dequeue<T: UICollectionViewCell>(cell forCellType: T.Type, for indexPath: IndexPath) -> T? {
        return dequeueReusableCell(withReuseIdentifier: T.cellreuseIdentifier,
                                   for: indexPath) as? T
    }
    
    public func dequeue<T: UICollectionReusableView>(supplementaryView: T.Type, ofKind kind: String, for indexPath: IndexPath) -> T? {
        return dequeueReusableSupplementaryView(ofKind: kind,
                                                withReuseIdentifier: T.cellreuseIdentifier,
                                                for: indexPath) as? T
    }
}
