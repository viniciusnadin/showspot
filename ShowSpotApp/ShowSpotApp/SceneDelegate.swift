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
    private lazy var baseURL = URL(string: "https://api.tvmaze.com")!
    private var navigationController: UINavigationController!
    

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
        
        let feedViewController = FeedUIComposer.feedComposedWith(
            feedLoader: makeFeedLoader(url: FeedEndpoint.get.url(baseURL: baseURL)),
            imageLoader: makeImageLoader(),
            selection: presentShowDetail
        )
        
        self.navigationController = UINavigationController(rootViewController: feedViewController)
        
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = [navigationController!]
        navigationController.tabBarItem.image = UIImage(systemName: "house")
        
        window?.rootViewController = tabBarController
    }
    
    private func presentShowDetail(for show: FeedShow) {
        let url = ShowDetailEndpoint.get(show.id).url(baseURL: baseURL)
        let details = ShowDetailUIComposer.showDetailComposedWith(show: show, episodeLoader: makeEpisodeLoader(url: url), imageLoader: makeImageLoader())
        navigationController.pushViewController(details, animated: true)
    }
    
    private func makeEpisodeLoader(url: URL) -> EpisodeLoaderProtocol {
        return EpisodeLoader(url: url, client: makeClient())
    }
    
    private func makeImageLoader() -> ImageDataLoader {
        return FeedImageDataLoader(client: makeClient())
    }
    
    private func makeFeedLoader(url: URL) -> FeedLoaderProtocol {
        FeedLoader(url: url, client: makeClient())
    }
    
    private func makeClient() -> HTTPClient {
        let configuration = URLSessionConfiguration.default
        configuration.requestCachePolicy = .returnCacheDataElseLoad
        let session = URLSession(configuration: configuration)
        return URLSessionHTTPClient(session: session)
    }
}

public enum FeedEndpoint {
    case get
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case .get:
            return baseURL.appendingPathComponent("/shows")
        }
    }
}

public enum ShowDetailEndpoint {
    case get(Int)
    
    public func url(baseURL: URL) -> URL {
        switch self {
        case let .get(id):
            return baseURL.appendingPathComponent("/shows/\(id)/episodes")
        }
    }
}
