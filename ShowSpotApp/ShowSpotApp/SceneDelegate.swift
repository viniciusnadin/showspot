//
//  SceneDelegate.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 16/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let url = URL(string: "https://api.tvmaze.com/shows")!
        let session = URLSession(configuration: .ephemeral)
        let client = URLSessionHTTPClient(session: session)
        let feedLoader = FeedLoader(url: url, client: client)
        let feedImageLoader = FeedImageDataLoader(client: client)
        
        let feedViewController = FeedUIComposer.feedComposedWith(feedLoader: feedLoader, imageLoader: feedImageLoader)
        let navigationController = UINavigationController(rootViewController: feedViewController)
        
        window?.rootViewController = navigationController
    }
}
