//
//  UIView+Extensions.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
import UIKit

//
// A protocol which defines a reuseIdentifier String on Type.
//
public protocol ReusableView: class {
    static var cellreuseIdentifier: String {get}
}
//
// Default Implementation of ResusableView Protocol only for UIView.
// Useful in situations where a unique identifier is needed for a UIView such as
// in CollectionView/TableView.
//
extension ReusableView where Self: UIView {
    public static var cellreuseIdentifier: String {
        return String(describing: self)
    }
}

//
// A protocol which defines a string which serves as NibName for the UIView Class.
// Expected to be used only on UIView or its subclasses.
//
public protocol NibLoadableView: class {
    static var nibName: String {get}
}
//
// Default Implementation of NibLoadableView for UIView.
// Assumption: Every UIView class for which a nib EXISTS will need to have SAME name as
// class itself, to use this property.
// Keywords: EXISTS -> Its possible a UIView is made programmatically.
//           SAME -> Nib must have same name as custom UIView class.
//
extension NibLoadableView where Self: UIView {
    public static var nibName: String {
        return String(describing: self)
    }
}

extension NibLoadableView where Self: UIView {
    
    //
    // Class function to load a UIView from its nib.
    // Assumption: Nib name is same as UIview class name.
    //
    public static func loadFromNib(withName name: String = nibName,
                                   withBundle bundle: Bundle = .main,
                                   owner: Any? = nil,
                                   options: [UINib.OptionsKey: Any]? = nil) -> Self {
        return bundle.loadNibNamed(name, owner: owner, options: options)?[0] as! Self
    }
    
    //
    // Generic Function to generate a uiview with CGRect.zero frame
    // Example use case: UITableViewHeaderFooterView.zero
    //
    public static func zero<T: UIView>() -> T {
        return T(frame: .zero)
    }
}

extension UIView : NibLoadableView {}

struct ViewEdges: OptionSet {
    let rawValue: Int
    
    static let left = ViewEdges(rawValue: 1)
    static let top = ViewEdges(rawValue: 2)
    static let right = ViewEdges(rawValue: 4)
    static let bottom = ViewEdges(rawValue: 8)
    static let all: ViewEdges = [.left, .right, .top, .bottom]
}
extension UIView {
    func bottomOfViewInside(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.topAnchor, constant: constant)
            ])
    }
    func topOfViewInside(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            view.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: constant)
            ])
    }
    func rightOfViewInside(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: constant)
            ])
    }
    func leftOfViewInside(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            view.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant)
            ])
    }
    func leftOfView(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            view.leadingAnchor.constraint(equalTo: self.trailingAnchor, constant: constant)
            ])
    }
    func rightOfView(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            self.leadingAnchor.constraint(equalTo: view.trailingAnchor, constant: constant)
            ])
    }
    func topOfView(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            view.topAnchor.constraint(equalTo: self.bottomAnchor, constant: constant)
            ])
    }
    func bottomOfView(view: UIView, constant: CGFloat) {
        NSLayoutConstraint.activate([
            self.topAnchor.constraint(equalTo: view.bottomAnchor, constant: constant)
            ])
    }
    func fixHeight(to height: CGFloat) {
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: height)
            ])
    }
    func fixWidth(to width: CGFloat) {
        NSLayoutConstraint.activate([
            self.widthAnchor.constraint(equalToConstant: width)
            ])
    }
    
    func fixEdges(_ edges: ViewEdges, toView view: UIView, constant: CGFloat = 0) {
        if edges.contains(.left) {
            self.rightOfViewInside(view: view, constant: constant)
        }
        if edges.contains(.right) {
            self.leftOfViewInside(view: view, constant: constant)
        }
        if edges.contains(.top) {
            self.bottomOfViewInside(view: view, constant: constant)
        }
        if edges.contains(.bottom) {
            self.topOfViewInside(view: view, constant: constant)
        }
    }
}
