//
//  FeedShowSchedule.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public struct FeedShowSchedule: Equatable {
    public let time: String
    public let days: [String]
    
    public init(time: String, days: [String]) {
        self.time = time
        self.days = days
    }
}
