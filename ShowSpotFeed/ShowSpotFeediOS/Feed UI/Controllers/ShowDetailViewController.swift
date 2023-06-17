//
//  ShowDetailViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

class ShowDetailViewController: UIViewController, UICollectionViewDelegate {

    // MARK: - Outlets
    @IBOutlet private(set) var mainScrollView: UIScrollView!
    @IBOutlet private(set) var imageView: UIImageView!
    @IBOutlet private(set) var nameLabel: UILabel!
    @IBOutlet private(set) var genresLabel: UILabel!
    @IBOutlet private(set) var scheduleDaysLabel: UILabel!
    @IBOutlet private(set) var scheduleTimeLabel: UILabel!
    @IBOutlet private(set) var summaryLabel: UILabel!
    
    @IBOutlet private(set) var seasonsCollectionView: UICollectionView!
    @IBOutlet private(set) var episodesCollectionView: UICollectionView!

    // MARK: - Attributes
    var show: FeedShow?
    
    private var task: FeedImageDataLoaderTask?
    var imageLoader: FeedImageDataLoader?
    var episodeLoader: EpisodeLoader?
    
    var isShowDetailView: Bool = true
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImage()
        setLabelsValues()
        configureNavigationBar()
        
        if !isShowDetailView {
            self.episodesCollectionView.isHidden = true
            self.seasonsCollectionView.isHidden = true
            self.view.backgroundColor = .black
        } else {
            
            let url = URL(string: "https://api.tvmaze.com/shows/\(show!.id)/episodes")!
            let session = URLSession(configuration: .ephemeral)
            let client = URLSessionHTTPClient(session: session)
            episodeLoader = EpisodeLoader(url: url, client: client)
            
            episodeLoader?.load(completion: { result in
                switch result {
                case .success(let episodes):
                    let group = Dictionary(grouping: episodes, by: { $0.season })
                    self.seasons = group.map { Season(number: $0.key, episodes: $0.value) }.sorted(by: { $0.number < $1.number})
                    self.updateSeasonsDataSource()
                    self.updateEpisodeDataSource(for: self.seasons.first!)
                case .failure:
                    break
                }
            })
            
            setSeasonsDataSource()
            setEpisodesDataSource()
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        seasonsCollectionView.delegate = self
        episodesCollectionView.delegate = self
        
        seasonsCollectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.reuseIdentifier)

        let nib = UINib(nibName: "EpisodeCell", bundle: Bundle(for: EpisodeCell.self))
        episodesCollectionView.register(nib, forCellWithReuseIdentifier: "EpisodeCell")
    }
    
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setLabelsValues() {
        nameLabel.text = show?.name
        genresLabel.text = show?.genres.joined(separator: " ・ ")
        scheduleTimeLabel.text = show?.schedule.time
        scheduleDaysLabel.text = show?.schedule.days.reduce("") { $0 + " " + $1}
        summaryLabel.text = show!.summary.removingHTMLTags()
    }
    
    private func loadImage() {
        let loadImage = { [weak self, weak imageView] in
            guard let self = self else { return }
            
            self.task = self.imageLoader?.loadImageData(from: self.show!.image) { [weak imageView] result in
                let data = try? result.get()
                let image = data.map(UIImage.init) ?? nil
                DispatchQueue.main.async {
                    imageView?.image = image
                }
            }
        }
        
        loadImage()
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsCollectionView {
            let season = seasons[indexPath.row]
            updateEpisodeDataSource(for: season)
        } else if collectionView == episodesCollectionView {
            let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: Bundle(for: ShowDetailViewController.self))
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            let episode = episodeDataSource.snapshot(for: .episodes).items[indexPath.row]
            
            vc.imageLoader = imageLoader
            vc.show = FeedShow(id: episode.id, name: episode.name, image: episode.image, schedule: FeedShowSchedule(time: "", days: ["Season \(episode.season)", "Episode \(episode.number)"]), genres: [], summary: episode.summary)
            vc.isShowDetailView = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    // MARK: - Episodes Feature
    var seasons = [Season]()
    
    
    enum Section {
        case seasons
        case episodes
    }
    
    struct Season: Hashable {
        let number: Int
        let episodes: [ShowEpisode]
    }

    var seasonDataSource: UICollectionViewDiffableDataSource<Section, Season>!
    var episodeDataSource: UICollectionViewDiffableDataSource<Section, ShowEpisode>!
    
    func updateSeasonsDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Section, Season>()
        snapshot.appendSections([.seasons])
        snapshot.appendItems(seasons)
        seasonDataSource.apply(snapshot, animatingDifferences: true)
    }

    func updateEpisodeDataSource(for season: Season) {
        var snapshot = NSDiffableDataSourceSnapshot<Section, ShowEpisode>()
        snapshot.appendSections([.episodes])
        snapshot.appendItems(season.episodes)
        episodeDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setSeasonsDataSource() {
        seasonDataSource = UICollectionViewDiffableDataSource(collectionView: seasonsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.reuseIdentifier, for: indexPath) as! SeasonCell
            cell.configure(season: itemIdentifier.number)
            return cell
        })
    }
    
    private func setEpisodesDataSource() {
        episodeDataSource = UICollectionViewDiffableDataSource(collectionView: episodesCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            EpisodeCellController(model: itemIdentifier, imageLoader: self.imageLoader!).view(collectionView: collectionView, indexPath: indexPath)
        })
    }
}
