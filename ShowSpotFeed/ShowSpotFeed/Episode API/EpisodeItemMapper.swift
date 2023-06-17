//
//  EpisodeItemMapper.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public final class EpisodeItemsMapper {
    
    private struct EpisodeItem: Decodable {
        private let id: Int
        private let name: String
        private let number: Int
        private let season: Int
        private let summary: String
        private let image: ImageObject
        
        var episode: ShowEpisode {
            ShowEpisode(id: id, name: name, number: number, season: season, summary: summary, image: image.original)
        }
        
        private struct ImageObject: Decodable {
            let original: URL
        }
    }
    
    private static var OK_200: Int { return 200 }
    
    public static func map(_ data: Data, from response: HTTPURLResponse) -> EpisodeLoader.Result {
        guard response.statusCode == OK_200, let items = try? JSONDecoder().decode([EpisodeItem].self, from: data) else {
            return .failure(EpisodeLoader.Error.invalidData)
        }
        
        return .success(items.map(\.episode))
    }
}

