//
//  ViewController.swift
//  ReSwiftSample
//
//  Created by Shingai Yoshimi on 2018/02/10.
//  Copyright © 2018年 Shingai Yoshimi. All rights reserved.
//

import UIKit
import ReSwift
import SafariServices

class ViewController: UICollectionViewController {
    private let cellIdentifier = "ImageViewCell"
    
    private let searchController = UISearchController(searchResultsController: nil)
    private let itemsStore = Store<ItemsState>(
        reducer: itemsState,
        state: nil
    )
    private var searchTerms: String? = nil
    private var items: [Item] = []
    private var nextIndex: Int? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupRefreshControl()
        setupSeearchController()
        
        collectionView?.register(UINib(nibName: cellIdentifier, bundle: nil), forCellWithReuseIdentifier: cellIdentifier)
        
        itemsStore.subscribe(self)
    }
}

extension ViewController {
    fileprivate func setupSeearchController() {
        searchController.searchBar.delegate = self
        searchController.dimsBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
    }
    
    fileprivate func setupRefreshControl() {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh(sender:)), for: .valueChanged)
        collectionView?.refreshControl = refreshControl
    }
    
    @objc fileprivate func refresh(sender: UIRefreshControl) {
        guard let searchTerms = searchTerms else {
            return
        }
        collectionView?.refreshControl?.beginRefreshing()
        search(searchTerms)
    }
    
    fileprivate func search(_ q: String) {
        let request = CustomSearchRequest(keyword: q)
        itemsStore.dispatch(ItemsActionCreator.load(request: request))
    }
    
    fileprivate func loadMore() {
        guard let searchTerms = searchTerms else {
            return
        }
        let request = CustomSearchRequest(keyword: searchTerms, startIndex: nextIndex)
        itemsStore.dispatch(ItemsActionCreator.loadMore(request: request))
    }
}

extension ViewController {
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ImageViewCell
        cell.setup(with: items[indexPath.row])
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if indexPath.row == collectionView.numberOfItems(inSection: indexPath.section) - 1 {
            loadMore()
        }
    }
    
    override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let item = items[indexPath.row]
        if let url = URL(string: item.image.contextLink) {
            let safariVC = SFSafariViewController(url: url)
            present(safariVC, animated: true, completion: nil)
        }
    }
}

extension ViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let space: CGFloat = 10
        let width: CGFloat = (collectionView.frame.width - space)*0.5
        let item = items[indexPath.row]
        let imageSize = CGSize(width: item.image.width, height: item.image.height)
        return CGSize(width: width, height: width * (imageSize.height / imageSize.width))
    }
}

extension ViewController: StoreSubscriber {
    func newState(state: ItemsState) {
        if !state.isLoading {
            collectionView?.refreshControl?.endRefreshing()
            searchController.isActive = false
        }
        
        DispatchQueue.main.async {
            self.items = state.items
            self.nextIndex = state.nextIndex
            self.searchTerms = state.searchTerms
            self.collectionView?.reloadData()
        }
    }
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchBar.endEditing(true)
        
        guard let text = searchBar.text else {
            return
        }
        
        title = text
        search(text)
    }
}
