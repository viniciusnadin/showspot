//
//  FeedEndPoint.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/shows")
        }
    }
}
