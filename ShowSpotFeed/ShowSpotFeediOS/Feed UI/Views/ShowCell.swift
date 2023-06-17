//
//  ShowCell.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final class ShowCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShowCell"

    public let imageContainer = UIView()
    public let imageView = UIImageView()
    public let nameLabel = UILabel()

    private(set) public lazy var imageRetryButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(retryButtonTapped), for: .touchUpInside)
        return button
    }()
        
    var onRetry: (() -> Void)?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        imageView.alpha = 0
        imageContainer.startShimmering()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        imageView.alpha = 0
        imageContainer.startShimmering()
    }
    
    func fadeIn(_ image: UIImage?) {
        imageView.image = image
        
        UIView.animate(
            withDuration: 0.25,
            delay: 1.25,
            options: [],
            animations: {
                self.imageView.alpha = 1
            }, completion: { completed in
                if completed {
                    self.imageContainer.stopShimmering()
                }
            })
    }
        
    @objc private func retryButtonTapped() {
        onRetry?()
    }
    
    func configure(with model: FeedShow) {
        nameLabel.text = model.name
    }
}
