//
//  FeedViewAdapter.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

final class FeedViewAdapter: FeedView {
    private weak var controller: FeedViewController?
    private let imageLoader: ImageDataLoader
    private let selection: (FeedShow, UIImage) -> Void
    
    init(controller: FeedViewController, imageLoader: ImageDataLoader, selection: @escaping (FeedShow, UIImage) -> Void = { _,_  in }) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: FeedViewModel) {
        controller?.display(viewModel.feed.map { model in
            let adapter = FeedShowDataLoaderPresentationAdapter<WeakRefVirtualProxy<FeedShowCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = FeedShowCellController(delegate: adapter) { [selection] image in
                selection(model, image)
            }
            
            adapter.presenter = FeedImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        })
    }
}
