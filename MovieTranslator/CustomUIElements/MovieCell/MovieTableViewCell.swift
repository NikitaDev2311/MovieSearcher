//
//  MovieCell.swift
//  MovieTranslator
//
//  Created by Никита on 09.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

class MovieTableViewCell : UITableViewCell {
    
    @IBOutlet weak var movieNameLabel: UILabel!
    @IBOutlet weak var infoView: UIView!
    @IBOutlet weak var coverImageView: UIImageView!
    @IBOutlet weak var yearOfReleaseLabel: UILabel!
    @IBOutlet weak var genreNameLabel: UILabel!
    @IBOutlet weak var generalView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        initialSetup()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieNameLabel.text = ""
        self.yearOfReleaseLabel.text = ""
        self.genreNameLabel.text = ""
        self.coverImageView.image = UIImage()
    }
    
    //MARK: - Public
    func load(withMovie movie: MovieModel?) {
        guard let movie = movie else { return }
        DispatchQueue.main.async {
            if (movie.genres?.count)! < 1 {
                MovieModel.setGenres(genres: MoviesViewController.genres, forMovie: movie)
            }

            MovieModel.setGenre(ofMovie: movie, toLabel: self.genreNameLabel)
        }
        self.movieNameLabel.text = movie.title ?? noTitle
        self.coverImageView.setImage(withImageURL: movie.imageUrl)
        self.yearOfReleaseLabel.text = noDate
        //Set date label text after formatting
        guard let releaseDateString = movie.releaseDateString else {movie.releaseDateString = noDate;return}
        let dateString = MovieModel.getPrefixBeforeCharacter(character: "-", fromString: releaseDateString)
        movie.releaseDateString = dateString == "" ? noDate : dateString
        let formattedDateString =  String(format: "\(movie.releaseDateString ?? ""), ")
        self.yearOfReleaseLabel.text = formattedDateString
        
    }
    
    //MARK: - Private
    
    private func initialSetup() {
        self.coverImageView?.layer.masksToBounds = true
        self.coverImageView?.layer.cornerRadius = cornerRadiusValue
        self.coverImageView?.contentMode = .scaleAspectFill
        self.movieNameLabel.textAlignment = .center
        self.generalView.clipsToBounds = true
        self.generalView.layer.cornerRadius = cornerRadiusValue
    }
    
}
