//
//  ShowEpisodePresenter.swift
//  ShowSpotFeed
//
//  Created by Vinicius Nadin on 17/06/23.
//

import Foundation
public protocol ShowEpisodeLoadingView {
    func display(_ viewModel: ShowEpisodeLoadingViewModel)
}

public struct ShowEpisodeLoadingViewModel {
    public let isLoading: Bool
}

public struct ShowEpisodeViewModel {
    public let seasons: [Int]
    public let episode: [ShowEpisode]
}

public protocol ShowEpisodeView {
    func display(_ viewModel: ShowEpisodeViewModel)
}

public final class ShowEpisodePresenter {
    private let showEpisodeView: ShowEpisodeView
    private let loadingView: ShowEpisodeLoadingView
    
    public init(showEpisodeView: ShowEpisodeView, loadingView: ShowEpisodeLoadingView) {
        self.showEpisodeView = showEpisodeView
        self.loadingView = loadingView
    }
    
    public func didStartLoadingEpisodes() {
        loadingView.display(ShowEpisodeLoadingViewModel(isLoading: true))
    }
    
    public func didFinishLoadingEpisodes(with episodes: [ShowEpisode]) {
        let seasons = Set(episodes.map { $0.season })
        showEpisodeView.display(ShowEpisodeViewModel(seasons: seasons.sorted(), episode: episodes))
        loadingView.display(ShowEpisodeLoadingViewModel(isLoading: false))
    }
    
    public func didFinishLoadingEpisodes(with error: Error) {
        loadingView.display(ShowEpisodeLoadingViewModel(isLoading: true))
    }
}
