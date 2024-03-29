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
    
    public static func feedComposedWith(feedLoader: FeedLoaderProtocol, imageLoader: ImageDataLoader, selection: @escaping (FeedShow, UIImage) -> Void = { _,_  in }) -> FeedViewController {
        
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
