//
//  FeedImagePresenter.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public protocol FeedShowView {
    associatedtype Image

    func display(_ model: FeedShowViewModel<Image>)
}

public final class FeedImagePresenter<View: FeedShowView, Image> where View.Image == Image {
    private let view: View
    private let imageTransformer: (Data) -> Image?

    public init(view: View, imageTransformer: @escaping (Data) -> Image?) {
        self.view = view
        self.imageTransformer = imageTransformer
    }

    public func didStartLoadingImageData(for model: FeedShow) {
        view.display(FeedShowViewModel(name: model.name, image: nil, isLoading: true))
    }

    private struct InvalidImageDataError: Error {}

    public func didFinishLoadingImageData(with data: Data, for model: FeedShow) {
        guard let image = imageTransformer(data) else {
            return didFinishLoadingImageData(with: InvalidImageDataError(), for: model)
        }
        
        view.display(FeedShowViewModel(name: model.name, image: image, isLoading: false))
    }

    public func didFinishLoadingImageData(with error: Error, for model: FeedShow) {
        view.display(FeedShowViewModel(name: model.name, image: nil, isLoading: false))
    }
}
