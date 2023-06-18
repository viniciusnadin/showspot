//
//  ShowEpisodeAdapter.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

final class ShowEpisodeAdapter: ShowEpisodeView {
    private weak var controller: ShowDetailViewController?
    private let imageLoader: ImageDataLoader
    private let selection: (FeedShow, UIImage) -> Void
    
    init(controller: ShowDetailViewController, imageLoader: ImageDataLoader, selection: @escaping (FeedShow, UIImage) -> Void = { _,_  in }) {
        self.controller = controller
        self.imageLoader = imageLoader
        self.selection = selection
    }
    
    func display(_ viewModel: ShowEpisodeViewModel) {
        controller?.display(seasons: viewModel.seasons, viewModel.episode.map { model in
            let adapter = ShowEpisodeDataLoaderPresentationAdapter<WeakRefVirtualProxy<ShowEpisodeCellController>, UIImage>(model: model, imageLoader: imageLoader)
            let view = ShowEpisodeCellController(delegate: adapter) { [selection] image in
                selection(FeedShow(id: model.id, name: model.name, image: model.image, schedule: FeedShowSchedule(time: "", days: ["Season \(model.season)", "Episode \(model.number)"]), genres: [], summary: model.summary), image)
            }
            adapter.presenter = ShowEpisodeImagePresenter(view: WeakRefVirtualProxy(view), imageTransformer: UIImage.init)
            
            return view
        })
    }
}
