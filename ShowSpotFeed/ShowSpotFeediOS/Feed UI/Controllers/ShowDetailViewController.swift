//
//  ShowDetailViewController.swift
//  ShowSpotFeediOS
//
//  Created by Vinicius Nadin on 17/06/23.
//

import UIKit
import ShowSpotFeed

public protocol ShowDetailViewControllerDelegate {
    func didRequestEpisodeLoad()
}

public class ShowDetailViewController: UIViewController, UICollectionViewDelegate {
    
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
    public var show: FeedShow?
    public var showImage: UIImage?
    public var delegate: ShowDetailViewControllerDelegate?
    private var loadingControllers = [IndexPath: ShowEpisodeCellController]()
    private var model = [ShowEpisodeCellController]() { didSet { updateDataSource() }}
    private var seasons = [Int]()
    public var isEpisodeView = false
    
    private var seasonDataSource: UICollectionViewDiffableDataSource<Int, String>!
    private var episodeDataSource: UICollectionViewDiffableDataSource<Int, ShowEpisodeCellController>!
    
    // MARK: - Life Cycle
    public override func viewDidLoad() {
        super.viewDidLoad()
        if isEpisodeView {
            episodesCollectionView.isHidden = true
            episodesCollectionView.isHidden = true
            self.view.backgroundColor = .black
        }
        
        mainScrollView.contentInsetAdjustmentBehavior = .never
        
        seasonsCollectionView.delegate = self
        episodesCollectionView.delegate = self
        
        seasonsCollectionView.register(SeasonCell.self, forCellWithReuseIdentifier: SeasonCell.reuseIdentifier)
        let nib = UINib(nibName: ShowEpisodeCell.reuseIdentifier, bundle: Bundle(for: ShowEpisodeCell.self))
        episodesCollectionView.register(nib, forCellWithReuseIdentifier: ShowEpisodeCell.reuseIdentifier)
        
        seasonsCollectionView.isHidden = true
        setSeasonsDataSource()
        setEpisodesDataSource()
        delegate?.didRequestEpisodeLoad()
        setLabelsValues()
    }
    
    public override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.navigationBar.tintColor = .systemBlue
    }
    
    public override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureNavigationBar()
    }
    
    // MARK: - Private Methods
    private func configureNavigationBar() {
        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isTranslucent = true
    }
    
    private func setLabelsValues() {
        nameLabel.text = show?.name
        imageView.setImageAnimated(self.showImage)
        genresLabel.text = show?.genres.joined(separator: " ・ ")
        scheduleTimeLabel.text = show?.schedule.time
        scheduleDaysLabel.text = show?.schedule.days.reduce("") { $0 + " " + $1}
        summaryLabel.text = show!.summary.removingHTMLTags()
    }
    
    // MARK: - Public Methods
    public func display(seasons: [Int], _ cellControllers: [ShowEpisodeCellController]) {
        loadingControllers = [:]
        self.seasons = seasons
        model = cellControllers
    }
    
    private func updateDataSource() {
        self.updateSeasonsDataSource()
        self.updateEpisodeDataSource()
    }
    
    // MARK: - Episodes Feature
    func updateSeasonsDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, String>()
        snapshot.appendSections([0])
        snapshot.appendItems(seasons.map { "Season \($0)"}, toSection: 0)
        seasonDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    func updateEpisodeDataSource() {
        var snapshot = NSDiffableDataSourceSnapshot<Int, ShowEpisodeCellController>()
        snapshot.appendSections([0])
        snapshot.appendItems(model, toSection: 0)
        episodeDataSource.apply(snapshot, animatingDifferences: true)
    }
    
    private func setSeasonsDataSource() {
        seasonDataSource = UICollectionViewDiffableDataSource(collectionView: seasonsCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SeasonCell.reuseIdentifier, for: indexPath) as! SeasonCell
            cell.configure(season: itemIdentifier)
            return cell
        })
    }
    
    private func setEpisodesDataSource() {
        episodeDataSource = UICollectionViewDiffableDataSource(collectionView: episodesCollectionView, cellProvider: { collectionView, indexPath, itemIdentifier in
            self.cellController(forRowAt: indexPath).view(collectionView: collectionView, indexPath: indexPath)
        })
    }
    
    private func cellController(forRowAt indexPath: IndexPath) -> ShowEpisodeCellController {
        let controller = model[indexPath.row]
        loadingControllers[indexPath] = controller
        return controller
    }
    
    private func cancelCellControllerLoad(forRowAt indexPath: IndexPath) {
        loadingControllers[indexPath]?.cancelLoad()
        loadingControllers[indexPath] = nil
    }
}

// MARK: - CollectionViewDelegate
extension ShowDetailViewController {
    public func collectionView(_ collectionView: UICollectionView, didEndDisplaying cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        cancelCellControllerLoad(forRowAt: indexPath)
    }
    
    public func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        model[indexPath.row].selection((collectionView.cellForItem(at: indexPath) as! ShowEpisodeCell).imageView.image!)
    }
}

// MARK: - FeedViewController DataSourcePrefetching
extension ShowDetailViewController: UICollectionViewDataSourcePrefetching {
    public func collectionView(_ collectionView: UICollectionView, prefetchItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach { indexPath in
            cellController(forRowAt: indexPath).preload()
        }
    }
    
    public func collectionView(_ collectionView: UICollectionView, cancelPrefetchingForItemsAt indexPaths: [IndexPath]) {
        indexPaths.forEach(cancelCellControllerLoad)
    }
}

extension ShowDetailViewController: ShowEpisodeLoadingView {
    public func display(_ viewModel: ShowEpisodeLoadingViewModel) {
        episodesCollectionView.refreshControl?.update(isRefreshing: viewModel.isLoading)
    }
}

