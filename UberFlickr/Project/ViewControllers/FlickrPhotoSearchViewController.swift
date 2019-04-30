//
//  FlickrPhotoSearchViewController.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import UIKit
import JJRemoteImage

class FlickrPhotoSearchViewController: UIViewController {

    @IBOutlet weak var searchBar: UISearchBar! {
        didSet {
            searchBar.delegate = self
        }
    }
    @IBOutlet weak var collectionView: UICollectionView! {
        didSet {
            collectionView.delegate = self
            collectionView.dataSource = self
            collectionView.register(nibType: FlickrPhotoCell.self)
            collectionView.register(cellType: CollectionViewFooterView.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionFooter)
        }
    }
    
    var viewModel: FlickrPhotoSearchViewModelProtocol!
    var sharedRemoteImageManager: JJRemoteImageManagerProtocol! {
        didSet {
            sharedRemoteImageManager.setCacheLimit(500)
        }
    }
    
    lazy var refreshControl: UIRefreshControl = {
        let refresControl = UIRefreshControl()
        refresControl.addTarget(self, action: #selector(refresh), for: UIControl.Event.valueChanged)
        return refresControl
    }()
    
    struct Constants {
        static let kItemInRow: CGFloat = 3
        static let kCollectionViewInsets: UIEdgeInsets = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        static let kFooterViewHeight: CGFloat = 50
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        bindViewsToModel()
        configureRefreshControl()
        // Do any additional setup after loading the view.
    }
    
    func bindViewsToModel() {
        viewModel.dataSource.bind { [weak self](_) in
            guard let strongSelf = self else { return }
            if strongSelf.refreshControl.isRefreshing {
                strongSelf.refreshControl.endRefreshing()
            }
            strongSelf.collectionView.reloadData()
        }
    }
    
    func configureRefreshControl() {
        collectionView.insertSubview(refreshControl, at: 0)
    }
    
    @objc func refresh() {
        viewModel.refresh()
    }

}

//MARK:- UICollectionViewDelegate methods
extension FlickrPhotoSearchViewController: UICollectionViewDelegate {
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.numberOfItems(in: indexPath.section)-1 == indexPath.item && viewModel.shouldFetchNextPage() {
            viewModel.fetchNextPage()
        }
        guard let _model = viewModel.model(at: indexPath) else {
            return
        }
        sharedRemoteImageManager.downloadImage(_model.imageUrl,
                                               indexPath: indexPath) { [weak self](image, url, indexPath, error) in
            guard
                let strongSelf = self,
                error == nil,
                let _indexPath = indexPath
            else { return }
            //Cell is extracted from and then image is set to avoid flickering
            let cell = strongSelf.collectionView.cellForItem(at: _indexPath) as? FlickrPhotoCell
            cell?.imageView.image = image
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        guard let _model = viewModel.model(at: indexPath) else { return }
        sharedRemoteImageManager.slowDownImageDownloadTask(for: _model.imageUrl)
    }
}

//MARK:- UICollectionViewDataSource methods
extension FlickrPhotoSearchViewController: UICollectionViewDataSource {
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return viewModel.numberOfSections
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeue(cell: FlickrPhotoCell.self, for: indexPath)!
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        if kind == UICollectionView.elementKindSectionFooter {
            let footerView = collectionView.dequeue(supplementaryView: CollectionViewFooterView.self, ofKind: UICollectionView.elementKindSectionFooter, for: indexPath)!
            return footerView
        }
        return UICollectionReusableView()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForFooterInSection section: Int) -> CGSize {
        guard viewModel.searchText.count > 2 else {
            return CGSize.zero
        }
        if viewModel.numberOfItems(in: 0) == 0 {
            return collectionView.bounds.size
        } else if viewModel.loadMore {
            return CGSize(width: collectionView.bounds.size.width, height: Constants.kFooterViewHeight)
        }
        return CGSize.zero
    }
}

//MARK:- UISearchBarDelegate methods
extension FlickrPhotoSearchViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        viewModel.searchFlickr(searchText)
    }

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.resignFirstResponder()
    }
}

//MARK:- UICollectionViewDelegateFlowLayoutMethods
extension FlickrPhotoSearchViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let totalPadding = (Constants.kItemInRow + 1) * Constants.kCollectionViewInsets.left
        let totalWidth = UIScreen.main.bounds.width - totalPadding
        let cellWidth = floor(totalWidth / Constants.kItemInRow)
        return CGSize(width: cellWidth, height: cellWidth)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return Constants.kCollectionViewInsets
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.kCollectionViewInsets.bottom
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.kCollectionViewInsets.right
    }
}
