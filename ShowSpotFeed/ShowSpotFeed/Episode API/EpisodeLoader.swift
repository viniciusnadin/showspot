//
//  EpisodeLoader.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public class EpisodeLoader {
    public typealias Result = Swift.Result<[ShowEpisode], Error>
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
        self.client.get(from: self.url) { [weak self] result in
            guard self != nil else { return }
            switch result {
            case let .success((data, response)):
                completion(EpisodeItemsMapper.map(data, from: response))
            case .failure:
                completion(.failure(Error.connectivity))
            }
        }
    }
}

