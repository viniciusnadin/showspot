//
//  LoadFeedUseCaseTests+Helpers.swift
//  ShowSpotFeedTests
//
//  Created by Vinicius Nadin on 15/06/23.
//

import XCTest
import ShowSpotFeed

extension LoadFeedUseCaseTests {
    func expect(_ sut: FeedLoader, toCompleteWith expectedResult: FeedLoader.FeedLoadResult, when action: () -> Void, file: StaticString = #filePath, line: UInt = #line) {
        let exp = expectation(description: "Wait for load completion")

        sut.load { receivedResult in
            switch (receivedResult, expectedResult) {
            case let (.success(receivedItems), .success(expectedItems)):
                XCTAssertEqual(receivedItems, expectedItems, file: file, line: line)

            case let (.failure(receivedError), .failure(expectedError)):
                XCTAssertEqual(receivedError, expectedError, file: file, line: line)

            default:
                XCTFail("Expected result \(expectedResult) got \(receivedResult) instead", file: file, line: line)
            }

            exp.fulfill()
        }

        action()

        waitForExpectations(timeout: 0.1)
    }
}
