//
//  EpisodeCell.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

final class ShowEpisodeCell: UICollectionViewCell {
    
    static let reuseIdentifier = "ShowEpisodeCell"
    
    // MARK: - Outlets
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet private(set) var imageContainer: UIView!
    @IBOutlet private(set) var number: UILabel!
    @IBOutlet private(set) var name: UILabel!
    
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
