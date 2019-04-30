//
//  FlickrPhotoSearchViewModel.swift
//  UberFlickr
//
//  Created by Jayant Jaiswal on 29/04/19.
//  Copyright © 2019 Jayant Jaiswal. All rights reserved.
//

import Foundation
import JJRemoteImage

protocol FlickrPhotoSearchViewModelProtocol {
    var dataSource: PropertyBinder<[UberFlickrPhoto]> { get set }
    var loadingPhotosFailed: PropertyBinder<Bool> { get set }
    var numberOfSections: Int { get }
    var searchText: String { get set }
    var loadMore: Bool { get set }
    var paginationModel: PaginationModel { get set }
    func searchFlickr(_ query: String)
    func shouldFetchNextPage() -> Bool
    func numberOfItems(in section: Int) -> Int
    func refresh()
    func fetchNextPage()
    func model(at indexPath: IndexPath) -> UberFlickrPhoto?
    func search(_ query: String)
}

class FlickrPhotoSearchViewModel: FlickrPhotoSearchViewModelProtocol {
    var flickSearchOperation: UberFlickrSearchOperationProtocol
    var sharedRemoteImageManager: JJRemoteImageManagerProtocol!
    var dataSource: PropertyBinder<[UberFlickrPhoto]> = PropertyBinder([])
    var paginationModel: PaginationModel = PaginationModel(nextPage: 1, totalPages: Int(INT_MAX))
    var loadingPhotosFailed: PropertyBinder<Bool> = PropertyBinder(false)
    var searchText: String = ""
    var searchTimer: Timer?
    var loadMore: Bool = true
    
    struct Constants {
        static let kMinCharsToSearch: Int = 3
    }
    
    init(flickSearchOperation: UberFlickrSearchOperationProtocol,
         sharedRemoteImageManager: JJRemoteImageManagerProtocol) {
        self.flickSearchOperation = flickSearchOperation
        self.sharedRemoteImageManager = sharedRemoteImageManager
    }
    
    func searchFlickr(_ query: String) {
        searchText = query
        dataSource.value.removeAll()
        if query.count >= Constants.kMinCharsToSearch {
            searchWithDelay()
        }
    }
    
    func refresh() {
        resetVariables()
        search(searchText)
    }
    
    func fetchNextPage() {
        search(searchText)
    }
    
    func model(at indexPath: IndexPath) -> UberFlickrPhoto? {
        guard indexPath.item < dataSource.value.count else {
            return nil
        }
        return dataSource.value[indexPath.item]
    }
    
    func search(_ query: String) {
        flickSearchOperation.fetchResults(for: query,
                                          page: paginationModel.nextPage) { [weak self](result) in
                                            guard let strongSelf = self else { return }
                                            strongSelf.cancelDownloadOperationsAndClearDataSource(page: strongSelf.paginationModel.nextPage)
                                            switch result {
                                            case .Success(let photosModel, let paginationModel):
                                                guard photosModel.searchTerm == strongSelf.searchText else { return }
                                                strongSelf.modifyDataSource(photosModel, for: paginationModel.nextPage)
                                                if strongSelf.paginationModel == paginationModel {
                                                    strongSelf.loadMore = false
                                                }
                                                strongSelf.paginationModel = paginationModel
                                            case .Failure(_):
                                                strongSelf.loadingPhotosFailed.value = true
                                            }
        }
    }
    
}

//MARK:- Private methods
extension FlickrPhotoSearchViewModel {
    fileprivate func resetVariables() {
        paginationModel.nextPage = 1
        self.loadMore = true
    }
    
    fileprivate func searchWithDelay() {
        searchTimer?.invalidate()
        searchTimer = nil
        searchTimer = Timer.scheduledTimer(timeInterval: 0.5,
                                           target: self,
                                           selector: #selector(searchFilter(sender:)),
                                           userInfo: ["search" : searchText ],
                                           repeats: false)
    }
    
    @objc fileprivate func searchFilter(sender: Timer) {
        guard let _searchDict = (sender.userInfo as? [String: Any]),
            let _searchString = _searchDict["search"] as? String,
            _searchString == searchText
            else { return }
        resetVariables()
        search(_searchString)
    }
    
    fileprivate func modifyDataSource(_ photosModel: PhotosModel, for page: Int) {
        if self.paginationModel.nextPage < page {
            dataSource.value.append(contentsOf: photosModel.photos)
        }
    }
    
    fileprivate func cancelDownloadOperationsAndClearDataSource(page: Int) {
        if page == 1 {
            sharedRemoteImageManager.cancellAllDownloadTasks()
            dataSource.value.removeAll()
        }
    }
}

extension FlickrPhotoSearchViewModel {
    var numberOfSections: Int {
        return 1
    }
    
    func numberOfItems(in section: Int) -> Int {
        return dataSource.value.count
    }
    
    func shouldFetchNextPage() -> Bool {
        return paginationModel.nextPage <= paginationModel.totalPages && self.loadMore
    }
}
