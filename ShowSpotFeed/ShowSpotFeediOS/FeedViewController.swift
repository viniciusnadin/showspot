//
//  FeedViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed

final public class FeedViewController: UIViewController {
    
    // MARK: - Outlets
    private lazy var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(load), for: .valueChanged)
        return refreshControl
    }()
    
    private var loader: FeedLoader?
    
    public convenience init(loader: FeedLoader) {
        self.init()
        self.loader = loader
    }
    
    public override func viewDidLoad() {
        super.viewDidLoad()
        load()
    }
    
    @objc private func load() {
        refreshControl.beginRefreshing()
        loader?.load { [weak self] _ in
            self?.refreshControl.endRefreshing()
        }
    }
}
