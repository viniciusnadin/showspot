//
//  HTTPClient.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 15/06/23.
//

import Foundation

public protocol HTTPClient {
    typealias Result = Swift.Result<(Data, HTTPURLResponse), Error>

    func get(from url: URL, completion: @escaping (Result) -> Void)
}

