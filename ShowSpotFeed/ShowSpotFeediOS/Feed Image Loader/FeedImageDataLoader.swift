//
//  FeedImageDataLoader.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import Foundation
import ShowSpotFeed

public protocol FeedImageDataLoaderTask {
    func cancel()
}

public protocol FeedImageDataLoader {
    typealias Result = Swift.Result<Data, Error>
    
    func loadImageData(from url: URL, completion: @escaping (Result) -> Void) -> FeedImageDataLoaderTask
}
