//
//  ShowSpotFeedAPIEndToEndTests.swift
//  ShowSpotFeedAPIEndToEndTests
//
//  Created by Vinicius Nadin on 15/06/23.
//

import XCTest
import ShowSpotFeed

class ShowSpotFeedAPIEndToEndTests: XCTestCase {
    
    func test_endToEndTestServerGETFeedResult_matchesFixedShows() {
        switch getFeedResult() {
        case let .success(items)?:
            XCTAssertEqual(items[0], expectedShow(at: 0))
            XCTAssertEqual(items[1], expectedShow(at: 1))
            XCTAssertEqual(items[2], expectedShow(at: 2))
            XCTAssertEqual(items[3], expectedShow(at: 3))
            
        case let .failure(error)?:
            XCTFail("Expected successful feed result, got \(error) instead")
            
        default:
            XCTFail("Expected successful feed result, got no result instead")
        }
    }
    
    // MARK: - Helpers
    
    private func getFeedResult(file: StaticString = #file, line: UInt = #line) -> FeedLoader.Result? {
        let testServerURL = URL(string: "https://api.tvmaze.com/shows")!
        let client = URLSessionHTTPClient()
        let loader = FeedLoader(url: testServerURL, client: client)
        trackForMemoryLeaks(client, file: file, line: line)
        trackForMemoryLeaks(loader, file: file, line: line)
        
        let exp = expectation(description: "Wait for load completion")
        
        var receivedResult: FeedLoader.Result?
        loader.load { result in
            receivedResult = result
            exp.fulfill()
        }
        wait(for: [exp], timeout: 10.0)
        
        return receivedResult
    }
    
    private func expectedShow(at index: Int) -> FeedShow {
        FeedShow(
            id: id(at: index),
            name: name(at: index),
            image: image(at: index),
            schedule: schedule(at: index),
            genres: genres(at: index),
            summary: summary(at: index))
    }
    
    private func id(at index: Int) -> Int {
        [
            1,
            2,
            3,
            4
        ][index]
    }
    
    private func name(at index: Int) -> String {
        [
            "Under the Dome",
            "Person of Interest",
            "Bitten",
            "Arrow"
        ][index]
    }
    
    private func image(at index: Int) -> URL {
        [
            URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/81/202627.jpg")!,
            URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/163/407679.jpg")!,
            URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/0/15.jpg")!,
            URL(string: "https://static.tvmaze.com/uploads/images/original_untouched/143/358967.jpg")!
        ][index]
    }
    
    private func schedule(at index: Int) -> FeedShowSchedule {
        [
            FeedShowSchedule(time: "22:00", days: ["Thursday"]),
            FeedShowSchedule(time: "22:00", days: ["Tuesday"]),
            FeedShowSchedule(time: "22:00", days: ["Friday"]),
            FeedShowSchedule(time: "21:00", days: ["Tuesday"])
        ][index]
    }
    
    private func genres(at index: Int) -> [String] {
        [
            ["Drama", "Science-Fiction", "Thriller"],
            ["Action", "Crime", "Science-Fiction"],
            ["Drama", "Horror", "Romance"],
            ["Drama", "Action", "Science-Fiction"]
        ][index]
    }
    
    private func summary(at index: Int) -> String {
        [
            "<p><b>Under the Dome</b> is the story of a small town that is suddenly and inexplicably sealed off from the rest of the world by an enormous transparent dome. The town's inhabitants must deal with surviving the post-apocalyptic conditions while searching for answers about the dome, where it came from and if and when it will go away.</p>",
            
            "<p>You are being watched. The government has a secret system, a machine that spies on you every hour of every day. I know because I built it. I designed the Machine to detect acts of terror but it sees everything. Violent crimes involving ordinary people. People like you. Crimes the government considered \"irrelevant\". They wouldn't act so I decided I would. But I needed a partner. Someone with the skills to intervene. Hunted by the authorities, we work in secret. You'll never find us. But victim or perpetrator, if your number is up, we'll find you.</p>",
            
            "<p>Based on the critically acclaimed series of novels from Kelley Armstrong. Set in Toronto and upper New York State, <b>Bitten</b> follows the adventures of 28-year-old Elena Michaels, the world's only female werewolf. An orphan, Elena thought she finally found her \"happily ever after\" with her new love Clayton, until her life changed forever. With one small bite, the normal life she craved was taken away and she was left to survive life with the Pack.</p>",
            
            "<p>After a violent shipwreck, billionaire playboy Oliver Queen was missing and presumed dead for five years before being discovered alive on a remote island in the Pacific. He returned home to Starling City, welcomed by his devoted mother Moira, beloved sister Thea and former flame Laurel Lance. With the aid of his trusted chauffeur/bodyguard John Diggle, the computer-hacking skills of Felicity Smoak and the occasional, reluctant assistance of former police detective, now beat cop, Quentin Lance, Oliver has been waging a one-man war on crime.</p>"
        ][index]
    }
}
