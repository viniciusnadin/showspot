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
    
    func test_loadTwice_requestsDataFromURLTwice() {
        let url = URL(string: "https://a-given-url.com")!
        let (sut, client) = makeSUT(url: url)

        sut.load { _ in }
        sut.load { _ in }

        XCTAssertEqual(client.requestedURLs, [url, url])
    }
    
    func test_load_deliversConnectivityErrorOnClientError() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.connectivity), when: {
            let clientError = NSError(domain: "Test", code: 0)
            client.complete(with: clientError)
        })
    }
    
    func test_load_deliversInvalidDataErrorOnNon200HTTPResponse() {
        let (sut, client) = makeSUT()

        let samples = [199, 201, 300, 400, 500]

        samples.enumerated().forEach { index, code in
            expect(sut, toCompleteWith: .failure(.invalidData), when: {
                let json = makeItemsJSON([])
                client.complete(withStatusCode: code, data: json, at: index)
            })
        }
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithInvalidJSON() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let invalidJSON = Data("invalid json".utf8)
            client.complete(withStatusCode: 200, data: invalidJSON)
        })
    }
    
    func test_load_deliversInvalidDataErrorOn200HTTPResponseWithPartiallyValidJSONItems() {
        let (sut, client) = makeSUT()
        
        let validItem = makeItem(id: 0, name: "a name", image: URL(string: "http://a-url.com")!, schedule: FeedShowSchedule(time: "00:00", days: ["a day"]), genres: ["a genre"], summary: "a summary").json

        let invalidItem = ["invalid": "item"]

        let items = [validItem, invalidItem]

        expect(sut, toCompleteWith: .failure(.invalidData), when: {
            let json = makeItemsJSON(items)
            client.complete(withStatusCode: 200, data: json)
        })
    }
    
    func test_load_deliversSuccessWithNoItemsOn200HTTPResponseWithEmptyJSONList() {
        let (sut, client) = makeSUT()

        expect(sut, toCompleteWith: .success([]), when: {
            let emptyListJSON = makeItemsJSON([])
            client.complete(withStatusCode: 200, data: emptyListJSON)
        })
    }
    
    func test_load_deliversSuccessWithItemsOn200HTTPResponseWithJSONItems() {
        let (sut, client) = makeSUT()
        
        let item1 = makeItem(id: 0, name: "a name", image: URL(string: "http://a-url.com")!, schedule: FeedShowSchedule(time: "00:00", days: ["a day"]), genres: ["a genre"], summary: "a summary")
        
        let item2 = makeItem(id: 1, name: "another name", image: URL(string: "http://another-url.com")!, schedule: FeedShowSchedule(time: "00:01", days: ["another day"]), genres: ["another genre"], summary: "another summary")
        
        let items = [item1.model, item2.model]
        
        expect(sut, toCompleteWith: .success(items)) {
            let json = makeItemsJSON([item1.json, item2.json])
            client.complete(withStatusCode: 200, data: json)
        }
    }
    
    func test_load_doesNotDeliverResultAfterSUTInstanceHasBeenDeallocated() {
        let url = URL(string: "http://any-url.com")!
        let client = HTTPClientSpy()
        var sut: FeedLoader? = FeedLoader(url: url, client: client)

        var capturedResults = [FeedLoader.Result]()
        sut?.load { capturedResults.append($0) }

        sut = nil
        client.complete(withStatusCode: 200, data: makeItemsJSON([]))

        XCTAssertTrue(capturedResults.isEmpty)
    }
    
    // MARK: - Helpers

    private func makeSUT(url: URL = URL(string: "https://a-url.com")!, file: StaticString = #filePath, line: UInt = #line) -> (sut: FeedLoader, client: HTTPClientSpy) {
        let client = HTTPClientSpy()
        let sut = FeedLoader(url: url, client: client)
        trackForMemoryLeaks(sut, file: file, line: line)
        trackForMemoryLeaks(client, file: file, line: line)
        return (sut, client)
    }
    
    private func makeItem(id: Int, name: String, image: URL, schedule: FeedShowSchedule, genres: [String], summary: String) -> (model: FeedShow, json: [String: Any]) {
        let item = FeedShow(id: id, name: name, image: image, schedule: schedule, genres: genres, summary: summary)
        
        let json: [String: Any] = [
            "id": id,
            "name": name,
            "image": [ "original": image.absoluteString ],
            "schedule": ["time": schedule.time, "days": schedule.days] as [String : Any],
            "genres": genres,
            "summary": summary
        ]

        return (item, json)
    }

    private func makeItemsJSON(_ items: [[String: Any]]) -> Data {
        return try! JSONSerialization.data(withJSONObject: items)
    }
}
