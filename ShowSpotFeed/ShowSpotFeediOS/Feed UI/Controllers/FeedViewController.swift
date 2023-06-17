//
//  FeedViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final public class FeedViewController: UICollectionViewController, UICollectionViewDataSourcePrefetching {
    
    private var refreshController: FeedRefreshViewController?
    var model = [FeedShowCellController]() {
        didSet { updateDataSource() }
    }
    enum Section { case main }
    
    private var feedLoader: FeedLoader?
    private var imageLoader: FeedImageDataLoader?
    private var tasks = [IndexPath: FeedImageDataLoaderTask]()
    private var dataSource: UICollectionViewDiffableDataSource<Section, FeedShow>!
    
    convenience init(refreshController: FeedRefreshViewController) {
        self.init()
        self.refreshController = refreshController
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.prefetchDataSource = self
        
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshController?.view
        } else {
            guard let view = refreshController?.view else { return }
            collectionView.addSubview(view)
        }
        refreshController?.refresh()
    }
    
    private func setDataSource() {
        dataSource = UICollectionViewDiffableDataSource(collectionView: collectionView, cellProvider: { collectionView, indexPath, feedShow in
            self.cellController(forRowAt: indexPath).view()
        })
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedShowCellController {
        return model[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
    
    func updateDataSource() {
        var snapShot = NSDiffableDataSourceSnapshot<Section, FeedShow>()
        snapShot.appendSections([.main])
        snapShot.appendItems(model.map { $0.model })
        dataSource.apply(snapShot, animatingDifferences: true, completion: nil)
    }
}
