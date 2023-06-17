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
        let refreshController = FeedRefreshViewController(feedLoader: feedLoader)
        let feedController = FeedViewController(refreshController: refreshController)
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
}
