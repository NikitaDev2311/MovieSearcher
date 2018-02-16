//
//  Extension.swift
//  MovieTranslator
//
//  Created by Никита on 12.02.2018.
//  Copyright © 2018 Никита. All rights reserved.
//

import Foundation
import UIKit
import Alamofire

extension UIImageView {
    
   static func loadImageFromURLString(_ urlString: String) -> UIImage? {
        if let url = URL(string: urlString) {
            let request = NSMutableURLRequest(url: url)
            request.timeoutInterval = 30.0
            var response: URLResponse?
            let error: NSErrorPointer? = nil
            var data: Data?
            do {
                data = try NSURLConnection.sendSynchronousRequest(request as URLRequest, returning: &response)
            } catch let error1 as NSError {
                error??.pointee = error1
                data = nil
            }
            if (data != nil) {
                return UIImage(data: data!)
            }
        }
        return nil
    }
}

extension MovieModel {
    static func setGenre(ofMovie movie: MovieModel, toLabel label: UILabel) {
        guard let movieGenres = movie.genres else { return }
        label.text = (movieGenres as NSArray).componentsJoined(by: ",")
    }
    
    static func setGenres(genres: [GenreModel], forMovie movie: MovieModel) {
        for i in 0..<genres.count {
            for j in 0..<(movie.genreIDs?.count)! {
                if movie.genreIDs![j] == genres[i].id {
                    movie.genres?.append(genres[i].name!)
                }
            }
        }
    }
    
    static func getString(ofMovieDuration duration: Int) -> String {
        var durationString = ""
        let countMinutesInHour = 60
        let hoursCount = duration/countMinutesInHour
        let minutesCount = duration - hoursCount*countMinutesInHour
        if duration > countMinutesInHour {
            if hoursCount < 2 {
                durationString = String(format:"\(hoursCount) hour \(minutesCount) min")
            }
            else {
                durationString = String(format:"\(hoursCount) hours \(minutesCount) min")
            }
        }
        else {
            durationString = String(format:"\(duration) min")
        }
        return durationString
    }
}
