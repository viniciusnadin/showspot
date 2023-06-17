//
//  FeedItemsMapper.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public final class FeedItemsMapper {
    private struct FeedItem: Decodable {
        private let id: Int
        private let name: String
        private let image: ImageObject
        private let schedule: ScheduleObject
        private let genres: [String]
        private let summary: String
        
        var show: FeedShow {
            FeedShow(id: id, name: name, image: image.original, schedule: FeedShowSchedule(time: schedule.time, days: schedule.days), genres: genres, summary: summary)
        }
        
        private struct ImageObject: Decodable {
            let original: URL
        }
        
        private struct ScheduleObject: Decodable {
            let time: String
            let days: [String]
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
        guard response.statusCode == OK_200, let items = try? JSONDecoder().decode([FeedItem].self, from: data) else {
            return .failure(FeedLoader.Error.invalidData)
        }
        
        return .success(items.map(\.show))
    }
}
