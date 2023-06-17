//
//  FeedUIComposer.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoader, imageLoader: FeedImageDataLoader) -> FeedViewController {
        let showDetailController = showDetailViewController(imageLoader: imageLoader)
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController, showDetailViewController: showDetailController)
        refreshController.onRefresh = adaptFeedToCellControllers(forwardingTo: feedController, loader: imageLoader)
        return feedController
    }
    
    private static func adaptFeedToCellControllers(forwardingTo controller: FeedViewController, loader: FeedImageDataLoader) -> ([FeedShow]) -> Void {
        return { [weak controller] feed in
            controller?.model = feed.map { model in
                FeedShowCellController(model: model, imageLoader: loader)
            }
        }
    }
    
    private static func showDetailViewController(imageLoader: FeedImageDataLoader) -> ShowDetailViewController {
        let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: Bundle(for: ShowDetailViewController.self))
        let vc = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        vc.imageLoader = imageLoader
        return vc
    }
}
