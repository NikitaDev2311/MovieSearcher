//
//  MovieDetailViewController.swift
//  MovieTranslator
//
//  Created by Никита on 13.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import YouTubePlayer
import WebKit

class MovieDetailViewController : UIViewController, UIScrollViewDelegate {
    //UI
    @IBOutlet weak var detailMovieScrollView: UIScrollView!
    @IBOutlet weak var trailerContainerView: UIView!
    @IBOutlet weak var posterImageView: UIImageView!
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var releaseDateLabel: UILabel!
    @IBOutlet weak var countryNameLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var movieDurationLabel: UILabel!
    @IBOutlet weak var movieLanguageLabel: UILabel!
    @IBOutlet weak var descriptionView: UIView!
    @IBOutlet weak var descriptionTextLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var showTrailerButton: UIButton!
    //Navigation
    lazy var router : Router = {
        Router(self.navigationController)
    }()
    //Data
    var movie : MovieModel?
    var movieInfo : MovieInfo?
    var results : [[String : Any]]?
    var movieTrailerKey : String?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        setNavigationBarTitleIfNeed()
    }
    
    //MARK: - Private
    
    private func initialSetup() {
        prepareContent()
    }
    
    private func prepareContent() {
        getMovieInfo(byID: movie!.id!)
    }
    
    @IBAction func playMovieTrailer(_ sender: Any) {
        if (movieTrailerKey != nil) {
            router.showTrailerViewController(withMovieTrailerKey: movieTrailerKey!)
        }
    }
    
    private func displayMovieProperties() {
        guard let movie = movie else { return }
        self.posterImageView.setImage(withImageURL: movie.imageUrl)
        self.movieNameLabel.text = movie.title ?? "No title"
        MovieModel.setGenre(ofMovie: movie, toLabel: self.genreNameLabel)
        self.releaseDateLabel.text = String(format:"\(movie.releaseDateString ?? "No date"),")
        self.movieLanguageLabel.text = movie.originalLanguage?.capitalized
        self.descriptionTextLabel.text = movie.description == "" ? "No description" : movie.description ?? "No description"
        self.movieDurationLabel.text = MovieModel.getString(ofMovieDuration: movie.movieDuration ?? 0)
        self.countryNameLabel.text = movie.productionCountry ?? "Unknown country"
    }
    
    //MARK: API Requests
    private func getMovieInfo(byID id: Int) {
        showLoading()
        MovieService.shared.getMoviePrimaryInfo(byMovieID: id, appendToResponse: videoAppendToResponse) { [weak self] (movieInfo, error) in
            let weakSelf = self
            weakSelf?.movieInfo = movieInfo as? MovieInfo
            weakSelf?.movie!.productionCountry = weakSelf?.movieInfo?.productionCountryName
            weakSelf?.movie!.movieDuration = weakSelf?.movieInfo?.duration
            if let results = weakSelf?.movieInfo?.videosDictionariesArray!["results"] as? [[String : Any]] {
                weakSelf?.results = results
                if results.count > 1 {
                    weakSelf?.movieTrailerKey =  results[1]["key"] as? String
                }
            }
            weakSelf?.settingsUI()
            weakSelf?.displayMovieProperties()
            weakSelf?.hideLoading()
        }
        
    }
    
    //MARK: - Customize UI
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        autoLayoutSettings()
    }
    
    func autoLayoutSettings() {
        makeConstraints()
    }
    
    func settingsUI() {
        detailMovieScrollView.delegate = self
        detailMovieScrollView.contentInsetAdjustmentBehavior = .never
        detailMovieScrollView.indicatorStyle = .black
        detailMovieScrollView.scrollIndicatorInsets = view.safeAreaInsets
        detailMovieScrollView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom: view.safeAreaInsets.bottom, right: 0)
        descriptionView.backgroundColor = detailMovieScrollView.backgroundColor
        infoView.backgroundColor = detailMovieScrollView.backgroundColor
        self.navigationController?.navigationBar.topItem!.title = ""
        self.navigationItem.title = movieDetailsNavigationBarTitle
        showTrailerButton.isEnabled = false
        if movieTrailerKey == nil {
            showTrailerButton.titleLabel?.text = "No trailer"
            showTrailerButton.titleLabel?.textColor = .red
        } else {
            showTrailerButton.isEnabled = true
        }
    }
    
    private func setNavigationBarTitleIfNeed() {
        if self.navigationItem.title == nil {
            self.navigationItem.title = movieDetailsNavigationBarTitle
        }
    }
    
    func makeConstraints() {
      
        let navigationBarHeight = self.navigationController?.navigationBar.frame.size.height
        
        trailerContainerView.snp.makeConstraints {
            make in
            
            make.top.equalTo(detailMovieScrollView).inset(navigationBarHeight!)
            make.left.right.equalTo(view)
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
        
        detailMovieScrollView.snp.makeConstraints {
            make in
            
            make.edges.equalTo(view)
        }
        
        posterImageView.snp.makeConstraints {
            make in
            
            
            make.left.right.equalTo(trailerContainerView)
            make.top.equalTo(view).offset(navigationBarHeight!+navigationBarHeight!).priority(.high)
            make.height.greaterThanOrEqualTo(trailerContainerView.snp.height).priority(.required)
            make.bottom.equalTo(trailerContainerView.snp.bottom)
        }
        
        infoView.snp.makeConstraints {
            make in
            
            make.top.equalTo(trailerContainerView.snp.bottom).offset(20)
            make.left.right.equalTo(view)
            make.height.equalTo(infoView.snp.width).multipliedBy(0.5)
        }
        
        descriptionView.snp.makeConstraints {
            make in
            
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.equalTo(view)
            make.height.lessThanOrEqualTo(view.snp.height).multipliedBy(0.5)
            make.bottom.equalTo(detailMovieScrollView)
        }
        
        descriptionTextLabel.snp.makeConstraints {
            make in
            
            make.top.equalTo(descriptionView).offset(30)
            make.left.equalTo(descriptionView).offset(30)
            make.right.equalTo(descriptionView).inset(30)
        }
        
        descriptionLabel.snp.makeConstraints {
            make in
            
            make.left.equalTo(descriptionTextLabel.snp.left)
            make.top.equalTo(descriptionView)
        }
 
 }

    
}
        

    

