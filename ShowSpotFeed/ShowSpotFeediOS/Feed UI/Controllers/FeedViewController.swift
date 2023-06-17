//
//  FeedViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

public protocol FeedViewControllerDelegate {
    func didRequestFeedRefresh()
    func didRequestFeedSearch(show: String)
}

final public class FeedViewController: UICollectionViewController {
    
    // MARK: - Attributes
    private var loadingControllers = [IndexPath: FeedShowCellController]()
    private var model = [FeedShowCellController]() { didSet { updateDataSource() }}
    private var feedModel = [FeedShowCellController]()
    public var delegate: FeedViewControllerDelegate?
    private var dataSource: UICollectionViewDiffableDataSource<Int, FeedShowCellController>!
    private var showDetailViewController: ShowDetailViewController?
    private let searchController = UISearchController()
    private var isFirstLoad = true
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        registerShowCell()
        configureSearchController()
        configureCollectionView()
        setDataSource()
    }
    
    public func display(_ cellControllers: [FeedShowCellController]) {
        loadingControllers = [:]
        model = cellControllers
        feedModel = model
    }
    
    public override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initialLoad()
        navigationController?.navigationBar.sizeToFit()
    }
    
    @objc private func refresh() {
        delegate?.didRequestFeedRefresh()
    }
    
    // MARK: - Private Methods
    private func registerShowCell() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShowCell", bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: ShowCell.reuseIdentifier)
    }
    
    private func configureSearchController() {
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = .search
        searchController.searchBar.delegate = self
        navigationItem.searchController = searchController
    }
    
    private func configureCollectionView() {
        let refreshControl = UIRefreshControl()
        collectionView.refreshControl = refreshControl
        collectionView.refreshControl?.addTarget(self, action: #selector(refresh), for: .valueChanged)
        collectionView.prefetchDataSource = self
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedShowCellController {
        let controller = model[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
    
    private func initialLoad() {
        if isFirstLoad {
            refresh()
            isFirstLoad = false
        }
    }
}

// MARK: - CollectionViewDelegate
extension FeedViewController {
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model[indexPath.row].selection()
    }
}

// MARK: - FeedViewController DataSourcePrefetching
extension FeedViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
}

// MARK: - FeedViewController DiffableDataSource
extension FeedViewController {
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, feedShow in
            self.cellController(forRowAt: indexPath).view(collectionView: collectionView, indexPath: indexPath)
        })
    }
    
    private func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Int, FeedShowCellController>()
        snapShot.appendSections([0])
        snapShot.appendItems(model, toSection: 0)
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
}

// MARK: - FeedViewController UICollectionViewDelegateFlowLayout
extension FeedViewController: UICollectionViewDelegateFlowLayout {
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = self.view.frame.size.width / 2.1
        let height = self.view.frame.height / 2.8
        return CGSize(width: width, height: height)
    }
}

// MARK: - SearchViewControler implements UISearchBarDelegate
extension FeedViewController: UISearchBarDelegate {
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchBar.text = searchController.searchBar.text
    }
    
    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        model = feedModel
        updateDataSource()
    }
    
}

// MARK: - Extensions UISearchResultsUpdating
extension FeedViewController: UISearchResultsUpdating {
    
    public func updateSearchResults(for searchController: UISearchController) {
        guard let searchText = searchController.searchBar.text else { return }
        if searchText == "" { return model = feedModel }
        delegate?.didRequestFeedSearch(show: searchText)
        model = feedModel.filter { $0.showName.lowercased().contains(searchText.lowercased()) }
        updateDataSource()
    }

}

extension FeedViewController: FeedLoadingView {
    public func display(_ viewModel: FeedLoadingViewModel) {
        collectionView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

extension UIRefreshControl {
    func update(isRefreshing: Bool) {
        isRefreshing ? beginRefreshing() : endRefreshing()
    }
}
