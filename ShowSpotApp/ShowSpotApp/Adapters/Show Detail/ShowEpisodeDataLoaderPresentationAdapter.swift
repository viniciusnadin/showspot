//
//  ShowEpisodeDataLoaderPresentationAdapter.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

final class ShowEpisodeDataLoaderPresentationAdapter<View: ShowEpisodeImageView, Image>: ShowEpisodeCellControllerDelegate where View.Image == Image {
    
    private let model: ShowEpisode
    private let imageLoader: ImageDataLoader
    private var task: ImageDataLoaderTask?
    
    var presenter: ShowEpisodeImagePresenter<View, Image>?
    
    init(model: ShowEpisode, imageLoader: ImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func didRequestImage() {
        presenter?.didStartLoadingImageData(for: model)
        
        let model = self.model
        task = imageLoader.loadImageData(from: model.image) { [weak self] result in
            switch result {
            case let .success(data):
                self?.presenter?.didFinishLoadingImageData(with: data, for: model)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingImageData(with: error, for: model)
            }
        }
    }
    
    func didCancelImageRequest() {
        task?.cancel()
    }
}

