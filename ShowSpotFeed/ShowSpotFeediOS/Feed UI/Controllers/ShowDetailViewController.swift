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
    
    var isShowDetailView: Bool = true {
        didSet {
            if !isShowDetailView {
                self.episodesCollectionView.isHidden = true
                self.seasonsCollectionView.isHidden = true
                self.view.backgroundColor = .black
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadImage()
        setLabelsValues()
        configureNavigationBar()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        episodesCollectionView.delegate = self
        seasonsCollectionView.delegate = self
        
        seasonsCollectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.reuseIdentifier)

        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        episodesCollectionView.register(nib, forCellWithReuseIdentifier: "EpisodeCell")
        
//        setSeasonsDataSource()
//        setEpisodesDataSource()
        
//        updateSeasonsDataSource()
//        updateEpisodeDataSource(for: seasons.first!)
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
            let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            let episode = episodeDataSource.snapshot(for: .episodes).items[indexPath.row]
            
            vc.show = FeedShow(id: episode.id, name: episode.name, image: episode.image, schedule: FeedShowSchedule(time: "", days: []), genres: [], summary: episode.summary)
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
            let episode = itemIdentifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
            cell.configure(with: episode)
            return cell
        })
    }
}
