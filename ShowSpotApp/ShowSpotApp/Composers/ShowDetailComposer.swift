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
    
    public static func showDetailComposedWith(show: FeedShow, episodeLoader: EpisodeLoaderProtocol, imageLoader: ImageDataLoader) -> ShowDetailViewController {
        let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: Bundle(for: ShowDetailViewController.self))
        let showDetailController = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
        showDetailController.imageLoader = imageLoader
        showDetailController.episodeLoader = episodeLoader
        showDetailController.show = show
        return showDetailController
    }
    
}
