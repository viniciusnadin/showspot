//
//  EpisodeCell.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit

final class EpisodeCell: UICollectionViewCell {
    
    // MARK: - Outlets
    @IBOutlet private(set) var image: UIImageView!
    @IBOutlet private(set) var number: UILabel!
    @IBOutlet private(set) var name: UILabel!
    
    // MARK: - Configure Cell
    func configure(with viewModel: ShowEpisode) {
//        self.image.image = viewModel.image
        self.number.text = "Episode \(viewModel.number)"
        self.name.text = viewModel.name
    }
}
