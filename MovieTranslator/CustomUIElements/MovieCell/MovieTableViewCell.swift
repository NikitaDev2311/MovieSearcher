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
    
    func load(withMovie movie: MovieModel?) {
        guard let movie = movie else { return }
        if movie.genres?.count == 0 {
        MovieModel.setGenres(genres: MoviesViewController.genres, forMovie: movie)
        }
        self.movieNameLabel.text = movie.title
        //set genre name to the label
        MovieModel.setGenre(ofMovie: movie, toLabel: self.genreNameLabel)
        self.coverImageView.image = UIImageView.loadImageFromURLString(movie.imageUrl!)
        self.yearOfReleaseLabel.text = String(format: "\(String(describing: movie.releaseDateString!)), ") 
        
        
        
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        self.movieNameLabel.text = ""
        self.yearOfReleaseLabel.text = ""
        self.genreNameLabel.text = ""
        self.coverImageView.image = UIImage()
    }
    
    func initialSetup() {
        self.coverImageView?.layer.masksToBounds = true
        self.coverImageView?.layer.cornerRadius = 5
        self.coverImageView?.contentMode = .scaleAspectFit
        self.movieNameLabel.textAlignment = .center
        self.generalView.clipsToBounds = true
        self.generalView.layer.cornerRadius = 5
        
    }
    
}
