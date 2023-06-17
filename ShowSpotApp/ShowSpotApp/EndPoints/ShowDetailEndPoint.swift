//
//  ShowDetailEndPoint.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation

public enum ShowDetailEndpoint {
    case get(Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/shows/\(id)/episodes")
        }
    }
}
