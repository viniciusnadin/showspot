//
//  FeedLoader.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

protocol FeedLoader {
    typealias FeedLoadResult = Result<[FeedItem], Error>
    typealias FeedLoadCompletion = (FeedLoadResult) -> Void
    
    func load(completion: @escaping FeedLoadCompletion)
}
