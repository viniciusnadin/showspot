//
//  EpisodeCellController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

final class EpisodeCellController {
    
    // MARK: - Attributes
    private var task: FeedImageDataLoaderTask?
    let model: ShowEpisode
    private let imageLoader: FeedImageDataLoader
    
    // MARK: - Initializer
    init(model: ShowEpisode, imageLoader: FeedImageDataLoader) {
        self.model = model
        self.imageLoader = imageLoader
    }
    
    // MARK: - Public Methods
    func view(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: EpisodeCell.reuseIdentifier, for: indexPath) as! EpisodeCell
        
        cell.name.text = model.name
        cell.imageView.image = nil
        
        cell.imageRetryButton.isHidden = true
        cell.imageContainer.startShimmering()
        
        let loadImage = { [weak self, weak cell] in
            guard let self = self else { return }
            
            self.task = self.imageLoader.loadImageData(from: self.model.image) { [weak cell] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                DispatchQueue.main.async {
                    cell?.fadeIn(image)
                    cell?.imageRetryButton.isHidden = (image != nil)
                    cell?.imageContainer.stopShimmering()
                }
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

