//
//  FeedLoader.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public protocol FeedLoaderProtocol {
    typealias Result = Swift.Result<[FeedShow], Error>
    typealias Completion = (Result) -> Void
    
    func load(completion: @escaping Completion)
}

public class FeedLoader: FeedLoaderProtocol {
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
    
    public func load(completion: @escaping FeedLoaderProtocol.Completion) {
        self.client.get(from: self.url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(FeedItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}
