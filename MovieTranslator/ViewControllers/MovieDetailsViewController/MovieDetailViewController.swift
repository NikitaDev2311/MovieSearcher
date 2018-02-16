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
    
    //Data
    var movie : MovieModel?
    var movieInfo : MovieInfo?
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    //MARK: - Private
    
    private func initialSetup() {
        prepareContent()
        settingsUI()
    }
    
    private func prepareContent() {
        getMovieInfo(byID: movie!.id!)
    }
    
    private func displayMovieProperties() {
        guard let movie = movie else { return }
        self.posterImageView.image = UIImageView.loadImageFromURLString(movie.imageUrl!)
        self.movieNameLabel.text = movie.title
        MovieModel.setGenre(ofMovie: movie, toLabel: self.genreNameLabel)
        self.releaseDateLabel.text = String(format:"\(movie.releaseDateString!),")
        self.movieLanguageLabel.text = movie.originalLanguage?.capitalized
        self.descriptionTextLabel.text = movie.description
        self.movieDurationLabel.text = MovieModel.getString(ofMovieDuration: movie.movieDuration!)
        self.countryNameLabel.text = movie.productionCountry
    }
    
    //MARK: API Requests
    
    private func getMovieInfo(byID id: Int) {
        MovieService.shared.getMoviePrimaryInfo(byMovieID: id) { [weak self] (movieInfo, error) in
            let weakSelf = self
            weakSelf?.movieInfo = movieInfo as? MovieInfo
            weakSelf?.movie!.productionCountry = weakSelf?.movieInfo?.productionCountryName
            weakSelf?.movie!.movieDuration = weakSelf?.movieInfo?.duration
            weakSelf?.displayMovieProperties()
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
        self.navigationItem.title = "Movie details"
    }
    
    func makeConstraints() {
        trailerContainerView.snp.makeConstraints {
            make in
            
            make.top.equalTo(detailMovieScrollView)
            make.left.right.equalTo(view)
            make.height.equalTo(view.snp.height).multipliedBy(0.7)
        }
        
        posterImageView.snp.makeConstraints {
            make in
            make.left.right.equalTo(trailerContainerView)
            make.top.equalTo(view).inset(20)
            make.bottom.equalTo(trailerContainerView.snp.bottom)
        }
        
        detailMovieScrollView.snp.makeConstraints {
            make in
            
            make.edges.equalTo(view)
        }
        
        posterImageView.snp.makeConstraints {
            make in
            
            make.left.right.equalTo(trailerContainerView)
            make.top.equalTo(view).priority(.high)
            make.height.greaterThanOrEqualTo(trailerContainerView.snp.height).priority(.required)
            make.bottom.equalTo(trailerContainerView.snp.bottom)
        }
        
        infoView.snp.makeConstraints {
            make in
            
            make.top.equalTo(trailerContainerView.snp.bottom)
            make.left.right.equalTo(view)
            make.height.equalTo(infoView.snp.width).multipliedBy(0.5)
        }
        
        descriptionView.snp.makeConstraints {
            make in
            
            make.top.equalTo(infoView.snp.bottom)
            make.left.right.equalTo(view)
            make.bottom.equalTo(detailMovieScrollView)
        }
        
        descriptionTextLabel.snp.makeConstraints {
            make in
            
            make.edges.equalTo(descriptionView).inset(30)
            make.bottom.equalTo(descriptionView)
        }
        
        descriptionLabel.snp.makeConstraints {
            make in
            
            make.left.equalTo(descriptionTextLabel.snp.left)
            make.top.equalTo(descriptionView)
        }
    }
    
    
    //MARK: - Scroll View Delegate
    
    private var previousStatusBarHidden = false
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if previousStatusBarHidden != shouldHideStatusBar {
            UIView.animate(withDuration: 0.2, animations: {
                self.setNeedsStatusBarAppearanceUpdate()
            })
            previousStatusBarHidden = shouldHideStatusBar
        }
    }
    
    //MARK: - Status Bar Appearance
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    override var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return .slide
    }
    
    override var prefersStatusBarHidden: Bool {
        return shouldHideStatusBar
    }
    
    private var shouldHideStatusBar: Bool {
        guard let view = infoView else { return false }
        let frame = view.convert(view.bounds, to: nil)
        return frame.minY < view.safeAreaInsets.top
    }
    
}
        

    

