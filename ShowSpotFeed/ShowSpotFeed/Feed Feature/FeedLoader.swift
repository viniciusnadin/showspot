//
//  FeedLoader.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public final class FeedLoader {
    public typealias Result = Swift.Result<[FeedItem], Error>
    public typealias Completion = (Result) -> Void
    
    public enum Error: Swift.Error {
        case connectivity
        case invalidData
    }
    
    private let url: URL
    private let client: HTTPClient
    
    public init(url: URL, client: HTTPClient) {
        self.url = url
        self.client = client
    }
    
    public func load(completion: @escaping Completion) {
        self.client.get(from: self.url) { result in
            switch result {
            case let .success((data, response)):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

enum FeedItemsMapper {
    private static var OK_200: Int { return 200 }
    
    static func map(_ data: Data, from response: HTTPURLResponse) -> FeedLoader.Result {
        guard response.statusCode == OK_200 else {
            return .failure(FeedLoader.Error.invalidData)
        }
        return .success([])
    }
}
