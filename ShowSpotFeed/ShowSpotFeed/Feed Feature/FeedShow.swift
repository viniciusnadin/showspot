//
//  FeedShow.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public struct FeedShow: Hashable {
    public let id: Int
    public let name: String
    public let image: URL
    public let schedule: FeedShowSchedule
    public let genres: [String]
    public let summary: String
    
    public init(id: Int, name: String, image: URL, schedule: FeedShowSchedule, genres: [String], summary: String) {
        self.id = id
        self.name = name
        self.image = image
        self.schedule = schedule
        self.genres = genres
        self.summary = summary
    }
}
