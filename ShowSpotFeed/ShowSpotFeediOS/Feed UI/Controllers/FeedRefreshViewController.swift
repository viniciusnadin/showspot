//
//  FeedRefreshViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final class FeedRefreshViewController: NSObject {
    
    // MARK: - Outlets
    
    private(set) lazy var view: UIRefreshControl = {
        let view = UIRefreshControl()
        view.addTarget(self, action: #selector(refresh), for: .valueChanged)
        return view
    }()
    
    // MARK: - Attributes
    
    private let feedLoader: FeedLoader
    var onRefresh: (([FeedShow]) -> Void)?
    
    // MARK: - Initializer
    
    init(feedLoader: FeedLoader) {
        self.feedLoader = feedLoader
    }
    
    // MARK: - Actions
    @objc func refresh() {
        view.beginRefreshing()
        feedLoader.load { [weak self] result in
            if let feed = try? result.get() {
                self?.onRefresh?(feed)
            }
            DispatchQueue.main.async {
                self?.view.endRefreshing()
            }
        }
    }
}
