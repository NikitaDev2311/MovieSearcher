//
//  ApiMethods.swift
//  MovieTranslator
//
//  Created by Никита on 09.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation

public enum ApiMethod : String {
    //get movies
    case movies = "/movie/popular"
    //get movie primary info by movie_id
    case movieInfo = "/movie/%i"
    //get movies by specific genre using genre id
    case genre = "/genre/%@/movies"
    //search the movie by title
    case search = "/search/movie"
    //get genres list
    case genreList = "/genre/movie/list"
    
}
