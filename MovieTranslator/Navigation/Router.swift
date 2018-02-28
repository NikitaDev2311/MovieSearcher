//
//  Router.swift
//  MovieTranslator
//
//  Created by Никита on 26.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

class Router : NSObject {
    
    private let navigationController : UINavigationController?
    
    //MARK: - Initializatior -
    
    init(_ navigationController: UINavigationController?) {
        self.navigationController = navigationController
    }
    
    //MARK: - Public -
    
    func showMovieDetailViewController(forMovie movie: MovieModel) {
        let detailMovieViewController = mainStoryboard.instantiateViewController(withIdentifier: String(describing: MovieDetailViewController.self)) as! MovieDetailViewController
        detailMovieViewController.movie = movie
        self.navigationController?.pushViewController(detailMovieViewController, animated: true)
    }
    
    func showTrailerViewController(withMovieTrailerKey key : String) {
        let trailerViewController = mainStoryboard.instantiateViewController(withIdentifier: String(describing: TrailerViewController.self)) as! TrailerViewController
        trailerViewController.videoKey = key
        self.navigationController?.pushViewController(trailerViewController, animated: true)
    }
    
    
    
}
