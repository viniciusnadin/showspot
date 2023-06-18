//
//  EpisodeLoaderPresentationAdapter.swift
//  ShowSpotApp
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed
import ShowSpotFeediOS

final class EpisodeLoaderPresentationAdapter: ShowDetailViewControllerDelegate {
    
    private let episodeLoader: EpisodeLoaderProtocol
    var presenter: ShowEpisodePresenter?
    
    init(episodeLoader: EpisodeLoaderProtocol) {
        self.episodeLoader = episodeLoader
    }
    
    func didRequestEpisodeLoad() {
        presenter?.didStartLoadingEpisodes()
        
        episodeLoader.load { [weak self] result in
            switch result {
            case let .success(episodes):
                self?.presenter?.didFinishLoadingEpisodes(with: episodes)
                
            case let .failure(error):
                self?.presenter?.didFinishLoadingEpisodes(with: error)
            }
        }
    }
}
