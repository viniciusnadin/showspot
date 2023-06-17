//
//  ShowCellController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

public protocol FeedShowCellControllerDelegate {
    func didRequestImage()
    func didCancelImageRequest()
}

public final class FeedShowCellController: FeedShowView {
    
    let id: AnyHashable
    private let delegate: FeedShowCellControllerDelegate
    private var cell: ShowCell?
    let selection: () -> Void
    
    public init(_ id: AnyHashable = UUID(), delegate: FeedShowCellControllerDelegate, selection: @escaping () -> Void) {
        self.id = id
        self.delegate = delegate
        self.selection = selection
    }
    
    public func view(collectionView: UICollectionView, indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ShowCell.reuseIdentifier, for: indexPath) as! ShowCell
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
    
    public func display(_ viewModel: FeedShowViewModel<UIImage>) {
        cell?.nameLabel.text = viewModel.name
        cell?.imageView.setImageAnimated(viewModel.image)
        cell?.imageContainer.isShimmering = viewModel.isLoading
        cell?.onRetry = delegate.didRequestImage
    }
}

extension FeedShowCellController: Hashable {
    public func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}
extension FeedShowCellController: Equatable {
    public static func == (lhs: FeedShowCellController, rhs: FeedShowCellController) -> Bool {
        lhs.id == rhs.id
    }
}
