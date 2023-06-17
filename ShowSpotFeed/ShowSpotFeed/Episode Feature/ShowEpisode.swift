//
//  ShowEpisode.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public struct ShowEpisode: Hashable {
    public let id: Int
    public let name: String
    public let number: Int
    public let season: Int
    public let summary: String
    public let image: URL
    
    public init(id: Int, name: String, number: Int, season: Int, summary: String, image: URL) {
        self.id = id
        self.name = name
        self.number = number
        self.season = season
        self.summary = summary
        self.image = image
    }
}
