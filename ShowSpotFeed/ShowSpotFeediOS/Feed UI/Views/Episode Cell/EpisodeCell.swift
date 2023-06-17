//
//  EpisodeCell.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

final class EpisodeCell: UICollectionViewCell {
    
    static let reuseIdentifier = "EpisodeCell"
    var onRetry: (() -> Void)?
    
    // MARK: - Outlets
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet private(set) var imageContainer: UIView!
    @IBOutlet private(set) var number: UILabel!
    @IBOutlet private(set) var name: UILabel!
    
    private(set) public lazy var imageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        beginShimmering()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beginShimmering()
    }
    
    // MARK: - Actions
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    // MARK: - Shimmering Animation
    private func beginShimmering() {
        imageView.alpha = 0
        imageContainer.isShimmering = true
    }
    
    // MARK: - Fade Animation
    func fadeIn(_ image: UIImage?) {
        imageView.image = image
        
        UIView.animate(
            withDuration: 0.25,
            delay: 0,
            options: [],
            animations: {
                self.imageView.alpha = 1
            }, completion: { completed in
                if completed {
                    self.imageContainer.isShimmering = false
                }
            })
    }
    
}
