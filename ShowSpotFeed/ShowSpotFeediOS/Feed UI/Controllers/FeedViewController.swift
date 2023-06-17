//
//  FeedViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final public class FeedViewController: UICollectionViewController {
    
    // MARK: - Attributes
    private var refreshController: FeedRefreshViewController?
    private var showDetailViewController: ShowDetailViewController?
    private var dataSource: UICollectionViewDiffableDataSource<Section, FeedShow>!
    
    enum Section { case main }
    
    var model = [FeedShowCellController]() { didSet { updateDataSource() }}
    
    // MARK: - Initializer
    convenience init(
        refreshController: FeedRefreshViewController,
        showDetailViewController: ShowDetailViewController
    ) {
        self.init(collectionViewLayout: UICollectionViewFlowLayout())
        self.refreshController = refreshController
        self.showDetailViewController = showDetailViewController
    }
    
    // MARK: - Life Cycle
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.prefetchDataSource = self
        
        registerShowCell()
        setDataSource()
        setRefreshController()
        refreshController?.refresh()
    }
    
    // MARK: - Private Methods
    private func registerShowCell() {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "ShowCell", bundle: bundle)
        collectionView.register(nib, forCellWithReuseIdentifier: ShowCell.reuseIdentifier)
    }
    
    private func setRefreshController() {
        if #available(iOS 10.0, *) {
            collectionView.refreshControl = refreshController?.view
        } else {
            guard let view = refreshController?.view else { return }
            collectionView.addSubview(view)
        }
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> FeedShowCellController {
        return model[indexPath.row]
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        cellController(forRowAt: indexPath).cancelLoad()
    }
}

// MARK: - CollectionViewDelegate
extension FeedViewController {
    public override func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public override func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        showDetailViewController?.show = model[indexPath.row].model
        self.navigationController?.pushViewController(showDetailViewController!, animated: true)
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
        var snapShot = NSDiffableDataSourceSnapshot<Section, FeedShow>()
        snapShot.appendSections([.main])
        snapShot.appendItems(model.map { $0.model })
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
