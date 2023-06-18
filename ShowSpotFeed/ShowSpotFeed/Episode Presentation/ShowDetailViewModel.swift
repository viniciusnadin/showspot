//
//  ShowDetailViewModel.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public struct ShowDetailViewModel<Image> {
    public let name: String
    public let number: Int
    public let season: Int
    public let summary: String
    public let image: Image?
    public let isLoading: Bool
}

