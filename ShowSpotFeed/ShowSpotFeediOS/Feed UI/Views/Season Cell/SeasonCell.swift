//
//  SeasonCell.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit

final class SeasonCell: UICollectionViewCell {
    
    static let reuseIdentifier = "SeasonCell"
    
    // MARK: - Outlets
    private lazy var number: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 14)
        label.textColor = .systemBlue
        return label
    }()
    
    // MARK: - Overrides
    override init(frame: CGRect) {
        super.init(frame: frame)
        setNumberLabelConstraints()
    }
    
    required init?(coder: NSCoder) {
        fatalError("")
    }
    
    // MARK: - ConfigureCell
    func configure(season: String) {
        number.text = season
    }
    
    // MARK: - NumberLabelConstraints
    private func setNumberLabelConstraints() {
        addSubview(number)
        NSLayoutConstraint.activate([
            number.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            number.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 10),
            number.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            number.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -10),
        ])
    }
}

