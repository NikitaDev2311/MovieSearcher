//
//  Constants.swift
//  MovieTranslator
//
//  Created by Никита on 09.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit

let apiKey = "9012450638ca1a926b6b56e8551b4d38"

let host = "https://api.themoviedb.org/3"

let imageUrlPrefix = "https://image.tmdb.org/t/p/w500"

let videoAppendToResponse = "videos"

public typealias arrayBlock = ([Any]?, String?) -> Void

public typealias objectBlock = (Any?, String?) -> Void

public enum ParsingError :String {
    case getDataError = "Can't get data from JSON"
    case parseError = "Can't parse the objects"
}
