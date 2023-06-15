//
//  HTTPClientSpy.swift
//  ShowSpotFeedTests
//
//  Created by Vinicius Nadin on 15/06/23.
//

import XCTest
import ShowSpotFeed

class HTTPClientSpy: HTTPClient {
    
    var requestedURLs: [URL] = []
    
    func get(from url: URL, completion: @escaping (HTTPClient.Result) -> Void) {
        requestedURLs.append(url)
    }
}
