//
//  ShowCellController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final class FeedShowCellController {
    private var task: FeedImageDataLoaderTask?
    let model: FeedShow
    private let imageLoader: FeedImageDataLoader
    
    init(model: FeedShow, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    func view() -> UICollectionViewCell {
        let cell = ShowCell()
        cell.configure(with: model)
        cell.imageView.image = nil
        cell.imageRetryButton.isHidden = true
        cell.imageContainer.startShimmering()
        cell.imageRetryButton.isHidden = true
        cell.imageContainer.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.task = self.imageLoader.loadImageData(from: self.model.image) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                cell?.imageView.image = image
                cell?.imageRetryButton.isHidden = (image != nil)
                cell?.imageContainer.stopShimmering()
            }
        }
        
        cell.onRetry = loadImage
        loadImage()
        
        return cell
    }
    
    func preload() {
        task = imageLoader.loadImageData(from: model.image) { _ in }
    }
    
    func cancelLoad() {
        task?.cancel()
    }
}
