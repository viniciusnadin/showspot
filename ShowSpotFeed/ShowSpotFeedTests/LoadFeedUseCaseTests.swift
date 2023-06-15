//
//  LoadFeedUseCaseTests.swift
//  ShowSpotFeedTests
//
//  Created by Vinicius Nadin on 15/06/23.
//

import XCTest
import ShowSpotFeed

class LoadFeedUseCaseTests: XCTestCase {
    
    func test_init_doesNotRequestDataFromURL() {
        let (_, client) = makeSUT()
        XCTAssertTrue(client.requestedURLs.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = FeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
}
