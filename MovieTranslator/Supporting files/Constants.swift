//
//  Constants.swift
//  MovieTranslator
//
//  Created by Никита on 14.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

//MARK: - UserDefaults Constants
enum UserDefaultsKeys : String {
    case isFirstSearch = "isFirstSearch"
    case isFirstGet = "isFirstGet"
}

//MARK: - UI Constants
let mainStoryboard = UIStoryboard(name: "Main", bundle: nil)
let screenWidth = UIScreen.main.bounds.width
let cornerRadiusValue = 5 as CGFloat
let tableViewRowHeight = 300 as CGFloat
let topIndexPath = IndexPath(row: 0, section: 0)
let scrollViewScaleFrom = CGPoint(x: 0.05, y: 0.05)
let scrollViewScaleTo = CGPoint(x: 1, y: 1)
let scrollViewAnimationsDuration = 0.3
let scrollViewOffset = 20.0 as CGFloat

//MARK: - Titles
let popularMoviesNavigationBarTitle = "Popular movies"
let searchResultsNavigationBarTitle = "Search results"
let movieDetailsNavigationBarTitle = "Movie details"
let okTitle = "OK"
let errorTitle = "Error"

//MARK: - No data constants
let noTitle = "No title"
let noDate = "No date"
let noTrailer = "No trailer"
let noGenre = "No genre"
let noDuration = "No duration"
let noDescription = "No description"
let unknownCountry = "Unknown country"
let settingsTitle = "Settings"
let noMovieDurationValue = 0

//MARK: - Strings
let whiteSpace = " " as Character
let disallowedCharacters = "!?()=*:;^%$#@!~№,._<>/|"
let networkMessage = "Your device does not connected to network!"

//MARK: - Any Constants
let defaultMoviePage = 1
let onePageMoviesCount = 20
let searchTimerInterval = 1.0
let countMinutesInHour = 60




