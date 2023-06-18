//
//  ShowCell.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final class ShowCell: UICollectionViewCell {
    
    // MARK: - ReuseIdentifier
    static let reuseIdentifier = "ShowCell"
    var onRetry: (() -> Void)?
    
    // MARK: - Outlets
    @IBOutlet private(set) var imageContainer: UIView!
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet private(set) var nameLabel: UILabel!
    
    // MARK: - Life Cycle
    override func awakeFromNib() {
        super.awakeFromNib()
        beginShimmering()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        beginShimmering()
    }
    
    // MARK: - Shimmering Animation
    private func beginShimmering() {
        imageView.alpha = 0
        imageContainer.isShimmering = true
    }
}

extension UIImageView {
    func setImageAnimated(_ newImage: UIImage?) {
        image = newImage
        
        guard newImage != nil else { return }
        
        alpha = 0
        UIView.animate(withDuration: 0.25) {
            self.alpha = 1
        }
    }
}
