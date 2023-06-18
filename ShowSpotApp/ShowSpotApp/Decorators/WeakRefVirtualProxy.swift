//
//  WeakRefVirtualProxy.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

final class WeakRefVirtualProxy<T: AnyObject> {
    private weak var object: T?
    
    init(_ object: T) {
        self.object = object
    }
}

extension WeakRefVirtualProxy: FeedShowView where T: FeedShowView, T.Image == UIImage {
    func display(_ model: FeedShowViewModel<UIImage>) {
        object?.display(model)
    }
}

extension WeakRefVirtualProxy: ShowEpisodeImageView where T: ShowEpisodeImageView, T.Image == UIImage {
    func display(_ model: ShowDetailViewModel<UIImage>) {
        object?.display(model)
    }
}

extension WeakRefVirtualProxy: FeedLoadingView where T: FeedLoadingView {
    func display(_ viewModel: FeedLoadingViewModel) {
        object?.display(viewModel)
    }
}

extension WeakRefVirtualProxy: ShowEpisodeLoadingView where T: ShowEpisodeLoadingView {
    func display(_ viewModel: ShowEpisodeLoadingViewModel) {
        object?.display(viewModel)
    }
}
