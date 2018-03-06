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

class MovieDetailViewController : BaseViewController, UIScrollViewDelegate, UIGestureRecognizerDelegate {
    
    
    @IBOutlet weak var fullScreenScrollView: UIScrollView!
    @IBOutlet weak var fullScreenImageView: UIImageView!
    
    @IBOutlet weak var containerView: UIView!
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
    
    
    @IBAction func action(_ sender: Any) {
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
    
    private func openImageInFullScreenMode() {
        navigationController?.setNavigationBarHidden(true, animated: true)
        UIApplication.shared.statusBarStyle = .default
        UIApplication.shared.isStatusBarHidden = true
        showScrollViewAnimated()
//        fullScreenScrollView.isHidden = false
    }
    
    private func closeFullScreenMode() {
        navigationController?.setNavigationBarHidden(false, animated: false)
        UIApplication.shared.isStatusBarHidden = false
        hideScrollViewAnimated()
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
    
    func setScrollViewContentSize() {
        detailMovieScrollView.contentSize = CGSize(width: screenWidth, height: descriptionView.frameBottom() + 20)
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
    
    private func scrollViewsSettings() {
        detailMovieScrollView.delegate = self
        fullScreenScrollView.delegate = self
        fullScreenScrollView.minimumZoomScale = 0.5
        fullScreenScrollView.maximumZoomScale = 3.0
        fullScreenScrollView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        fullScreenImageView.contentMode = .scaleAspectFit
        fullScreenImageView.autoresizingMask = [.flexibleLeftMargin, .flexibleRightMargin]
        fullScreenImageView.frame = fullScreenScrollView.frame
    }
    
    private func showScrollViewAnimated() {
        UIView.animate(withDuration: 0.2, animations: {
            self.fullScreenScrollView.isHidden = false
            self.view.bringSubview(toFront: self.fullScreenScrollView)
            self.fullScreenScrollView.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
        }) { (finished) in
            UIView.animate(withDuration: 0.2, animations: {
                self.fullScreenScrollView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    private func hideScrollViewAnimated() {
        let scaleTransform = CGAffineTransform(scaleX: 0.05, y: 0.05)
        let toX = posterImageView.frame.origin.x
        let toY = posterImageView.frame.origin.y - posterImageView.frame.size.height
        let scaleAndTranslateTransform = scaleTransform.translatedBy(x: toX, y: toY)
        UIView.animate(withDuration: 0.3, animations: {
            self.fullScreenScrollView.transform = scaleAndTranslateTransform
        }) { (finished) in
            self.fullScreenScrollView.transform = .identity
            self.fullScreenScrollView.isHidden = true
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
        fullScreenImageView.center = fullScreenScrollView.center
    }
    
    func scrollViewDidEndZooming(_ scrollView: UIScrollView, with view: UIView?, atScale scale: CGFloat) {
        fullScreenImageView.center = fullScreenScrollView.center
        if scrollView.zoomScale < 1 {
            UIView.animate(withDuration: 0.05, animations: {
                self.fullScreenImageView.transform = CGAffineTransform(scaleX: 1, y: 1)
            })
        }
    }
    
    
}
        

    

