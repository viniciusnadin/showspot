//
//  ShowEpisodeCellController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

public protocol ShowEpisodeCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class ShowEpisodeCellController: ShowEpisodeImageView {
    
    // MARK: - Attributes
    let id: AnyHashable
    private var cell: ShowEpisodeCell?
    private let delegate: ShowEpisodeCellControllerDelegate
    let selection: (UIImage) -> Void
    
    // MARK: - Initializer
    public init(_ id: AnyHashable = UUID(), delegate: ShowEpisodeCellControllerDelegate, selection: @escaping (UIImage) -> Void) {
        self.id = id
        self.delegate = delegate
        self.selection = selection
    }
    
    // MARK: - Public Methods
    func view(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowEpisodeCell.reuseIdentifier, for: indexPath) as! ShowEpisodeCell
        self.cell = cell
        delegate.didRequestImage()
        return cell
    }
    
    func preload() {
        delegate.didRequestImage()
    }
    
    func cancelLoad() {
        cell = nil
        delegate.didCancelImageRequest()
    }
    
    public func display(_ model: ShowDetailViewModel<UIImage>) {
        cell?.name.text = model.name
        cell?.number.text = "Season \(model.season) ・ Episode \(model.number)"
        cell?.imageView.setImageAnimated(model.image)
        cell?.imageContainer.isShimmering = model.isLoading
    }
}

// MARK: - Hashable And Equatable Extensions
extension ShowEpisodeCellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension ShowEpisodeCellController: Equatable {
    public static func == (lhs: ShowEpisodeCellController, rhs: ShowEpisodeCellController) -> Bool {
        lhs.id == rhs.id
    }
}
