//
//  MovieDetailViewController.swift
//  MovieTranslator
//
//  Created by Никита on 13.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

class MovieDetailViewController : BaseViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var fullScreenScrollView: UIScrollView!
    @IBOutlet weak var fullScreenImageView: UIImageView!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var detailMovieScrollView: UIScrollView!
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
    
    var movie : MovieModel?
    var movieInfo : MovieInfo?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(true)
        setScrollViewContentSize()
    }
    
    //MARK: - Actions
    
    @IBAction func playMovieTrailer(_ sender: Any) {
        guard let key = movieInfo?.movieTrailerKey else {return}
        router.showTrailerViewController(withMovieTrailerKey: key)
    }
    
    
    @IBAction func openImageInFullScreen(_ sender: Any) {
        openImageInFullScreenMode()
    }
    
    @IBAction func hideFullScreenMode(_ sender: Any) {
        closeFullScreenMode()
    }
    
    //MARK: - Private
    
    private func initialSetup() {
        prepareContent()
        setNavigationBarTitleIfNeed()
    }
    
    private func prepareContent() {
        guard let movieID = movie?.id else {return}
        getMovieInfo(byID: movieID)
    }
    
    private func displayMovieProperties() {
        guard let movie = movie else { return }
        self.posterImageView.setImage(withImageURL: movie.imageUrl)
        self.fullScreenImageView.image = self.posterImageView.image
        self.movieNameLabel.text = movie.title ?? noTitle
        MovieModel.setGenre(ofMovie: movie, toLabel: self.genreNameLabel)
        self.releaseDateLabel.text = String(format:"\(movie.releaseDateString ?? noDate),")
        self.movieLanguageLabel.text = movie.originalLanguage?.capitalized
        guard let description = movie.description else {self.descriptionTextLabel.text = noDescription;return}
        self.descriptionTextLabel.text = description == "" ? noDescription : description
        self.movieDurationLabel.text = MovieModel.getString(ofMovieDuration: movie.movieDuration ?? noMovieDurationValue)
        self.countryNameLabel.text = movie.productionCountry ?? unknownCountry
    }
    
    //MARK: API Requests
    private func getMovieInfo(byID id: Int) {
        showLoading()
        MovieService.shared.getMoviePrimaryInfo(byMovieID: id, appendToResponse: videoAppendToResponse) { [weak self] (movieInfo, error) in
            let weakSelf = self
            weakSelf?.hideLoading()
            weakSelf?.movieInfo = movieInfo as? MovieInfo
            weakSelf?.movie!.productionCountry = weakSelf?.movieInfo?.productionCountryName
            weakSelf?.movie!.movieDuration = weakSelf?.movieInfo?.duration
            weakSelf?.displayMovieProperties()
            weakSelf?.settingsUI()
            
        }
    }
    
    //MARK: - Customize UI
    
    private func settingsUI() {
        scrollViewsSettings()
        title = ""
        setNavigationBarTitleIfNeed()
        showTrailerButton.isEnabled = false
        if movieInfo?.movieTrailerKey == nil {
            trailerButtonSettings()
        } else {
            showTrailerButton.isEnabled = true
        }
    }
    
    func setScrollViewContentSize() {
        detailMovieScrollView.contentSize = CGSize(width: screenWidth, height: descriptionView.frameBottom() + 20)
    }
    
    private func openImageInFullScreenMode() {
        showHideNavigationBar()
        showHideStatusBar()
        showScrollViewAnimated()
    }
    
    private func closeFullScreenMode() {
        showHideNavigationBar()
        showHideStatusBar()
        hideScrollViewAnimated()
    }
    
    private func showHideStatusBar() {
        let statusBarHidden = UIApplication.shared.isStatusBarHidden
        UIApplication.shared.isStatusBarHidden = !statusBarHidden
    }
    
    private func showHideNavigationBar() {
        guard let navigationBarHidden = navigationController?.navigationBar.isHidden else {return}
        navigationController?.setNavigationBarHidden(!navigationBarHidden, animated: false)
    }
    
    private func scrollViewsSettings() {
        detailMovieScrollView.delegate = self
        fullScreenScrollView.delegate = self
        fullScreenImageView.contentMode = .scaleAspectFill
        fullScreenImageView.frame = fullScreenScrollView.frame
    }
    
    private func showScrollViewAnimated() {
        let scaleTransform = CGAffineTransform(scaleX: scrollViewScaleFrom.x, y: scrollViewScaleFrom.y)
        fullScreenScrollView.transform = scaleTransform
        UIView.animate(withDuration: scrollViewAnimationsDuration, animations:  {
            self.detailMovieScrollView.isHidden = true
            self.fullScreenScrollView.isHidden = false
            self.view.bringSubview(toFront: self.fullScreenScrollView)
             self.fullScreenScrollView.transform = CGAffineTransform(scaleX: scrollViewScaleTo.x, y: scrollViewScaleTo.y)
        })
    }
    
    private func imageViewCentering() {
        fullScreenImageView.center = fullScreenScrollView.center
    }
    
    private func hideScrollViewAnimated() {
        let scaleTransform = CGAffineTransform(scaleX: scrollViewScaleFrom.x, y: scrollViewScaleFrom.y)
        let toX = posterImageView.frame.origin.x
        let toY = posterImageView.frame.origin.y - posterImageView.frame.size.height
        let scaleAndTranslateTransform = scaleTransform.translatedBy(x: toX, y: toY)
        UIView.animate(withDuration: scrollViewAnimationsDuration, animations: {
            self.detailMovieScrollView.isHidden = false
            self.fullScreenScrollView.transform = scaleAndTranslateTransform
        }) { (finished) in
            self.fullScreenScrollView.isHidden = true
            self.fullScreenScrollView.transform = .identity
            self.view.sendSubview(toBack: self.fullScreenScrollView)
        }
    }
    
    private func trailerButtonSettings() {
        showTrailerButton.setTitle(String(format:"🎬 \(noTrailer)"), for: .normal)
        showTrailerButton.setTitleColor(.red, for: .normal)
    }
    
    private func setNavigationBarTitleIfNeed() {
        navigationController?.setNavigationBarHidden(false, animated: true)
        title = movieDetailsNavigationBarTitle
    }
    
    //MARK: - UIScrollViewDelegate
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        setScrollViewContentSize()
    }
    
    func viewForZooming(in scrollView: UIScrollView) -> UIView? {
        return fullScreenImageView
    }
    
    func scrollViewDidZoom(_ scrollView: UIScrollView) {
        if scrollView.zoomScale <= 1 {
            imageViewCentering()
        }
    }
}
        

    

