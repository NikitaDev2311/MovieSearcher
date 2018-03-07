//
//  Movie.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import ObjectMapper

class MovieModel : BaseModel {
    
    var id : Int?
    var title : String?
    var releaseDateString : String?
    var genreIDs : [Int?]?
    var genres : [String?]? = [String]()
    var imagePosterPath : String?
    var imageUrl : String?
    var description : String?
    var originalLanguage : String?
    var movieInfo : MovieInfo?
    var productionCountry : String?
    var movieDuration : Int?
    
    
    //support properties for get movie genre
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.id                     <- map["id"]
        self.title                  <- map["original_title"]
        self.releaseDateString      <- map["release_date"]
        self.genreIDs               <- map["genre_ids"]
        self.imagePosterPath        <- map["poster_path"]
        self.description            <- map["overview"]
        self.originalLanguage       <- map["original_language"]
        self.genres                 <- map["genres"]
        
        //init image url
        guard let imagePosterPath = self.imagePosterPath else { return }
        self.imageUrl = imageUrlPrefix + imagePosterPath
        
    }
}

class MovieInfo : BaseModel {
    
    var productionCountries : [[String : String]]?
    var productionCountryName : String?
    var duration : Int?
    var videosDictionariesArray : [String : Any]?
    var videoResults: [[String : Any]]?
    var movieTrailerKey : String?
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.productionCountries          <- map["production_countries"]
        self.duration                     <- map["runtime"]
        self.videosDictionariesArray      <- map["videos"]
        self.videoResults = videosDictionariesArray?["results"] as? [[String : Any]]
        
        guard let results = self.videoResults else {return}
        if results.count > 0 {
            guard let key = results[0]["key"] as? String else {return}
            self.movieTrailerKey = key
        }
    
        guard let productionCountries = self.productionCountries else { return }
        if productionCountries.count > 0 {
        self.productionCountryName = productionCountries[0]["name"]
        }
        
    }
}

