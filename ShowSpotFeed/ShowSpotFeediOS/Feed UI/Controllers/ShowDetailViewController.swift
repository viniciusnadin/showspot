//
//  ShowDetailViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

struct ShowEpisode: Hashable {
    let id: Int
    let name: String
    let number: Int
    let season: Int
    let summary: String
    let image: URL
}

class ShowDetailViewController: UIViewController, UICollectionViewDelegate {

    // MARK: - Outlets
    @IBOutlet private(set) var name: UILabel!
    @IBOutlet private(set) var image: UIImageView!
    @IBOutlet private(set) var genres: UILabel!
    @IBOutlet private(set) var time: UILabel!
    @IBOutlet private(set) var days: UILabel!
    @IBOutlet private(set) var summary: UILabel!
    @IBOutlet private(set) var scrollView: UIScrollView!
    @IBOutlet private(set) var seasonsCollectionView: UICollectionView!
    @IBOutlet private(set) var episodesCollectionView: UICollectionView!

    // MARK: - Attributes
    var showViewModel: FeedShow?
    var seasons = [Season]()
    var show: Bool = true

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

    private func updateViews() {
//        image.image = UIImage(named: showViewModel!.image)
        name.text = showViewModel!.name
        genres.text = showViewModel?.genres.joined(separator: " ・ ")
        time.text = showViewModel?.schedule.time
        days.text = showViewModel?.schedule.days.reduce("") { $0 + " " + $1}
        summary.text = showViewModel!.summary.removingHTMLTags()
        
        if !show {
            self.episodesCollectionView.isHidden = true
            self.seasonsCollectionView.isHidden = true
            self.view.backgroundColor = .black
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        updateViews()
        
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
        
        scrollView.contentInsetAdjustmentBehavior = .never
        
        episodesCollectionView.delegate = self
        seasonsCollectionView.delegate = self
        
        seasonsCollectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.reuseIdentifier)

        let nib = UINib(nibName: "EpisodeCell", bundle: nil)
        episodesCollectionView.register(nib, forCellWithReuseIdentifier: "EpisodeCell")

        seasonDataSource = UICollectionViewDiffableDataSource(collectionView: seasonsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.reuseIdentifier, for: indexPath) as! SeasonCell
            cell.configure(season: itemIdentifier.number)
            return cell
        })

        episodeDataSource = UICollectionViewDiffableDataSource(collectionView: episodesCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let episode = itemIdentifier
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EpisodeCell", for: indexPath) as! EpisodeCell
            cell.configure(with: episode)
            return cell
        })
        
        updateSeasonsDataSource()
//        updateEpisodeDataSource(for: seasons.first!)
    }
    
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
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == seasonsCollectionView {
            let season = seasons[indexPath.row]
            updateEpisodeDataSource(for: season)
        } else if collectionView == episodesCollectionView {
            let storyboard = UIStoryboard(name: "ShowDetailViewController", bundle: nil)
            let vc = storyboard.instantiateViewController(withIdentifier: "ShowDetailViewController") as! ShowDetailViewController
            let episode = episodeDataSource.snapshot(for: .episodes).items[indexPath.row]
            
            vc.showViewModel = FeedShow(id: episode.id, name: episode.name, image: episode.image, schedule: FeedShowSchedule(time: "", days: []), genres: [], summary: episode.summary)
            vc.show = false
            
            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
}

extension String {
    func removingHTMLTags() -> String {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression, range: nil)
    }
}

@IBDesignable class GradientView: UIView {
    @IBInspectable var topColor: UIColor = UIColor.clear
    @IBInspectable var bottomColor: UIColor = UIColor.black

    override class var layerClass: AnyClass {
        return CAGradientLayer.self
    }

    override func layoutSubviews() {
        (layer as! CAGradientLayer).colors = [topColor.cgColor, bottomColor.cgColor]
        (layer as! CAGradientLayer).locations = [0.0, 0.8]
    }
}
