//
//  Constants.swift
//  MovieTranslator
//
//  Created by Никита on 14.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)

let defaultMoviePage = 1

let popularMoviesNavigationBarTitle = "Popular movies"
let searchResultsNavigationBarTitle = "Search results"
let movieDetailsNavigationBarTitle = "Movie details"
let videoAppendToResponse = "videos"
let noTitle = "No title"
let noDate = "No date"
let noTrailer = "No trailer"
let noDescription = "No description"
let unknownCountry = "Unknown country"
let whiteSpace = " " as Character
let disallowedCharacters = " !?()=*:;^%$#@!~№,._<>/|"
let noMovieDurationValue = 0
let cornerRadiusValue = 5 as CGFloat
let tableViewRowHeight = 300 as CGFloat
let youtoubeURLPrefix = "https://www.youtube.com/watch?v="
let searchTimerInterval = 1.0
let topIndexPath = IndexPath(row: 0, section: 0)
let screenWidth = UIScreen.main.bounds.width
let onePageMoviesCount = 20
enum UserDefaultsKeys : String {
    case isFirstSearch = "isFirstSearch"
    
    
}
