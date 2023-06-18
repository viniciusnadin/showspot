//
//  ShowDetailComposer.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

public final class ShowDetailUIComposer {
    private init() {}
    
    public static func showDetailComposedWith(image: UIImage, show: FeedShow, episodeLoader: EpisodeLoaderProtocol, imageLoader: ImageDataLoader, selection: @escaping (FeedShow, UIImage) -> Void = { _,_  in }) -> ShowDetailViewController {
        let presentationAdapter = EpisodeLoaderPresentationAdapter(episodeLoader: MainQueueDispatchDecorator(decoratee: episodeLoader))
    
        let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: Bundle(for: ShowDetailViewController.self))
        let showDetailController = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        
        showDetailController.delegate = presentationAdapter
        showDetailController.show = show
        showDetailController.showImage = image
        
        presentationAdapter.presenter = ShowEpisodePresenter(
            showEpisodeView: ShowEpisodeAdapter(
                controller: showDetailController,
                imageLoader: MainQueueDispatchDecorator(decoratee: imageLoader),
                selection: selection
            ),
            loadingView: WeakRefVirtualProxy(showDetailController))
        
        return showDetailController
    }
    
}
