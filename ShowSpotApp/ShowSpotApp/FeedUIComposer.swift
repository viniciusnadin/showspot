//
//  FeedUIComposer.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

public final class FeedUIComposer {
    private init() {}
    
    public static func feedComposedWith(feedLoader: FeedLoaderProtocol, imageLoader: ImageDataLoader, selection: @escaping (FeedShow) -> Void = { _ in }) -> FeedViewController {
        
        let presentationAdapter = FeedLoaderPresentationAdapter(feedLoader:
            MainQueueDispatchDecorator(decoratee: feedLoader))
        
        let feedController = FeedViewController(collectionViewLayout: UICollectionViewFlowLayout())
        feedController.delegate = presentationAdapter
        feedController.title = "Shows"

        presentationAdapter.presenter = FeedPresenter(
            feedView: FeedViewAdapter(
                controller: feedController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader),
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(feedController))
        
        return feedController
    }
}

public final class ShowDetailUIComposer {
    private init() {}
    
    public static func showDetailComposedWith(show: FeedShow, episodeLoader: EpisodeLoaderProtocol, imageLoader: ImageDataLoader) -> ShowDetailViewController {
        let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: Bundle(for: ShowDetailViewController.self))
        let showDetailController = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        showDetailController.imageLoader = imageLoader
        showDetailController.episodeLoader = episodeLoader
        showDetailController.show = show
        return showDetailController
    }
    
}
