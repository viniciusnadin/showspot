//
//  FeedLoader.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public final class FeedLoader {
    public typealias FeedLoadResult = Result<[FeedItem], Error>
    public typealias FeedLoadCompletion = (FeedLoadResult) -> Void
    
    public enum Error: Swift.Error {
        case connectivity
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping FeedLoadCompletion) {
        self.client.get(from: self.url) { result in
            completion(.failure(.connectivity))
        }
    }
}
