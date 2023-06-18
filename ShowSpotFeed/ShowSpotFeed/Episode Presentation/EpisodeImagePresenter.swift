//
//  EpisodeImagePresenter.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public protocol ShowEpisodeImageView {
    associatedtype Image

    func display(_ model: ShowDetailViewModel<Image>)
}

public final class ShowEpisodeImagePresenter<View: ShowEpisodeImageView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?

    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }

    public func didStartLoadingImageData(for model: ShowEpisode) {
        view.display(ShowDetailViewModel(name: model.name, number: model.number, season: model.season, summary: model.summary, image: nil, isLoading: true))
    }

    private struct InvalidImageDataError: Error {}

    public func didFinishLoadingImageData(with data: Data, for model: ShowEpisode) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        view.display(ShowDetailViewModel(name: model.name, number: model.number, season: model.season, summary: model.summary, image: image, isLoading: false))
    }

    public func didFinishLoadingImageData(with error: Error, for model: ShowEpisode) {
        view.display(ShowDetailViewModel(name: model.name, number: model.number, season: model.season, summary: model.summary, image: nil, isLoading: false))
    }
}

