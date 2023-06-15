//
//  FeedItem.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public struct FeedItem: Equatable {
    let id: UUID
    let name: String
    let image: URL
    let schedule: [String]
    let genres: [String]
    let summary: String
}
