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
        
//        self.movieInfo = 
        //init image url
        guard let imagePosterPath = self.imagePosterPath else { return }
        self.imageUrl = imageUrlPrefix + imagePosterPath
        //get substring format "YYYY" from Date string format "YYYY-MM-dd"
        guard let releaseDateString = self.releaseDateString else { return }
        self.releaseDateString = releaseDateString.substring(to: releaseDateString.characters.index(of: "-")!)
        
    }
}

class MovieInfo : BaseModel {
    
    var productionCountries : [[String : String]]?
    var productionCountryName : String?
    var duration : Int?
    
    public required init?(map: Map) {
        super.init(map: map)
    }
    
    public override func mapping(map: Map) {
        super.mapping(map: map)
        
        self.productionCountries          <- map["production_countries"]
        self.duration                     <- map["runtime"]
        
        guard let productionCountries = self.productionCountries else { return }
        if productionCountries.count > 0 {
        self.productionCountryName = productionCountries[0]["name"]
        }
        
    }
}

